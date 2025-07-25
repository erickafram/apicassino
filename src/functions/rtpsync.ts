import promisePool from "../database"
import { RowDataPacket } from "mysql2"
import axios from "axios"
import logger from "../logger"

interface RTPData {
   userId: number
   username: string
   rtp: number
   probganho: number
   probganhortp: number
   probganhosaldo: number
   probganhoaposta: number
   probganhoinfluencer: number
   probbonus: number
   probbonusinfluencer: number
   saldo: number
   valorapostado: number
   valorganho: number
   isinfluencer: boolean
   agentid: number
}

interface CasinoRTPSync {
   userCode: string
   rtp: number
   probabilities: {
      base: number
      rtp_low: number
      high_balance: number
      high_bet: number
      influencer: number
      bonus: number
      bonus_influencer: number
   }
   balance_info: {
      current: number
      total_bet: number
      total_won: number
      currency: string
   }
}

export default {
   /**
    * Sincronizar RTP com o cassino
    */
   async syncRTPWithCasino(userId: number): Promise<boolean> {
      try {
         // Obter dados do usuário e agente
         const userData = await this.getUserRTPData(userId)
         if (!userData) {
            logger.error(`Usuário ${userId} não encontrado para sync RTP`)
            return false
         }

         // Obter dados do agente
         const agentData = await this.getAgentData(userData.agentid)
         if (!agentData) {
            logger.error(`Agente ${userData.agentid} não encontrado`)
            return false
         }

         // Calcular probabilidades dinâmicas
         const probabilities = this.calculateDynamicProbabilities(userData, agentData)

         // Preparar dados para envio ao cassino
         const syncData: CasinoRTPSync = {
            userCode: userData.username,
            rtp: userData.rtp,
            probabilities: probabilities,
            balance_info: {
               current: userData.saldo,
               total_bet: userData.valorapostado,
               total_won: userData.valorganho,
               currency: 'BRL'
            }
         }

         // Enviar para o cassino
         const success = await this.sendRTPToCasino(syncData, agentData.callbackurl)
         
         if (success) {
            logger.info(`RTP sincronizado com sucesso para usuário ${userData.username}`)
            return true
         } else {
            logger.error(`Falha ao sincronizar RTP para usuário ${userData.username}`)
            return false
         }

      } catch (error) {
         logger.error(`Erro ao sincronizar RTP: ${error}`)
         return false
      }
   },

   /**
    * Obter dados RTP do usuário
    */
   async getUserRTPData(userId: number): Promise<RTPData | null> {
      const [rows] = await promisePool.query<RowDataPacket[]>(
         `SELECT u.id as userId, u.username, u.rtp, u.saldo, u.valorapostado, 
                 u.valorganho, u.isinfluencer, u.agentid,
                 a.probganho, a.probganhortp, a.probganhosaldo, a.probganhoaposta,
                 a.probganhoinfluencer, a.probbonus, a.probbonusinfluencer
          FROM users u 
          JOIN agents a ON u.agentid = a.id 
          WHERE u.id = ?`,
         [userId]
      )

      return rows.length > 0 ? rows[0] as RTPData : null
   },

   /**
    * Obter dados do agente
    */
   async getAgentData(agentId: number): Promise<any> {
      const [rows] = await promisePool.query<RowDataPacket[]>(
         "SELECT * FROM agents WHERE id = ?",
         [agentId]
      )

      return rows.length > 0 ? rows[0] : null
   },

   /**
    * Calcular probabilidades dinâmicas baseadas nas regras da API
    */
   calculateDynamicProbabilities(userData: RTPData, agentData: any): any {
      let probganho = parseFloat(agentData.probganho) / 100
      let probbonus = parseFloat(agentData.probbonus) / 100

      // Regra 1: RTP baixo (0-30%) para usuários não influenciadores
      if (userData.rtp >= 0 && userData.rtp <= 30 && !userData.isinfluencer) {
         probganho = parseFloat(agentData.probganhortp) / 100
      }

      // Regra 2: Saldo alto (>= 100)
      if (userData.saldo >= 100) {
         probganho = parseFloat(agentData.probganhosaldo) / 100
      }

      // Regra 3: Aposta alta (>= 2) - será aplicada dinamicamente no jogo
      const probganhoaposta = parseFloat(agentData.probganhoaposta) / 100

      // Regra 4: Influenciadores
      if (userData.isinfluencer) {
         probganho = parseFloat(agentData.probganhoinfluencer) / 100
         probbonus = parseFloat(agentData.probbonusinfluencer) / 100
      }

      return {
         base: probganho,
         rtp_low: parseFloat(agentData.probganhortp) / 100,
         high_balance: parseFloat(agentData.probganhosaldo) / 100,
         high_bet: probganhoaposta,
         influencer: parseFloat(agentData.probganhoinfluencer) / 100,
         bonus: probbonus,
         bonus_influencer: parseFloat(agentData.probbonusinfluencer) / 100
      }
   },

   /**
    * Enviar dados RTP para o cassino
    */
   async sendRTPToCasino(syncData: CasinoRTPSync, callbackUrl: string): Promise<boolean> {
      try {
         const response = await axios({
            method: 'POST',
            url: `${callbackUrl}gold_api/rtp_sync`,
            headers: {
               'Content-Type': 'application/json'
            },
            data: syncData,
            timeout: 10000
         })

         return response.status === 200 && response.data?.status === 'success'

      } catch (error) {
         logger.error(`Erro ao enviar RTP para cassino: ${error}`)
         return false
      }
   },

   /**
    * Sincronizar RTP de todos os usuários ativos
    */
   async syncAllActiveUsers(): Promise<void> {
      try {
         const [rows] = await promisePool.query<RowDataPacket[]>(
            "SELECT id FROM users WHERE status = 'active'"
         )

         logger.info(`Iniciando sincronização RTP para ${rows.length} usuários`)

         for (const user of rows) {
            await this.syncRTPWithCasino(user.id)
            // Pequeno delay para não sobrecarregar
            await new Promise(resolve => setTimeout(resolve, 100))
         }

         logger.info('Sincronização RTP completa para todos os usuários')

      } catch (error) {
         logger.error(`Erro na sincronização em lote: ${error}`)
      }
   },

   /**
    * Agendar sincronização automática
    */
   startAutoSync(): void {
      // Sincronizar a cada 5 minutos
      setInterval(async () => {
         logger.info('Iniciando sincronização automática de RTP')
         await this.syncAllActiveUsers()
      }, 5 * 60 * 1000) // 5 minutos

      logger.info('Sistema de sincronização automática de RTP iniciado')
   },

   /**
    * Sincronizar RTP quando houver mudança significativa
    */
   async syncOnSignificantChange(userId: number, oldRTP: number, newRTP: number): Promise<void> {
      const rtpDifference = Math.abs(newRTP - oldRTP)
      
      // Sincronizar se a diferença for maior que 5%
      if (rtpDifference > 5) {
         logger.info(`RTP mudou significativamente para usuário ${userId}: ${oldRTP}% -> ${newRTP}%`)
         await this.syncRTPWithCasino(userId)
      }
   },

   /**
    * Obter estatísticas de sincronização
    */
   async getSyncStats(): Promise<any> {
      try {
         const [userCount] = await promisePool.query<RowDataPacket[]>(
            "SELECT COUNT(*) as total FROM users WHERE status = 'active'"
         )

         const [avgRTP] = await promisePool.query<RowDataPacket[]>(
            "SELECT AVG(rtp) as avg_rtp FROM users WHERE status = 'active' AND valorapostado > 0"
         )

         const [rtpDistribution] = await promisePool.query<RowDataPacket[]>(
            `SELECT 
               CASE 
                  WHEN rtp <= 30 THEN 'Low (0-30%)'
                  WHEN rtp <= 60 THEN 'Medium (31-60%)'
                  WHEN rtp <= 90 THEN 'High (61-90%)'
                  ELSE 'Very High (90%+)'
               END as rtp_range,
               COUNT(*) as count
             FROM users 
             WHERE status = 'active' AND valorapostado > 0
             GROUP BY rtp_range`
         )

         return {
            total_users: userCount[0]?.total || 0,
            average_rtp: parseFloat(avgRTP[0]?.avg_rtp || 0).toFixed(2),
            rtp_distribution: rtpDistribution,
            last_sync: new Date().toISOString()
         }

      } catch (error) {
         logger.error(`Erro ao obter estatísticas: ${error}`)
         return null
      }
   }
}
