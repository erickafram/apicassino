#!/bin/bash

# =====================================================
# SCRIPT DE DEPLOY AUTOMÁTICO - API PG SOFT NODE
# =====================================================
# Este script instala e configura automaticamente:
# - Node.js 18 LTS
# - PM2 para gerenciamento de processos
# - Nginx com configuração SSL
# - Configuração de domínio
# - Deploy da API
# =====================================================

set -e  # Parar em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log colorido
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# =====================================================
# CONFIGURAÇÕES INICIAIS
# =====================================================

echo -e "${BLUE}"
cat << "EOF"
 ____   ____   ____  ___  _____ _____   _    ____ ___ 
|  _ \ / ___| / ___|/ _ \|  ___|_   _| / \  |  _ \_ _|
| |_) | |  _  \___ \ | | | |_    | |  / _ \ | |_) | | 
|  __/| |_| |  ___) | |_| |  _|   | | / ___ \|  __/| | 
|_|    \____| |____/ \___/|_|     |_|/_/   \_\_|  |___|
                                                       
        DEPLOY AUTOMÁTICO - SERVIDOR DE PRODUÇÃO
EOF
echo -e "${NC}"

# Verificar se está rodando como root
if [[ $EUID -eq 0 ]]; then
   error "Este script não deve ser executado como root. Use um usuário com sudo."
fi

# Solicitar informações do usuário
echo ""
log "=== CONFIGURAÇÃO DO DEPLOY ==="
echo ""

read -p "Digite o domínio da API (ex: api.meusite.com): " DOMAIN
read -p "Digite o email para SSL (Let's Encrypt): " EMAIL
read -p "Digite a porta da API (padrão: 3000): " API_PORT
read -p "Digite o usuário do banco MySQL: " DB_USER
read -s -p "Digite a senha do banco MySQL: " DB_PASS
echo ""
read -p "Digite o nome do banco de dados: " DB_NAME

# Definir valores padrão
API_PORT=${API_PORT:-3000}
PROJECT_DIR="/var/www/api-pgsoft-node"
NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
NGINX_ENABLED="/etc/nginx/sites-enabled/$DOMAIN"

echo ""
log "=== CONFIGURAÇÕES ==="
info "Domínio: $DOMAIN"
info "Email: $EMAIL"
info "Porta da API: $API_PORT (Node.js 22 LTS)"
info "Diretório: $PROJECT_DIR"
info "Banco: $DB_NAME"
echo ""

read -p "Confirma as configurações? (y/N): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    error "Deploy cancelado pelo usuário"
fi

# =====================================================
# ATUALIZAR SISTEMA
# =====================================================

log "Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# =====================================================
# INSTALAR DEPENDÊNCIAS
# =====================================================

log "Instalando dependências básicas..."
sudo apt install -y curl wget git unzip software-properties-common apt-transport-https ca-certificates gnupg lsb-release

# =====================================================
# VERIFICAR NODE.JS (JÁ INSTALADO - NODE 22 LTS)
# =====================================================

log "Verificando Node.js existente..."

# Verificar se Node.js está instalado
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    log "Node.js encontrado: $NODE_VERSION"
    log "NPM encontrado: $NPM_VERSION"

    # Verificar se é uma versão compatível (Node 16+)
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 16 ]; then
        log "Versão do Node.js é compatível (v$NODE_MAJOR)"
    else
        warning "Versão do Node.js pode ser incompatível. Recomendado: Node 18+"
    fi
else
    error "Node.js não encontrado. Por favor, instale Node.js 18+ primeiro."
fi

# =====================================================
# INSTALAR PM2
# =====================================================

log "Instalando PM2..."
sudo npm install -g pm2

# Configurar PM2 para iniciar com o sistema
sudo pm2 startup systemd -u $USER --hp /home/$USER
pm2 save

log "PM2 instalado e configurado"

# =====================================================
# INSTALAR NGINX
# =====================================================

log "Instalando Nginx..."
sudo apt install -y nginx

# Iniciar e habilitar Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

log "Nginx instalado e iniciado"

# =====================================================
# INSTALAR CERTBOT (SSL)
# =====================================================

log "Instalando Certbot para SSL..."
sudo apt install -y certbot python3-certbot-nginx

# =====================================================
# CLONAR/CONFIGURAR PROJETO
# =====================================================

log "Configurando projeto..."

# Criar diretório se não existir
sudo mkdir -p $PROJECT_DIR
sudo chown $USER:$USER $PROJECT_DIR

# Se já existe, fazer backup
if [ -d "$PROJECT_DIR/.git" ]; then
    warning "Projeto já existe. Fazendo backup..."
    sudo cp -r $PROJECT_DIR $PROJECT_DIR.backup.$(date +%Y%m%d_%H%M%S)
    cd $PROJECT_DIR
    git pull origin main || git pull origin master
else
    log "Clonando projeto..."
    # Aqui você pode colocar o link do seu repositório
    # git clone https://github.com/seu-usuario/api-pgsoft-node.git $PROJECT_DIR
    # Por enquanto, assumindo que os arquivos já estão no servidor
    if [ ! -f "$PROJECT_DIR/package.json" ]; then
        error "Arquivos do projeto não encontrados em $PROJECT_DIR"
    fi
fi

cd $PROJECT_DIR

# =====================================================
# INSTALAR DEPENDÊNCIAS DO PROJETO
# =====================================================

log "Instalando dependências do projeto..."
npm install

