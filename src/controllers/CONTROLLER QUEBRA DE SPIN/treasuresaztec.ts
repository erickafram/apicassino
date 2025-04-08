import { Request, Response } from "express"
import axios from "axios"
import logger from "../../logger"
import * as crypto from "crypto"
import { v4 as uuidv4 } from "uuid"
import moment from "moment"
import "dotenv/config"
// IMPORT FUNCTIONS
import { emitirEventoInterno } from "../../serverEvents"
import allfunctions from "../../functions/allfunctions"
import apicontroller from "../apicontroller"
import treasuresaztecfunctions from "../../functions/treasures-aztec/aztecfunctions"
// IMPORT LINHAS
import linhaperdaaztec from "../../jsons/treasures-aztec/linhaperdaaztec"
import linhabonusbikini from "../../jsons/bikini-paradise/linhabonusbikini"
import notcashaztec from "../../jsons/treasures-aztec/notcashaztec"
import linhaganhoaztec from "../../jsons/treasures-aztec/linhaganhoaztec"

const stepsStorage: { [key: string]: number } = {}

async function lwchange(json1: { [key: string]: any }, json2: { [key: string]: any }, cs: number, ml: number) {
   for (let chave in json1) {
      if (json1.hasOwnProperty(chave)) {
         const valor = json1[chave]
         const ganho = cs * ml * parseFloat(valor)
         for (let chave2 in json2) {
            if (json2.hasOwnProperty(chave2)) {
               json2[chave] = ganho
            }
         }
      }
   }
}

async function countrwsp(json: { [key: string]: any }) {
   let multiplicador = 0
   for (let i = 1; i <= 25; i++) {
      const chave = i.toString()
      if (json.hasOwnProperty(chave)) {
         multiplicador += parseFloat(json[chave])
      }
   }
   return multiplicador
}

async function gerarNumeroUnico() {
   return crypto.randomBytes(8).toString("hex")
}

async function returnrwm(json: { [key: string]: any }) {
   let value = 0
   for (let chave in json) {
      if (json.hasOwnProperty(chave)) {
         value += parseFloat(json[chave])
      }
   }
   return value
}

function getSteps(token: string, gamename: string): number {
   const key = `${token}:${gamename}`
   return stepsStorage[key] || 0
}

function setSteps(token: string, gamename: string, steps: number) {
   const key = `${token}:${gamename}`
   stepsStorage[key] = steps
}

function incrementSteps(token: string, gamename: string) {
   const key = `${token}:${gamename}`
   stepsStorage[key] = (stepsStorage[key] || 0) + 1
}

function resetSteps(token: string, gamename: string) {
   const key = `${token}:${gamename}`
   delete stepsStorage[key]
}

