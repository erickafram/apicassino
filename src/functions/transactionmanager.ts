import promisePool from "../database"
import { ResultSetHeader, RowDataPacket } from "mysql2"
import balancefunctions from "./balancefunctions"
import rtpsync from "./rtpsync"
import logger from "../logger"

interface TransactionRequest {
   userId: number
   agentId: number
   gameCode: string
   betAmount: number
   winAmount?: number
   balanceType?: 'balance' | 'balance_bonus' | 'balance_withdrawal'
   currency?: string
   sessionId?: string
   roundId?: string
   transactionId?: string
}

interface TransactionResult {
   success: boolean
   transactionId?: string
   balanceBefore: number
   balanceAfter: number
   message?: string
   error?: string
}

export default {
   /**
    * Processar aposta (débito)
    */
   async processBet(request: TransactionRequest): Promise<TransactionResult> {
      const connection = await promisePool.getConnection()
      
      try {
         await connection.beginTransaction()
         
         // Verificar se usuário pode apostar
         const canBet = await balancefunctions.canUserBet(
            request.userId, 
            request.betAmount, 
            request.balanceType || 'balance'
         )
         
         if (!canBet) {
            await connection.rollback()
            return {
               success: false,
               balanceBefore: 0,
               balanceAfter: 0,
               error: "INSUFFICIENT_FUNDS"
            }
         }
         
         // Obter saldo atual
         const balanceBefore = await balancefunctions.getBalanceByType(
            request.userId, 
            request.balanceType || 'balance'
         )
         
         // Processar transação de aposta
         const transactionResult = await balancefunctions.processTransaction({
            user_id: request.userId,
            agent_id: request.agentId,
            game_code: request.gameCode,
            type: 'bet',
            amount: request.betAmount,
            balance_before: balanceBefore,
            balance_after: balanceBefore - request.betAmount,
            balance_type: request.balanceType || 'balance',
            currency: request.currency || 'BRL',
            bet_amount: request.betAmount,
            win_amount: 0,
            provider: 'PGSOFT',
            aggregator: 'pgapi',
            transaction_id: request.transactionId || `BET_${Date.now()}_${request.userId}`,
            session_id: request.sessionId,
            round_id: request.roundId
         })
         
         if (!transactionResult) {
            await connection.rollback()
            return {
               success: false,
               balanceBefore: balanceBefore,
               balanceAfter: balanceBefore,
               error: "TRANSACTION_FAILED"
            }
         }
         
         const balanceAfter = balanceBefore - request.betAmount
         
         await connection.commit()
         
         // Sincronizar RTP se necessário
         this.checkRTPSync(request.userId)
         
         return {
            success: true,
            transactionId: request.transactionId || `BET_${Date.now()}_${request.userId}`,
            balanceBefore: balanceBefore,
            balanceAfter: balanceAfter
         }
         
      } catch (error) {
         await connection.rollback()
         logger.error(`Erro ao processar aposta: ${error}`)
         return {
            success: false,
            balanceBefore: 0,
            balanceAfter: 0,
            error: "INTERNAL_ERROR"
         }
      } finally {
         connection.release()
      }
   },

   /**
    * Processar ganho (crédito)
    */
   async processWin(request: TransactionRequest): Promise<TransactionResult> {
      const connection = await promisePool.getConnection()
      
      try {
         await connection.beginTransaction()
         
         const winAmount = request.winAmount || 0
         
         // Obter saldo atual
         const balanceBefore = await balancefunctions.getBalanceByType(
            request.userId, 
            request.balanceType || 'balance'
         )
         
         // Processar transação de ganho
         const transactionResult = await balancefunctions.processTransaction({
            user_id: request.userId,
            agent_id: request.agentId,
            game_code: request.gameCode,
            type: 'win',
            amount: winAmount,
            balance_before: balanceBefore,
            balance_after: balanceBefore + winAmount,
            balance_type: request.balanceType || 'balance',
            currency: request.currency || 'BRL',
            bet_amount: request.betAmount,
            win_amount: winAmount,
            provider: 'PGSOFT',
            aggregator: 'pgapi',
            transaction_id: request.transactionId || `WIN_${Date.now()}_${request.userId}`,
            session_id: request.sessionId,
            round_id: request.roundId
         })
         
         if (!transactionResult) {
            await connection.rollback()
            return {
               success: false,
               balanceBefore: balanceBefore,
               balanceAfter: balanceBefore,
               error: "TRANSACTION_FAILED"
            }
         }
         
         const balanceAfter = balanceBefore + winAmount
         
         await connection.commit()
         
         // Sincronizar RTP se necessário
         this.checkRTPSync(request.userId)
         
         return {
            success: true,
            transactionId: request.transactionId || `WIN_${Date.now()}_${request.userId}`,
            balanceBefore: balanceBefore,
            balanceAfter: balanceAfter
         }
         
      } catch (error) {
         await connection.rollback()
         logger.error(`Erro ao processar ganho: ${error}`)
         return {
            success: false,
            balanceBefore: 0,
            balanceAfter: 0,
            error: "INTERNAL_ERROR"
         }
      } finally {
         connection.release()
      }
   },

   /**
    * Processar transação completa (aposta + ganho)
    */
   async processCompleteTransaction(request: TransactionRequest): Promise<TransactionResult> {
      const betResult = await this.processBet(request)
      
      if (!betResult.success) {
         return betResult
      }
      
      // Se há ganho, processar
      if (request.winAmount && request.winAmount > 0) {
         const winRequest = {
            ...request,
            transactionId: `WIN_${request.transactionId || Date.now()}_${request.userId}`
         }
         
         const winResult = await this.processWin(winRequest)
         
         if (!winResult.success) {
            // Se falhou o ganho, tentar reverter a aposta
            await this.refundTransaction(request.userId, betResult.transactionId!)
            return winResult
         }
         
         return {
            success: true,
            transactionId: betResult.transactionId,
            balanceBefore: betResult.balanceBefore,
            balanceAfter: winResult.balanceAfter
         }
      }
      
      return betResult
   },

   /**
    * Reverter transação (refund)
    */
   async refundTransaction(userId: number, transactionId: string): Promise<boolean> {
      try {
         // Buscar transação original
         const [rows] = await promisePool.query<RowDataPacket[]>(
            "SELECT * FROM transactions WHERE transaction_id = ? AND user_id = ?",
            [transactionId, userId]
         )
         
         if (rows.length === 0) {
            logger.error(`Transação ${transactionId} não encontrada para refund`)
            return false
         }
         
         const originalTransaction = rows[0]
         
         // Criar transação de refund
         const refundResult = await balancefunctions.processTransaction({
            user_id: userId,
            agent_id: originalTransaction.agent_id,
            game_code: originalTransaction.game_code,
            type: 'refund',
            amount: originalTransaction.amount,
            balance_before: originalTransaction.balance_after,
            balance_after: originalTransaction.balance_before,
            balance_type: originalTransaction.balance_type,
            currency: originalTransaction.currency,
            bet_amount: 0,
            win_amount: 0,
            provider: originalTransaction.provider,
            aggregator: originalTransaction.aggregator,
            transaction_id: `REFUND_${transactionId}`,
            reference_id: transactionId,
            session_id: originalTransaction.session_id,
            round_id: originalTransaction.round_id
         })
         
         if (refundResult) {
            logger.info(`Refund processado com sucesso para transação ${transactionId}`)
            return true
         }
         
         return false
         
      } catch (error) {
         logger.error(`Erro ao processar refund: ${error}`)
         return false
      }
   },

   /**
    * Verificar se precisa sincronizar RTP
    */
   async checkRTPSync(userId: number): Promise<void> {
      try {
         // Obter RTP atual
         const [rows] = await promisePool.query<RowDataPacket[]>(
            "SELECT rtp, valorapostado, valorganho FROM users WHERE id = ?",
            [userId]
         )
         
         if (rows.length > 0) {
            const user = rows[0]
            const currentRTP = user.rtp
            
            // Calcular novo RTP
            const newRTP = user.valorapostado > 0 ? 
               Math.round((user.valorganho / user.valorapostado) * 100) : 0
            
            // Sincronizar se mudou significativamente
            if (Math.abs(newRTP - currentRTP) > 5) {
               await rtpsync.syncOnSignificantChange(userId, currentRTP, newRTP)
            }
         }
      } catch (error) {
         logger.error(`Erro ao verificar sync RTP: ${error}`)
      }
   },

   /**
    * Obter histórico de transações
    */
   async getTransactionHistory(
      userId: number, 
      gameCode?: string, 
      limit: number = 50
   ): Promise<any[]> {
      try {
         let query = `
            SELECT t.*, u.username, a.agentcode 
            FROM transactions t
            JOIN users u ON t.user_id = u.id
            JOIN agents a ON t.agent_id = a.id
            WHERE t.user_id = ?
         `
         const params: any[] = [userId]
         
         if (gameCode) {
            query += " AND t.game_code = ?"
            params.push(gameCode)
         }
         
         query += " ORDER BY t.created_at DESC LIMIT ?"
         params.push(limit)
         
         const [rows] = await promisePool.query<RowDataPacket[]>(query, params)
         
         return rows
         
      } catch (error) {
         logger.error(`Erro ao obter histórico: ${error}`)
         return []
      }
   },

   /**
    * Obter estatísticas de transações
    */
   async getTransactionStats(userId: number): Promise<any> {
      try {
         const [rows] = await promisePool.query<RowDataPacket[]>(
            `SELECT 
               COUNT(*) as total_transactions,
               SUM(CASE WHEN type = 'bet' THEN amount ELSE 0 END) as total_bets,
               SUM(CASE WHEN type = 'win' THEN amount ELSE 0 END) as total_wins,
               COUNT(CASE WHEN type = 'refund' THEN 1 END) as total_refunds,
               AVG(CASE WHEN type = 'bet' THEN amount END) as avg_bet,
               MAX(CASE WHEN type = 'win' THEN amount END) as max_win
             FROM transactions 
             WHERE user_id = ?`,
            [userId]
         )
         
         return rows[0] || {}
         
      } catch (error) {
         logger.error(`Erro ao obter estatísticas: ${error}`)
         return {}
      }
   }
}
