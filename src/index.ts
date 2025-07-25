import express, { Request, Response } from "express"
// import helmet from "helmet" // Comentado para evitar interferência com iframe
import cors from "cors"
import fs from "fs"
import https from "https"
import http from "http"
import logger from "./logger/index"
import routes from "./routes"
import * as figlet from "figlet"
import path from "path"
import compression from "compression"
import { Server, Socket } from "socket.io"
import allfunctions from "./functions/allfunctions"
// import rtpsync from "./functions/rtpsync" // Comentado temporariamente
import { emitirEventoInterno, adicionarListener, removerListener } from "./serverEvents"

import "dotenv/config"

// const privateKey = fs.readFileSync("server.key", "utf8")
// const certificate = fs.readFileSync("server.crt", "utf8")
// const credentials = {
//   key: privateKey,
//   cert: certificate,
// }
const app = express()
const httpServer = http.createServer(app)
const io = new Server(httpServer, {
   transports: ['websocket'],
   cors: {
     origin: "*", // Permitir qualquer origem, ajuste conforme necessário
     methods: ["GET", "POST"]
   }
 });

console.log(figlet.textSync("API PHILLYPS"), "\n")
logger.info('DOMINIO CONECTADO: ' + process.env.DOMINIO_API)

// httpServer.listen(process.env.PORT, () => {
//   logger.info("SERVIDOR INICIADO JOHN " + process.env.PORT)

// })
declare module "express-serve-static-core" {
   interface Request {
      io: Server
   }
}
const users = new Map<string, any>()

// Configurar listeners globais uma única vez
let listenersConfigured = false

function configureGlobalListeners() {
   if (listenersConfigured) return

   // Listener para attganho
   adicionarListener("attganho", async (dados) => {
      users.forEach(async (valor, chave) => {
         if (valor.socketid && users.has(valor.socketid)) {
            let currentUser = users.get(valor.socketid)
            let newvalue = parseFloat(currentUser.aw || 0) + dados.aw
            users.set(valor.socketid, {
               ...currentUser,
               aw: newvalue,
            })
         }
      })
   })

   // Listener para att
   adicionarListener("att", (dados) => {
      let userExists = false
      users.forEach((valor, chave) => {
         if (valor.token === dados.token) {
            userExists = true
            return false
         }
      })

      if (!userExists) {
         users.set(dados.socketid, {
            token: dados.token,
            username: dados.username,
            bet: dados.bet,
            saldo: dados.saldo,
            rtp: dados.rtp,
            agentid: dados.agentid,
            socketid: dados.socketid,
            gamecode: dados.gamecode,
            aw: 0
         })
      }
   })

   listenersConfigured = true
}

// Configurar listeners antes de aceitar conexões
configureGlobalListeners()

io.on("connection", async (socket: Socket) => {
   console.log("Usuário Conectado", socket.id);

   socket.on("join", async (socket1) => {
      const token: any = socket1.token
      const gameid: any = socket1.gameId

      setInterval(async function () {
         const user = await allfunctions.getuserbytoken(token)

         if (!user[0]) {
            socket.disconnect(true)
            return false
         }

         const retornado = user[0].valorganho || 0
         const valorapostado = user[0].valorapostado || 0

         // Calcular RTP apenas se houver apostas
         let rtp = 0
         if (valorapostado > 0) {
            rtp = Math.round((retornado / valorapostado) * 100)

            // Limitar RTP a valores razoáveis (0-500%)
            if (rtp > 500) rtp = 500
            if (rtp < 0) rtp = 0
         }

         // Atualizar RTP apenas se for um valor válido
         if (!isNaN(rtp) && isFinite(rtp)) {
            await allfunctions.updatertp(token, rtp)
         }
      }, 10000)
   })

   socket.on("disconnect", (reason) => {
      users.delete(socket.id)
      console.log("Cliente desconectado:", reason)
   })
})

// Middleware para adicionar compressão
app.use(compression());

// Middleware para adicionar o socket.io em cada requisição
app.use((req: Request, res: Response, next) => {
   req.io = io // Adiciona o socket.io ao objeto req
   next()
})

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))
app.use("/", express.static(path.join(__dirname, "public")))
// Configuração para permitir iframe - DEVE VIR ANTES DE QUALQUER OUTRO MIDDLEWARE
app.use((_req, res, next) => {
   // Remover completamente X-Frame-Options
   res.removeHeader('X-Frame-Options');

   // Não definir X-Frame-Options - deixar vazio para permitir iframe
   // res.setHeader('X-Frame-Options', 'DENY'); // NÃO USAR

   // Usar apenas CSP para controle de frame
   res.setHeader('Content-Security-Policy', 'frame-ancestors *; default-src * data: blob: filesystem: about: ws: wss: \'unsafe-inline\' \'unsafe-eval\'; script-src * data: blob: \'unsafe-inline\' \'unsafe-eval\'; connect-src * data: blob: \'unsafe-inline\'; img-src * data: blob: \'unsafe-inline\'; frame-src *; style-src * data: blob: \'unsafe-inline\';');

   next();
});

// Desabilitar helmet completamente para evitar interferência
// app.use(helmet()) // COMENTADO

app.use("/status", (req, res) => {
   res.json({ status: "operational" })
})

app.use(routes)

// Inicializar sistema de sincronização RTP
// rtpsync.startAutoSync() // Comentado temporariamente para resolver problema de conexão

httpServer.listen(process.env.PORT, () => {
   logger.info("API RODANDO NA PORTA: " + process.env.PORT)
   logger.info("CONEXÃO REALIZADA COM SUCESSO!")
})