export default {
   async getaztec(req: Request, res: Response) {
      try {
         const token = req.body.atk
         const gamename = "treasures-aztec"
         const user = await allfunctions.getuserbyatk(token)
         logger.info("[+] Usuario logado: " + user[0].username)
         const jsonprimay = await allfunctions.getSpinByPlayerId(user[0].id)
         const jsoninicial = await allfunctions.getjsonprimary(gamename)
         if (jsonprimay.length === 0) {
            await allfunctions.createOrUpdateSpin(user[0].id, gamename, jsoninicial[0].json)
         }
         if (jsonprimay[0].game_code === gamename) {
            logger.info("[+] Json Recuperado Do Ultimo Spin.")
         } else {
            await allfunctions.createOrUpdateSpin(user[0].id, gamename, jsoninicial[0].json)
         }
         const json = await allfunctions.getSpinByPlayerId(user[0].id)
         const jsonformatado = JSON.parse(json[0].json)
         res.send({
            dt: {
               fb: {
                  is: true,
                  bm: 50,
                  t: 20.0,
               },
               wt: {
                  mw: 5.0,
                  bw: 20.0,
                  mgw: 35.0,
                  smgw: 50.0,
               },
               maxwm: null,
               cs: [0.02, 0.1, 0.2],
               ml: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
               mxl: 20,
               bl: user[0].saldo,
               inwe: false,
               iuwe: false,
               ls: jsonformatado.dt,
               cc: "BRL",
            },
            err: null,
         })
      } catch (error) {
         logger.error(error)
      }
   },

   async spin(req: Request, res: Response) {
      let cs: number = parseFloat(req.body.cs)
      let ml: number = parseFloat(req.body.ml)
      const token = req.body.atk

      try {
         const user = await treasuresaztecfunctions.getuserbyatk(token)
         let bet: number = cs * ml * 20
         let saldoatual: number = user[0].saldo
         const gamename = "treasures-aztec"

         emitirEventoInterno("att", {
            token: token,
            username: user[0].username,
            bet: bet,
            saldo: saldoatual,
            rtp: user[0].rtp,
            agentid: user[0].agentid,
            gamecode: gamename,
         })

         const agent = await allfunctions.getagentbyid(user[0].agentid)

         const checkuserbalance = await axios({
            maxBodyLength: Infinity,
            method: "POST",
            url: `${agent[0].callbackurl}gold_api/user_balance`,
            headers: {
               "Content-Type": "application/json",
            },
            data: {
               user_code: user[0].username,
            },
         })

         if (checkuserbalance.data.msg === "INVALID_USER" || checkuserbalance.data.msg === "INSUFFICIENT_USER_FUNDS") {
            res.send(await notcashaztec.notcash(saldoatual, cs, ml))
            return
         }

         const retornado = user[0].valorganho
         const valorapostado = user[0].valorapostado

         const rtp = (retornado / valorapostado) * 100

         if (saldoatual < bet) {
            res.send(await notcashaztec.notcash(saldoatual, cs, ml))
            return
         }

         let steps = getSteps(token, gamename)
         const resultadospin = await allfunctions.calcularganho(bet, saldoatual, token, gamename)

         if (steps > 0) {
            resultadospin.result = "ganho"
         }

         if (resultadospin.result === "bonus") {
            resultadospin.result = "ganho"
         }

         if (resultadospin.result === "perda") {
            let newbalance = saldoatual - bet
            await treasuresaztecfunctions.attsaldobyatk(token, newbalance)
            await treasuresaztecfunctions.atualizardebitado(token, bet)
            await treasuresaztecfunctions.atualizarapostado(token, bet)
            const perdajson = await linhaperdaaztec.linhaperda()

            let json = {
               dt: {
                  si: {
                     wp: null,
                     twp: null,
                     lw: null,
                     trl: perdajson.trl,
                     torl: perdajson.torl,
                     orl: perdajson.orl,
                     bwp: null,
                     now: perdajson.now,
                     nowpr: perdajson.nowpr,
                     snww: null,
                     esb: perdajson.esb,
                     ebb: perdajson.ebb,
                     es: perdajson.es,
                     eb: perdajson.eb,
                     ssaw: 0.0,
                     tptbr: null,
                     ptbr: null,
                     ptbrp: null,
                     gml: 1,
                     ngml: 1,
                     sc: perdajson.sc,
                     rs: null,
                     fs: null,
                     gwt: -1,
                     ctw: 0.0,
                     pmt: null,
                     cwc: 0,
                     fstc: null,
                     pcwc: 0,
                     rwsp: null,
                     hashr: "0:10;7;11;3;3;12#3;7;11;3;3;8#2;11;11;8;2;1#9;11;11;8;2;8#9;12;9;6;7;6#MV#12.0#MT#1#MG#0#",
                     fb: null,
                     ml: ml,
                     cs: cs,
                     rl: perdajson.rl,
                     sid: "1838861341642653184",
                     psid: "1838861341642653184",
                     st: 1,
                     nst: 1,
                     pf: 1,
                     aw: 0.0,
                     wid: 0,
                     wt: "C",
                     wk: "0_C",
                     wbn: null,
                     wfg: null,
                     blb: saldoatual,
                     blab: newbalance,
                     bl: newbalance,
                     tb: bet,
                     tbb: bet,
                     tw: 0.0,
                     np: -bet,
                     ocr: null,
                     mr: null,
                     ge: [1, 11],
                  },
               },
               err: null,
            }

            await allfunctions.savejsonspin(user[0].id, JSON.stringify(json), gamename)
            const txnid = uuidv4()
            const dataFormatada = moment().toISOString()

            await apicontroller.callbackgame({
               agent_code: agent[0].agentcode,
               agent_secret: agent[0].secretKey,
               user_code: user[0].username,
               user_balance: user[0].saldo,
               user_total_credit: user[0].valorganho,
               user_total_debit: user[0].valorapostado,
               game_type: "slot",
               slot: {
                  provider_code: "PGSOFT",
                  game_code: gamename,
                  round_id: await gerarNumeroUnico(),
                  type: "BASE",
                  bet: bet,
                  win: 0,
                  txn_id: `${txnid}`,
                  txn_type: "debit_credit",
                  is_buy: false,
                  is_call: false,
                  user_before_balance: user[0].saldo,
                  user_after_balance: newbalance,
                  agent_before_balance: 100,
                  agent_after_balance: 100,
                  created_at: dataFormatada,
               },
            })
            res.send(json)
            return
         }

         if (resultadospin.result === "ganho") {
            try {
               const userId = user[0].id

               // Recuperar a linha de ganho do banco de dados
               let linhaGanhoAnterior = await treasuresaztecfunctions.obterLinhaGanho(userId)

               // Se houver um ganho anterior, use a linha armazenada, caso contrário, gere uma nova
               let numeroAleatorio
               if (linhaGanhoAnterior !== null && linhaGanhoAnterior !== undefined) {
                  numeroAleatorio = linhaGanhoAnterior
               } else {
                  //numeroAleatorio = 3;
                  numeroAleatorio = Math.floor(Math.random() * 33) + 1 // Supondo que maxLinhas seja o número máximo de linhas disponíveis
                  linhaGanhoAnterior = numeroAleatorio // Armazenar a nova linha de ganho
               }

               console.log("Linha de ganho escolhida: " + numeroAleatorio)

               const ganhojson = await linhaganhoaztec.linhaganho(numeroAleatorio)

               // Verificar se ganhojson não é nulo ou indefinido
               if (!ganhojson) {
                  throw new Error("Dados de ganho inválidos")
               }

               const multplicador = await countrwsp(ganhojson[steps].rwsp || 0)
               await lwchange(ganhojson[steps].rwsp, ganhojson[steps].lw, cs, ml)

               let valorganho = cs * ml * multplicador * 20
               let wmvalue = 0
               console.log("VALOR GANHO " + valorganho)

               // Verificar se saldoatual e bet são válidos
               if (typeof saldoatual !== "number" || typeof bet !== "number") {
                  throw new Error("Saldo ou aposta inválidos")
               }

               let newbalance

               // Verifica se o steps já começou a contar, se sim, não subtrai o bet
               if (getSteps(token, gamename) > 0) {
                  newbalance = saldoatual + valorganho // Não desconta o bet quando os steps estão contando
                  logger.info("Steps em andamento, não desconta o bet")
               } else {
                  newbalance = saldoatual + valorganho - bet // Subtrai o bet apenas se os steps não estão contando
               }

               // Atualizar saldo, debitar aposta e atualizar ganho
               await treasuresaztecfunctions.attsaldobyatk(token, newbalance)
               await treasuresaztecfunctions.atualizardebitado(token, bet)
               await treasuresaztecfunctions.atualizarapostado(token, bet)
               await treasuresaztecfunctions.atualizarganho(token, valorganho)

               let json = {
                  dt: {
                     si: {
                        wp: ganhojson[steps].wp,
                        twp: ganhojson[steps].twp,
                        lw: ganhojson[steps].lw,
                        trl: ganhojson[steps].trl,
                        torl: ganhojson[steps].torl,
                        orl: ganhojson[steps].orl,
                        bwp: ganhojson[steps].bwp,
                        now: ganhojson[steps].now,
                        nowpr: ganhojson[steps].nowpr,
                        snww: ganhojson[steps].snww,
                        esb: ganhojson[steps].esb,
                        ebb: ganhojson[steps].ebb,
                        es: ganhojson[steps].es,
                        eb: ganhojson[steps].eb,
                        ssaw: valorganho,
                        tptbr: ganhojson[steps].tptbr,
                        ptbr: ganhojson[steps].ptbr,
                        ptbrp: ganhojson[steps].ptbrp,
                        gml: ganhojson[steps].gml,
                        ngml: ganhojson[steps].ngml,
                        sc: ganhojson[steps].sc,
                        rs: ganhojson[steps].rs,
                        fs: ganhojson[steps].fs,
                        gwt: ganhojson[steps].gwt,
                        ctw: valorganho,
                        pmt: ganhojson[steps].pmt,
                        cwc: ganhojson[steps].cwc,
                        fstc: ganhojson[steps].fstc,
                        pcwc: ganhojson[steps].pcwc,
                        rwsp: ganhojson[steps].rwsp,
                        hashr: "0:12;9;9;3;10;6#9;9;7;3;10;10#9;9;7;3;11;6#9;9;5;11;11;12#1;9;5;11;11;10#R#9#010203101112131420#MV#12.0#MT#1#MG#32.4#",
                        fb: ganhojson[steps].fb,
                        ml: ml,
                        cs: cs,
                        rl: ganhojson[steps].rl,
                        sid: "1838861543455784448",
                        psid: "1838861543455784448",
                        st: ganhojson[steps].st,
                        nst: ganhojson[steps].nst,
                        pf: ganhojson[steps].pf,
                        aw: valorganho,
                        wid: ganhojson[steps].wid,
                        wt: "C",
                        wk: "0_C",
                        wbn: null,
                        wfg: null,
                        blb: saldoatual,
                        blab: newbalance,
                        bl: newbalance,
                        tb: bet,
                        tbb: bet,
                        tw: valorganho,
                        np: -bet,
                        ocr: null,
                        mr: null,
                        ge: [1, 11],
                     },
                  },
                  err: null,
               }

               // Salvar os dados do spin
               await allfunctions.savejsonspin(user[0].id, JSON.stringify(json), gamename)

               const txnid = uuidv4()
               const dataFormatada = moment().toISOString()

               // Salvar a linha de ganho atual no banco de dados
               await treasuresaztecfunctions.atualizarLinhaGanho(userId, numeroAleatorio)
               logger.info("LINHA DE GANHO SALVA NO BD: " + numeroAleatorio)

               console.log("linha de ganho " + numeroAleatorio)

               // Incrementar e verificar steps
               incrementSteps(token, gamename)
               if (getSteps(token, gamename) >= Object.keys(ganhojson).length) {
                  resetSteps(token, gamename)
                  await treasuresaztecfunctions.atualizarLinhaGanho(userId, null) // Resetar a linha de ganho quando os steps são resetados
               }

               // Callback para o jogo
               await apicontroller.callbackgame({
                  agent_code: agent[0].agentcode,
                  agent_secret: agent[0].secretKey,
                  user_code: user[0].username,
                  user_balance: user[0].saldo,
                  user_total_credit: user[0].valorganho,
                  user_total_debit: user[0].valorapostado,
                  game_type: "slot",
                  slot: {
                     provider_code: "PGSOFT",
                     game_code: gamename,
                     round_id: await gerarNumeroUnico(),
                     type: "BASE",
                     bet: bet,
                     win: Number(valorganho),
                     txn_id: `${txnid}`,
                     txn_type: "debit_credit",
                     is_buy: false,
                     is_call: false,
                     user_before_balance: user[0].saldo,
                     user_after_balance: newbalance,
                     agent_before_balance: 100,
                     agent_after_balance: 100,
                     created_at: dataFormatada,
                  },
               })

               res.send(json)
               return
            } catch (error) {
               if (error instanceof Error) {
                  logger.error(error.message)
               } else {
                  logger.error("Ocorreu um erro desconhecido")
               }
               res.status(500).send({
                  err: {
                     type: "InternalError",
                     message: "Ocorreu um erro desconhecido, tente novamente. (codigo de erro:G1008)",
                  },
               })
            }
         }
      } catch (error) {
         logger.error(error)
      }
   },
}
