# 🔧 GUIA DE CORREÇÃO - WEBSOCKET EM PRODUÇÃO

## 🚨 **PROBLEMAS IDENTIFICADOS:**

1. **WebSocket SSL/TLS**: Conexão WSS falhando
2. **Object.keys() Error**: Dados undefined/null sendo processados
3. **CORS Issues**: Configuração inadequada para produção

## 🛠️ **SOLUÇÕES IMPLEMENTADAS:**

### **1. 📡 Configuração WebSocket Melhorada**

```typescript
const io = new Server(httpServer, {
   transports: ['websocket', 'polling'], // Fallback para polling
   cors: {
     origin: "*",
     methods: ["GET", "POST"],
     credentials: true
   },
   allowEIO3: true, // Compatibilidade
   pingTimeout: 60000,
   pingInterval: 25000
});
```

### **2. 🔒 Tratamento de Erros Robusto**

```typescript
socket.on("join", async (socket1) => {
   try {
      const token: any = socket1?.token // Safe access
      const gameid: any = socket1?.gameId

      if (!token) {
         socket.emit('error', { message: 'Token required' })
         return
      }
      // ... resto do código
   } catch (error) {
      logger.error("Erro no join:", error)
      socket.emit('error', { message: 'Join failed' })
   }
})
```

### **3. 🌐 Configuração de Proxy Reverso (Nginx)**

Crie um arquivo `/etc/nginx/sites-available/api.innocodepg.online`:

```nginx
server {
    listen 80;
    listen 443 ssl http2;
    server_name api.innocodepg.online;

    # SSL Configuration
    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # WebSocket Support
    location /socket.io/ {
        proxy_pass http://localhost:3006;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        proxy_read_timeout 86400;
    }

    # API Routes
    location / {
        proxy_pass http://localhost:3006;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### **4. 🔧 Variáveis de Ambiente para Produção**

Atualize seu `.env`:

```env
NODE_ENV=production
DOMINIO_API=api.innocodepg.online
PORT=3006
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=sua_senha
DB_NAME=pgapi

# SSL (opcional)
SSL_KEY_PATH=/path/to/private.key
SSL_CERT_PATH=/path/to/certificate.crt
SSL_CA_PATH=/path/to/ca_bundle.crt
```

## 🚀 **PASSOS PARA IMPLEMENTAR:**

### **1. Recompilar o Projeto:**
```bash
npm run build
```

### **2. Reiniciar o Servidor:**
```bash
pm2 restart all
# ou
npm run start:prod
```

### **3. Configurar Nginx (se usando):**
```bash
sudo nginx -t
sudo systemctl reload nginx
```

### **4. Verificar Logs:**
```bash
pm2 logs
# ou
tail -f logs/app.log
```

## 🔍 **DEBUGGING:**

### **1. Testar WebSocket Diretamente:**
```javascript
// No console do navegador
const socket = io('https://api.innocodepg.online', {
  transports: ['websocket', 'polling']
});

socket.on('connect', () => {
  console.log('✅ Conectado:', socket.id);
});

socket.on('connect_error', (error) => {
  console.error('❌ Erro de conexão:', error);
});
```

### **2. Verificar SSL:**
```bash
openssl s_client -connect api.innocodepg.online:443 -servername api.innocodepg.online
```

### **3. Testar API:**
```bash
curl -X POST https://api.innocodepg.online/game-api/fortune-tiger/v2/GameInfo/Get \
  -H "Content-Type: application/json" \
  -d '{"atk": "test_atk_token_123456"}'
```

## ⚡ **SOLUÇÕES RÁPIDAS:**

### **Se WebSocket ainda falhar:**
1. **Usar apenas HTTP** temporariamente
2. **Desabilitar WebSocket** e usar apenas polling
3. **Verificar firewall** na porta 3006

### **Se Object.keys() ainda der erro:**
1. **Verificar dados do banco** estão corretos
2. **Validar JSONs** dos jogos
3. **Adicionar mais validações** nos controladores

## 🎯 **RESULTADO ESPERADO:**

Após implementar essas correções:
- ✅ WebSocket funcionando com SSL
- ✅ Sem erros de Object.keys()
- ✅ API respondendo corretamente
- ✅ Jogos carregando sem problemas

## 📞 **SUPORTE:**

Se ainda houver problemas:
1. Verificar logs detalhados
2. Testar em ambiente local primeiro
3. Validar configuração do servidor
4. Verificar certificados SSL
