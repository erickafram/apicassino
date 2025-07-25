import { Request, Response } from "express"
import axios from "axios"
import logger from "../logger"
import "dotenv/config"
import apifunctions from "../functions/apifunctions"
import { v4 } from "uuid"
import { parseTwoDigitYear } from "moment-timezone"

export default {
   async launchgame(req: Request, res: Response) {
      const agentToken = req.body.agentToken
      const secretKey = req.body.secretKey
      const user_code = req.body.user_code
      const game_type = req.body.game_type
      const provider_code = req.body.provider_code
      const game_code = req.body.game_code
      const user_balance: number = req.body.user_balance

      try {
         if (!user_code) {
            res.send({
               status: "error",
               message: "Voce precisa passar o user_code.",
            })
            return false
         }
         if (isNaN(user_balance) === true) {
            res.send({
               status: "error",
               message: "User Balance deve ser um numero.",
            })
            return false
         }

         if ((await apifunctions.getagentbyagentToken(agentToken)).length === 0) {
            res.send({
               status: "error",
               message: "Agent Token não cadastrado.",
            })
            return false
         }
         if ((await apifunctions.getagentbysecretkey(secretKey)).length === 0) {
            res.send({
               status: "error",
               message: "Secret Key não cadastrado.",
            })
            return false
         }

         const agent = await apifunctions.getagentbyagentToken(agentToken)
         const user = await apifunctions.getuserbyagent(user_code, agent[0].id) //PUXA O USUARIO ATRAVES DO USER E AGENTID

         // Adicionando a lógica para enviar um request se o provider_code for 'PRAGMATIC'
         if (provider_code === "PRAGMATIC") {
            try {
               // Usa let para permitir reatribuição
               let user = await apifunctions.getuserbyagent(user_code, agent[0].id)

               // Criação do usuário se não existir
               if (user.length === 0) {
                  const tokenuser = v4()
                  const atkuser = v4()
                  const createnewuser = await apifunctions.createuser(user_code, tokenuser, atkuser, user_balance, agent[0].id)

                  if (createnewuser.affectedRows >= 1) {
                     // Obtendo o novo usuário após criação
                     user = await apifunctions.getuserbyagent(user_code, agent[0].id)
                  } else {
                     res.send({
                        status: 0,
                        msg: "ERRO",
                        message: "Erro ao criar o usuário.",
                     })
                     return
                  }
               }

               // Preparação dos dados da requisição para o Pragmatic
               const pragmaticRequestData = {
                  method: "game_launch",
                  agent_code: "admin",
                  agent_token: "admin",
                  user_code: user_code,
                  game_code: game_code,
                  lang: "pt",
                  provider_code: provider_code,
                  user_balance: user_balance,
               }

               // Envio da requisição para a API Pragmatic
               const pragmaticResponse = await axios.post("https://api.br777-pg.com/", pragmaticRequestData) // Substitua pela URL real

               // Responder com sucesso, incluindo o launch_url da resposta
               res.send({
                  status: 1,
                  msg: "SUCCESS",
                  launch_url: pragmaticResponse.data.launch_url || "",
                  user_code: user[0].username,
                  user_balance: user[0].saldo,
                  user_created: user.length === 0,
                  currency: "BRL",
               })
            } catch (error) {
               logger.error("Error sending request to Pragmatic:", error)
               res.send({
                  status: 0,
                  msg: "ERRO",
                  message: "Erro ao se conectar com o provedor PRAGMATIC."
               })
            }
            return
         }

         let codegame = 0
         if (game_code === "fortune-tiger") {
            codegame = 126
         } else if (game_code === "fortune-ox") {
            codegame = 98
         } else if (game_code === "fortune-dragon") {
            codegame = 1695365
         } else if (game_code === "fortune-rabbit") {
            codegame = 1543462
         } else if (game_code === "fortune-mouse") {
            codegame = 68
         } else if (game_code === "bikini-paradise") {
            codegame = 69
         } else if (game_code === "jungle-delight") {
            codegame = 40
         } else if (game_code === "ganesha-gold") {
            codegame = 42
         } else if (game_code === "double-fortune") {
            codegame = 48
         } else if (game_code === "dragon-tiger-luck") {
            codegame = 63
         } else if (game_code === "ninja-raccoon") {
            codegame = 1529867
         } else if (game_code === "lucky-clover") {
            codegame = 1601012
         } else if (game_code === "ultimate-striker") {
            codegame = 1489936
         } else if (game_code === "prosper-ftree") {
            codegame = 1312883
         } else if (game_code === "chicky-run") {
            codegame = 1738001
         } else if (game_code === "butterfly-blossom") {
            codegame = 125
         } else if (game_code === "cash-mania") {
            codegame = 1682240
         } else {
            res.send({
               status: "error",
               message: "Esse game não existe.",
            })
            return false
         }

         if (user.length === 0) {
            const tokenuser = v4()
            const atkuser = v4()
            const createnewuser = await apifunctions.createuser(user_code, tokenuser, atkuser, user_balance, agent[0].id)

            if (createnewuser.affectedRows >= 1) {
               const getnewuser = await apifunctions.getuserbyagent(user_code, agent[0].id)

               res.send({
                  status: 1,
                  msg: "SUCCESS",
                  launch_url: `https://${process.env.DOMINIO_API}/${codegame}/index.html?operator_token=Zm9saWFiZXQ=&btt=1&t=${getnewuser[0].token}&or=${process.env.DOMINIO_API}&api=${process.env.DOMINIO_API}`,
                  user_code: getnewuser[0].username,
                  user_balance: getnewuser[0].saldo,
                  user_created: true,
                  currency: "BRL",
               })
            } else {
               res.send({
                  status: "error",
                  message: "Erro ao cadastrar o usuario.",
               })
               return false
            }
         } else {
            await apifunctions.setbalanceuserbyid(user[0].id, user_balance)

            res.send({
               status: 1,
               msg: "SUCCESS",
               launch_url: `https://${process.env.DOMINIO_API}/${codegame}/index.html?operator_token=Zm9saWFiZXQ=&btt=1&t=${user[0].token}&or=${process.env.DOMINIO_API}&api=${process.env.DOMINIO_API}`,
               user_code: user[0].username,
               user_balance: user[0].saldo,
               user_created: false,
               currency: "BRL",
            })
         }
      } catch (error) {
         logger.error(error)
      }
   },
   async callbackgame(json: any) {
      const agent = await apifunctions.getagentbysecretkey(json.agent_secret)

      // Log para debug
      console.log("Enviando callback para cassino:")
      console.log("User:", json.user_code)
      console.log("Bet:", json.slot?.bet || 0)
      console.log("Win:", json.slot?.win || 0)

      // Dados no formato que o cassino espera (campos corretos)
      const webhookData = {
         method: "ChangeBalance",
         user_code: json.user_code,           // ✅ Campo correto
         bet: json.slot?.bet || 0,            // ✅ Valor da aposta
         win: json.slot?.win || 0,            // ✅ Valor do ganho
         txn_id: json.slot?.txn_id || `TXN_${Date.now()}`,  // ✅ Campo correto
         game_code: json.slot?.game_code || json.game_code, // ✅ Campo correto
         game_type: json.slot?.game_type || "slot",         // ✅ Campo obrigatório
         txn_type: json.slot?.txn_type || "debit_credit",   // ✅ Campo correto
         currency: json.currency || "BRL",
         balance_type: json.slot?.balance_type || "balance", // ✅ Tipo de saldo
         // Dados adicionais para compatibilidade
         provider_code: json.slot?.provider_code || "PGSOFT",
         aggregator: "pgapi",
         round_id: json.slot?.round_id || Date.now(),
         // Dados do usuário para debug
         user_before_balance: json.slot?.user_before_balance || 0,
         user_after_balance: json.slot?.user_after_balance || 0,
      }

      try {
         await axios({
            maxBodyLength: Infinity,
            method: "POST",
            url: `${agent[0].callbackurl}gold_api/game_callback`,
            headers: {
               "Content-Type": "application/json",
            },
            data: webhookData,
         })
            .then((data) => {
               console.log("Webhook enviado com sucesso!")
               console.log("Bet:", webhookData.bet, "Win:", webhookData.win)
               console.log("Response:", data.data)
            })
            .catch((error: any) => {
               console.log("Erro no webhook:", error.response?.data || error.message)
               logger.error("Webhook error details:", {
                  url: `${agent[0].callbackurl}gold_api/game_callback`,
                  data: webhookData,
                  error: error.response?.data || error.message
               })
            })
      } catch (error) {
         console.log("Erro geral no webhook:", error)
         logger.error("General webhook error:", error)
      }
   },
   async getagent(req: Request, res: Response) {
      const agentToken = req.body.agentToken
      const secretKey = req.body.secretKey

      if ((await apifunctions.getagentbyagentToken(agentToken)).length === 0) {
         res.send({
            status: "error",
            message: "Agent Token não cadastrado.",
         })
         return false
      }
      if ((await apifunctions.getagentbysecretkey(secretKey)).length === 0) {
         res.send({
            status: "error",
            message: "Secret Key não cadastrado.",
         })
         return false
      }
      const agent = await apifunctions.getagentbyagentToken(agentToken)
      agent[0].saldo = undefined
      agent[0].agentToken = undefined
      agent[0].saldo = undefined

      res.send(agent[0])
   },
   async attagent(req: Request, res: Response) {
      const agentToken = req.body.agentToken
      const secretKey = req.body.secretKey
      const probganho = req.body.probganho
      const probbonus = req.body.probbonus
      const probganhortp = req.body.probganhortp
      const probganhoinfluencer = req.body.probganhoinfluencer
      const probbonusinfluencer = req.body.probbonusinfluencer
      const probganhoaposta = req.body.probganhoaposta
      const probganhosaldo = req.body.probganhosaldo

      if ((await apifunctions.getagentbyagentToken(agentToken)).length === 0) {
         res.send({
            status: "error",
            message: "Agent Token não cadastrado.",
         })
         return false
      }
      if ((await apifunctions.getagentbysecretkey(secretKey)).length === 0) {
         res.send({
            status: "error",
            message: "Secret Key não cadastrado.",
         })
         return false
      }
      const agent = await apifunctions.getagentbyagentToken(agentToken)

      const att = await apifunctions.attagent(agent[0].id, probganho, probbonus, probganhortp, probganhoinfluencer, probbonusinfluencer, probganhoaposta, probganhosaldo)

      if (att.affectedRows > 0) {
         res.send({
            status: "success",
            message: "Probabiliades alteradas com sucesso.",
         })
      } else {
         res.send({
            status: "error",
            message: "Erro desconhecido por favor contate o adm.",
         })
      }
   },
}
