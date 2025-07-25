import express, { Request, Response } from "express"
import helmet from "helmet"
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
import { emitirEventoInterno, adicionarListener } from "./serverEvents"

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
   transports: ['websocket', 'polling'], // Adicionar polling como fallback
   cors: {
     origin: "*", // Permitir qualquer origem, ajuste conforme necessário
     methods: ["GET", "POST"],
     credentials: true
   },
   allowEIO3: true, // Compatibilidade com versões antigas
   pingTimeout: 60000,
   pingInterval: 25000
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

io.on("connection", async (socket: Socket) => {
   console.log("Usuário Conectado", socket.id);
   logger.info("SOCKET CONECTADO: " + socket.id)

   // Enviar dados iniciais seguros
   socket.emit('connected', {
     status: 'connected',
     timestamp: new Date().toISOString(),
     socketId: socket.id
   })

   socket.on("join", async (socket1) => {
      try {
         const token: any = socket1?.token
         const gameid: any = socket1?.gameId

         if (!token) {
            logger.error("Token não fornecido no join")
            socket.emit('error', { message: 'Token required' })
            return
         }

         setInterval(async function () {
            try {
               const user = await allfunctions.getuserbytoken(token)

               if (!user || !user[0]) {
                  socket.disconnect(true)
                  return false
               }

               const retornado = user[0].valorganho || 0
               const valorapostado = user[0].valorapostado || 1

               const rtp = Math.round((retornado / valorapostado) * 100)

               if (isNaN(rtp) === false) {
                  await allfunctions.updatertp(token, rtp)
               }
            } catch (error) {
               logger.error("Erro no interval do socket:", error)
            }
         }, 10000)
      } catch (error) {
         logger.error("Erro no join do socket:", error)
         socket.emit('error', { message: 'Join failed' })
      }
   })

   socket.on("disconnect", (reason) => {
      logger.info(`SOCKET DESCONECTADO: ${socket.id} - Razão: ${reason}`)
   })

   socket.on("error", (error) => {
      logger.error(`SOCKET ERROR: ${socket.id} - ${error}`)
   })

   adicionarListener("attganho", async (dados) => {
      users.forEach(async (valor, chave) => {
         let newvalue = parseFloat(users.get(socket.id).aw) + dados.aw
         users.set(socket.id, {
            aw: newvalue,
         })
      })
      emitirEventoInterno("awreceive", {
         aw: users.get(socket.id).aw,
      })
   })

   adicionarListener("att", (dados) => {
      users.forEach((valor, chave) => {
         if (valor.token === dados.token) {
            return false
         } else {
            users.set(socket.id, {
               token: dados.token,
               username: dados.username,
               bet: dados.bet,
               saldo: dados.saldo,
               rtp: dados.rtp,
               agentid: dados.agentid,
               socketid: socket.id,
               gamecode: dados.gamecode,
               aw: 0,
            })
         }
      })

      if (Object.keys(users).length === 0) {
         users.set(socket.id, {
            token: dados.token,
            username: dados.username,
            bet: dados.bet,
            saldo: dados.saldo,
            rtp: dados.rtp,
            agentid: dados.agentid,
            socketid: socket.id,
            gamecode: dados.gamecode,
            aw: 0,
         })
      }
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
app.use(express.json({ limit: '50mb' }))
app.use(express.urlencoded({ extended: true, limit: '50mb' }))

// Middleware para tratar erros de parsing JSON
app.use((err: any, req: Request, res: Response, next: any) => {
  if (err instanceof SyntaxError && 'body' in err) {
    logger.error('JSON Parse Error:', err.message)
    return res.status(400).json({
      error: 'Invalid JSON format',
      message: 'Request body contains invalid JSON'
    })
  }
  next(err)
})
app.use("/", express.static(path.join(__dirname, "public")))
app.use(
   helmet.contentSecurityPolicy({
      directives: {
         "default-src": ["'none'"],
         "base-uri": ["'self'"],
         "font-src": ["'self'", "https:", "data:"],
         "frame-ancestors": ["'self'"],
         "img-src": ["'self'", "data:"],
         "object-src": ["'none'"],
         "script-src": ["'self'", "https://cdnjs.cloudflare.com"],
         "style-src": ["'self'", "https://cdnjs.cloudflare.com"],
      },
   }),
)

app.use("/status", (req, res) => {
   res.json({ status: "operational" })
})

app.use(routes)

// Tratamento de erros do servidor Socket.IO
io.engine.on("connection_error", (err) => {
  logger.error("Socket.IO Connection Error:", {
    req: err.req?.url || 'unknown',
    code: err.code,
    message: err.message,
    context: err.context
  })
})

// Middleware global de tratamento de erros
app.use((err: any, req: Request, res: Response, next: any) => {
  logger.error('Unhandled Error:', err)

  // Não enviar detalhes do erro em produção
  const isDev = process.env.NODE_ENV === 'development'

  res.status(err.status || 500).json({
    error: isDev ? err.message : 'Internal Server Error',
    ...(isDev && { stack: err.stack })
  })
})

httpServer.listen(process.env.PORT, () => {
   logger.info("API RODANDO NA PORTA: " + process.env.PORT)
   logger.info("CONEXÃO REALIZADA COM SUCESSO!")
})
