import { EventEmitter } from "events"

// Crie um EventEmitter para comunicação interna do servidor
const internalEmitter = new EventEmitter()

// Aumentar o limite de listeners para evitar warnings
internalEmitter.setMaxListeners(50)

// Função para emitir um evento interno
export function emitirEventoInterno(evento: string, dados?: any) {
   internalEmitter.emit(evento, dados)
}

// Função para adicionar um listener para eventos internos
export function adicionarListener(evento: string, listener: (...args: any[]) => void) {
   internalEmitter.on(evento, listener)
}

// Função para remover um listener específico
export function removerListener(evento: string, listener: (...args: any[]) => void) {
   internalEmitter.removeListener(evento, listener)
}

// Função para remover todos os listeners de um evento
export function removerTodosListeners(evento?: string) {
   if (evento) {
      internalEmitter.removeAllListeners(evento)
   } else {
      internalEmitter.removeAllListeners()
   }
}
