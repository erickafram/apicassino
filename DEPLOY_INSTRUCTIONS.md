# 🚀 DEPLOY AUTOMÁTICO - API PG SOFT NODE

## 📋 VISÃO GERAL

Este sistema de deploy automático instala e configura completamente sua API em um servidor de produção Ubuntu/Debian, incluindo:

- ✅ **Node.js 18 LTS**
- ✅ **PM2** (gerenciamento de processos)
- ✅ **Nginx** (proxy reverso)
- ✅ **SSL/HTTPS** (Let's Encrypt)
- ✅ **Firewall** configurado
- ✅ **Logs** estruturados
- ✅ **Monitoramento** automático

---

## 🛠️ PRÉ-REQUISITOS

### **Servidor:**
- Ubuntu 18.04+ ou Debian 10+
- Mínimo 1GB RAM, 1 CPU
- Acesso root/sudo
- Porta 80 e 443 abertas

### **Domínio:**
- Domínio apontando para o IP do servidor
- Acesso ao DNS para configuração

### **Banco de Dados:**
- MySQL/MariaDB instalado
- Usuário e banco criados
- Permissões configuradas

---

## 🚀 INSTALAÇÃO

### **1. Preparar Arquivos:**
```bash
# Fazer upload dos arquivos para o servidor
scp -r . usuario@servidor:/home/usuario/api-pgsoft-node/

# Conectar no servidor
ssh usuario@servidor

# Ir para o diretório
cd /home/usuario/api-pgsoft-node/
```

### **2. Escolher Script de Deploy:**

#### **Opção A: Servidor Limpo (instala tudo)**
```bash
# Para servidores sem Node.js
chmod +x deploy-production.sh
./deploy-production.sh
```

#### **Opção B: Servidor com Node.js Existente** ⭐ **RECOMENDADO**
```bash
# Para servidores que já têm Node.js 22 LTS na porta 3000
chmod +x deploy-existing-node.sh
./deploy-existing-node.sh
```

### **3. Informações Solicitadas:**
Durante a execução, o script pedirá:

- **Domínio da API**: `api.meusite.com`
- **Email para SSL**: `admin@meusite.com`
- **Porta da API**: `3000` (padrão para Node.js 22 LTS)
- **Usuário MySQL**: `api_user`
- **Senha MySQL**: `senha_segura`
- **Nome do Banco**: `api_pgsoft`

---

## 📊 CONFIGURAÇÃO DO BANCO

### **1. Criar Banco e Usuário:**
```sql
-- Conectar no MySQL
mysql -u root -p

-- Criar banco
CREATE DATABASE api_pgsoft CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Criar usuário
CREATE USER 'api_user'@'localhost' IDENTIFIED BY 'senha_segura';

-- Dar permissões
GRANT ALL PRIVILEGES ON api_pgsoft.* TO 'api_user'@'localhost';
FLUSH PRIVILEGES;
```

### **2. Importar Estrutura:**
```bash
# Importar banco atualizado
mysql -u api_user -p api_pgsoft < pgapi_complete_database.sql

# Executar migração de compatibilidade
mysql -u api_user -p api_pgsoft < database_migration_cassino_compatibility.sql
```

---

## 🎛️ GERENCIAMENTO DA API

### **Usar o Script de Gerenciamento:**
```bash
# Dar permissão
chmod +x manage-api.sh

# Ver comandos disponíveis
./manage-api.sh

# Exemplos de uso:
./manage-api.sh status    # Ver status
./manage-api.sh logs      # Ver logs
./manage-api.sh restart   # Reiniciar
./manage-api.sh health    # Verificar saúde
```

### **Comandos Disponíveis:**

| Comando | Descrição |
|---------|-----------|
| `start` | Iniciar a API |
| `stop` | Parar a API |
| `restart` | Reiniciar a API |
| `status` | Ver status completo |
| `logs` | Ver logs em tempo real |
| `update` | Atualizar código |
| `backup` | Fazer backup |
| `restore` | Restaurar backup |
| `health` | Verificar saúde |
| `monitor` | Monitorar recursos |

---

## 🔧 COMANDOS ÚTEIS

### **PM2 (Gerenciamento de Processos):**
```bash
pm2 status                # Status dos processos
pm2 logs api-pgsoft       # Ver logs
pm2 restart api-pgsoft    # Reiniciar API
pm2 stop api-pgsoft       # Parar API
pm2 delete api-pgsoft     # Remover processo
pm2 monit                 # Monitor em tempo real
```

### **Nginx (Servidor Web):**
```bash
sudo systemctl status nginx    # Status do Nginx
sudo systemctl restart nginx   # Reiniciar Nginx
sudo nginx -t                  # Testar configuração
sudo tail -f /var/log/nginx/access.log  # Ver logs
```

### **SSL (Certificados):**
```bash
sudo certbot certificates      # Ver certificados
sudo certbot renew            # Renovar certificados
sudo certbot renew --dry-run  # Testar renovação
```

---

## 📁 ESTRUTURA DE ARQUIVOS

```
/var/www/api-pgsoft-node/          # Projeto principal
├── src/                           # Código fonte
├── dist/                          # Código compilado
├── node_modules/                  # Dependências
├── .env                          # Variáveis de ambiente
├── ecosystem.config.js           # Configuração PM2
└── package.json                  # Dependências do projeto

/etc/nginx/sites-available/       # Configurações Nginx
/etc/letsencrypt/live/            # Certificados SSL
/var/log/                         # Logs da aplicação
/var/backups/api-pgsoft/          # Backups automáticos
```

---

## 🔍 MONITORAMENTO

### **Verificar se tudo está funcionando:**
```bash
# Status geral
./manage-api.sh status

# Verificar saúde
./manage-api.sh health

# Testar API
curl https://api.meusite.com/health

# Ver logs em tempo real
./manage-api.sh logs
```

### **URLs Importantes:**
- **API**: `https://api.meusite.com`
- **Health Check**: `https://api.meusite.com/health`
- **Status**: `https://api.meusite.com/status`

---

## 🚨 SOLUÇÃO DE PROBLEMAS

### **API não inicia:**
```bash
# Verificar logs
./manage-api.sh logs

# Verificar configuração
cat /var/www/api-pgsoft-node/.env

# Reiniciar
./manage-api.sh restart
```

### **SSL não funciona:**
```bash
# Verificar certificados
sudo certbot certificates

# Renovar certificados
sudo certbot renew

# Testar Nginx
sudo nginx -t
```

### **Banco não conecta:**
```bash
# Testar conexão
mysql -u api_user -p api_pgsoft

# Verificar variáveis
grep DB_ /var/www/api-pgsoft-node/.env
```

### **Porta não responde:**
```bash
# Verificar se porta está aberta
netstat -tuln | grep :3001

# Verificar firewall
sudo ufw status

# Verificar processo
pm2 status
```

---

## 🔄 ATUALIZAÇÕES

### **Atualizar código:**
```bash
# Método automático
./manage-api.sh update

# Método manual
cd /var/www/api-pgsoft-node
git pull origin main
npm install
npm run build
pm2 restart api-pgsoft
```

### **Fazer backup antes de atualizar:**
```bash
./manage-api.sh backup
```

---

## 📞 SUPORTE

### **Logs importantes:**
- **API**: `/var/log/api-pgsoft.log`
- **PM2**: `pm2 logs api-pgsoft`
- **Nginx**: `/var/log/nginx/error.log`
- **SSL**: `/var/log/letsencrypt/letsencrypt.log`

### **Comandos de diagnóstico:**
```bash
# Status completo do sistema
./manage-api.sh status

# Verificação de saúde
./manage-api.sh health

# Monitoramento em tempo real
./manage-api.sh monitor
```

---

## ✅ CHECKLIST PÓS-DEPLOY

- [ ] API responde em `https://dominio.com`
- [ ] SSL está funcionando (cadeado verde)
- [ ] Banco de dados conecta corretamente
- [ ] PM2 mostra processo ativo
- [ ] Nginx está rodando
- [ ] Firewall configurado
- [ ] Logs estão sendo gerados
- [ ] Backup automático funcionando
- [ ] Health check retorna OK

**Deploy concluído com sucesso! 🎉**
