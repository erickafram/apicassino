import promisePool from "../database"
import { ResultSetHeader, RowDataPacket } from "mysql2"

interface UserBalance {
   id: number
   username: string
   saldo: number
   balance_bonus: number
   balance_withdrawal: number
   balance_bonus_rollover: number
   balance_deposit_rollover: number
   currency: string
   symbol: string
   balance_type: string
   total_bet: number
   total_won: number
   total_lose: number
}


interface BalanceTransaction {
   user_id: number
   agent_id: number
   game_code: string
   type: 'bet' | 'win' | 'refund' | 'bonus' | 'jackpot'
   amount: number
   balance_before: number
   balance_after: number
   balance_type: 'balance' | 'balance_bonus' | 'balance_withdrawal'
   currency: string
   bet_amount?: number
   win_amount?: number
   provider?: string
   aggregator?: string
   transaction_id?: string
   reference_id?: string
   session_id?: string
   round_id?: string
}

export default {
   /**
    * Obter saldo total do usuário (compatível com cassino)
    */
   async getTotalBalance(userId: number): Promise<number> {
      const [rows] = await promisePool.query<RowDataPacket[]>(
         "SELECT saldo, balance_bonus, balance_withdrawal FROM users WHERE id = ?",
         [userId]
      )
      
      if (rows.length === 0) return 0
      
      const user = rows[0]
      return parseFloat(user.saldo) + parseFloat(user.balance_bonus) + parseFloat(user.balance_withdrawal)
   },

   /**
    * Obter saldo por tipo específico
    */
   async getBalanceByType(userId: number, balanceType: string): Promise<number> {
      const fieldMap: { [key: string]: string } = {
         'balance': 'saldo',
         'balance_bonus': 'balance_bonus', 
         'balance_withdrawal': 'balance_withdrawal'
      }
      
      const field = fieldMap[balanceType] || 'saldo'
      
      const [rows] = await promisePool.query<RowDataPacket[]>(
         `SELECT ${field} as balance FROM users WHERE id = ?`,
         [userId]
      )
      
      return rows.length > 0 ? parseFloat(rows[0].balance) : 0
   },

   /**
    * Atualizar saldo por tipo
    */
   async updateBalanceByType(
      userId: number, 
      balanceType: string, 
      amount: number, 
      operation: 'add' | 'subtract' | 'set' = 'set'
   ): Promise<boolean> {
      const fieldMap: { [key: string]: string } = {
         'balance': 'saldo',
         'balance_bonus': 'balance_bonus',
         'balance_withdrawal': 'balance_withdrawal'
      }
      
      const field = fieldMap[balanceType] || 'saldo'
      
      let query = ""
      let params: any[] = []
      
      switch (operation) {
         case 'add':
            query = `UPDATE users SET ${field} = ${field} + ? WHERE id = ?`
            params = [amount, userId]
            break
         case 'subtract':
            query = `UPDATE users SET ${field} = GREATEST(0, ${field} - ?) WHERE id = ?`
            params = [amount, userId]
            break
         case 'set':
            query = `UPDATE users SET ${field} = ? WHERE id = ?`
            params = [amount, userId]
            break
      }
      
      const [result] = await promisePool.query<ResultSetHeader>(query, params)
      return result.affectedRows > 0
   },

   /**
    * Processar transação com controle de rollover
    */
   async processTransaction(transaction: BalanceTransaction): Promise<boolean> {
      const connection = await promisePool.getConnection()
      
      try {
         await connection.beginTransaction()
         
         // Obter saldo atual
         const balanceBefore = await this.getBalanceByType(transaction.user_id, transaction.balance_type)
         
         let balanceAfter = balanceBefore
         let rolloverUpdate = ""
         
         // Processar baseado no tipo de transação
         switch (transaction.type) {
            case 'bet':
               // Debitar do saldo
               balanceAfter = Math.max(0, balanceBefore - transaction.amount)
               await this.updateBalanceByType(transaction.user_id, transaction.balance_type, transaction.amount, 'subtract')
               
               // Atualizar rollover se for bônus
               if (transaction.balance_type === 'balance_bonus') {
                  rolloverUpdate = ", balance_bonus_rollover = GREATEST(0, balance_bonus_rollover - ?)"
               }
               break
               
            case 'win':
               // Creditar no saldo
               balanceAfter = balanceBefore + transaction.amount
               await this.updateBalanceByType(transaction.user_id, transaction.balance_type, transaction.amount, 'add')
               break
               
            case 'bonus':
               // Adicionar ao saldo de bônus
               balanceAfter = balanceBefore + transaction.amount
               await this.updateBalanceByType(transaction.user_id, 'balance_bonus', transaction.amount, 'add')
               
               // Definir rollover (exemplo: 30x o valor do bônus)
               const rolloverAmount = transaction.amount * 30
               await connection.query(
                  "UPDATE users SET balance_bonus_rollover = balance_bonus_rollover + ? WHERE id = ?",
                  [rolloverAmount, transaction.user_id]
               )
               break
         }
         
         // Registrar transação
         const transactionData = {
            ...transaction,
            balance_before: balanceBefore,
            balance_after: balanceAfter,
            transaction_id: transaction.transaction_id || `TXN_${Date.now()}_${transaction.user_id}`,
            created_at: new Date()
         }
         
         await connection.query(
            `INSERT INTO transactions (
               user_id, agent_id, game_code, type, amount, balance_before, balance_after,
               balance_type, currency, bet_amount, win_amount, provider, aggregator,
               transaction_id, reference_id, session_id, round_id, created_at
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [
               transactionData.user_id, transactionData.agent_id, transactionData.game_code,
               transactionData.type, transactionData.amount, transactionData.balance_before,
               transactionData.balance_after, transactionData.balance_type, transactionData.currency,
               transactionData.bet_amount || 0, transactionData.win_amount || 0,
               transactionData.provider || 'PGSOFT', transactionData.aggregator || 'pgapi',
               transactionData.transaction_id, transactionData.reference_id,
               transactionData.session_id, transactionData.round_id, transactionData.created_at
            ]
         )
         
         // Registrar no GGR (compatibilidade com cassino)
         if (transaction.type === 'bet' || transaction.type === 'win') {
            await connection.query(
               `INSERT INTO ggr_games (
                  user_id, provider, game, balance_bet, balance_win, currency, aggregator, type, created_at
               ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
               [
                  transaction.user_id,
                  transaction.provider || 'PGSOFT',
                  transaction.game_code,
                  transaction.type === 'bet' ? transaction.amount : 0,
                  transaction.type === 'win' ? transaction.amount : 0,
                  transaction.currency,
                  transaction.aggregator || 'pgapi',
                  transaction.type === 'bet' ? 'loss' : 'win',
                  new Date()
               ]
            )
         }
         
         // Atualizar totais do usuário
         await connection.query(
            `UPDATE users SET 
               total_bet = total_bet + ?,
               total_won = total_won + ?,
               total_lose = GREATEST(0, total_bet - total_won),
               updated_at = NOW()
            WHERE id = ?`,
            [
               transaction.type === 'bet' ? transaction.amount : 0,
               transaction.type === 'win' ? transaction.amount : 0,
               transaction.user_id
            ]
         )
         
         await connection.commit()
         return true
         
      } catch (error) {
         await connection.rollback()
         console.error('Erro ao processar transação:', error)
         return false
      } finally {
         connection.release()
      }
   },

   /**
    * Verificar se usuário pode apostar (considerando rollover)
    */
   async canUserBet(userId: number, betAmount: number, balanceType: string = 'balance'): Promise<boolean> {
      const [rows] = await promisePool.query<RowDataPacket[]>(
         `SELECT saldo, balance_bonus, balance_withdrawal, balance_bonus_rollover 
          FROM users WHERE id = ?`,
         [userId]
      )
      
      if (rows.length === 0) return false
      
      const user = rows[0]
      const availableBalance = this.getAvailableBalance(user, balanceType)
      
      return availableBalance >= betAmount
   },

   /**
    * Calcular saldo disponível considerando rollover
    */
   getAvailableBalance(user: any, balanceType: string): number {
      switch (balanceType) {
         case 'balance':
            return parseFloat(user.saldo)
         case 'balance_bonus':
            // Saldo de bônus disponível apenas se rollover foi cumprido
            return parseFloat(user.balance_bonus_rollover) <= 0 ? parseFloat(user.balance_bonus) : 0
         case 'balance_withdrawal':
            return parseFloat(user.balance_withdrawal)
         default:
            return parseFloat(user.saldo)
      }
   },

   /**
    * Obter dados completos do usuário para callback
    */
   async getUserForCallback(userId: number): Promise<UserBalance | null> {
      const [rows] = await promisePool.query<RowDataPacket[]>(
         `SELECT id, username, saldo, balance_bonus, balance_withdrawal, 
                 balance_bonus_rollover, balance_deposit_rollover, currency, symbol,
                 balance_type, total_bet, total_won, total_lose
          FROM users WHERE id = ?`,
         [userId]
      )
      
      return rows.length > 0 ? rows[0] as UserBalance : null
   }
}