# =====================================================
# CONFIGURAR VARIÁVEIS DE AMBIENTE
# =====================================================

log "Configurando variáveis de ambiente..."

cat > .env << EOF
# Configurações do Servidor
PORT=$API_PORT
NODE_ENV=production

# Configurações do Banco de Dados
DB_HOST=localhost
DB_PORT=3306
DB_USER=$DB_USER
DB_PASS=$DB_PASS
DB_NAME=$DB_NAME

# Configurações da API
API_URL=https://$DOMAIN
DOMAIN=$DOMAIN

# Configurações de Segurança
JWT_SECRET=$(openssl rand -base64 32)
API_SECRET=$(openssl rand -base64 32)

# Configurações de Log
LOG_LEVEL=info
LOG_FILE=/var/log/api-pgsoft.log

# Configurações SSL
SSL_ENABLED=true
EOF

log "Arquivo .env criado"

# =====================================================
# COMPILAR TYPESCRIPT
# =====================================================

log "Compilando TypeScript..."
npm run build || npx tsc

# =====================================================
# CONFIGURAR NGINX
# =====================================================

log "Configurando Nginx..."

sudo tee $NGINX_CONF > /dev/null << EOF
server {
    listen 80;
    server_name $DOMAIN;
    
    # Redirect HTTP to HTTPS
    return 301 https://\$server_name\$request_uri;
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;
    
    # SSL Configuration (será configurado pelo Certbot)
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    
    # SSL Security
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security Headers
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # Rate Limiting
    limit_req_zone \$binary_remote_addr zone=api:10m rate=10r/s;
    limit_req zone=api burst=20 nodelay;
    
    # Proxy to Node.js API
    location / {
        proxy_pass http://localhost:$API_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_cache_bypass \$http_upgrade;
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
    
    # Health Check
    location /health {
        proxy_pass http://localhost:$API_PORT/health;
        access_log off;
    }
    
    # Block access to sensitive files
    location ~ /\. {
        deny all;
    }
    
    location ~ \.(env|log)$ {
        deny all;
    }
}
EOF

# Habilitar site
sudo ln -sf $NGINX_CONF $NGINX_ENABLED

# Testar configuração
sudo nginx -t || error "Erro na configuração do Nginx"

log "Nginx configurado"

# =====================================================
# CONFIGURAR SSL COM CERTBOT
# =====================================================

log "Configurando SSL com Let's Encrypt..."

# Parar nginx temporariamente para certbot
sudo systemctl stop nginx

# Obter certificado SSL
sudo certbot certonly --standalone -d $DOMAIN --email $EMAIL --agree-tos --non-interactive

# Reiniciar nginx
sudo systemctl start nginx

log "SSL configurado"

# =====================================================
# CONFIGURAR PM2
# =====================================================

log "Configurando PM2..."

# Criar arquivo de configuração do PM2
cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'api-pgsoft',
    script: './dist/index.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: $API_PORT
    },
    error_file: '/var/log/api-pgsoft-error.log',
    out_file: '/var/log/api-pgsoft-out.log',
    log_file: '/var/log/api-pgsoft.log',
    time: true,
    max_memory_restart: '1G',
    node_args: '--max-old-space-size=1024',
    watch: false,
    ignore_watch: ['node_modules', 'logs', '*.log'],
    restart_delay: 4000,
    max_restarts: 10,
    min_uptime: '10s'
  }]
};
EOF

# Parar processo anterior se existir
pm2 delete api-pgsoft 2>/dev/null || true

# Iniciar aplicação
pm2 start ecosystem.config.js

# Salvar configuração
pm2 save

log "PM2 configurado e aplicação iniciada"

# =====================================================
# CONFIGURAR FIREWALL
# =====================================================

log "Configurando firewall..."

sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw allow $API_PORT
sudo ufw --force enable

log "Firewall configurado"

# =====================================================
# CONFIGURAR LOGS
# =====================================================

log "Configurando logs..."

# Criar diretório de logs
sudo mkdir -p /var/log
sudo touch /var/log/api-pgsoft.log
sudo touch /var/log/api-pgsoft-error.log
sudo touch /var/log/api-pgsoft-out.log
sudo chown $USER:$USER /var/log/api-pgsoft*.log

# Configurar logrotate
sudo tee /etc/logrotate.d/api-pgsoft > /dev/null << EOF
/var/log/api-pgsoft*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 $USER $USER
    postrotate
        pm2 reload api-pgsoft
    endscript
}
EOF

log "Logs configurados"

# =====================================================
# FINALIZAÇÃO
# =====================================================

log "Reiniciando serviços..."
sudo systemctl reload nginx
pm2 restart api-pgsoft

echo ""
log "=== DEPLOY CONCLUÍDO COM SUCESSO! ==="
echo ""
info "🌐 URL da API: https://$DOMAIN"
info "🔧 Porta: $API_PORT"
info "📁 Diretório: $PROJECT_DIR"
info "📊 Status PM2: pm2 status"
info "📋 Logs: pm2 logs api-pgsoft"
info "🔄 Restart: pm2 restart api-pgsoft"
echo ""
warning "IMPORTANTE:"
warning "1. Configure seu banco de dados MySQL"
warning "2. Execute a migração: mysql -u $DB_USER -p $DB_NAME < pgapi_complete_database.sql"
warning "3. Teste a API: curl https://$DOMAIN/health"
echo ""
log "Deploy finalizado! 🚀"
