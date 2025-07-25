#!/bin/bash

# =====================================================
# DEPLOY PARA CLOUDPANEL - API PG SOFT NODE
# =====================================================
# Para servidores com CloudPanel já configurado
# =====================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

echo -e "${BLUE}"
cat << "EOF"
 ____   ____   ____  ___  _____ _____   _    ____ ___ 
|  _ \ / ___| / ___|/ _ \|  ___|_   _| / \  |  _ \_ _|
| |_) | |  _  \___ \ | | | |_    | |  / _ \ | |_) | | 
|  __/| |_| |  ___) | |_| |  _|   | | / ___ \|  __/| | 
|_|    \____| |____/ \___/|_|     |_|/_/   \_\_|  |___|
                                                       
        DEPLOY PARA CLOUDPANEL
EOF
echo -e "${NC}"

# =====================================================
# VERIFICAR CLOUDPANEL
# =====================================================

log "Verificando ambiente CloudPanel..."

# Verificar se está no diretório correto do CloudPanel
if [[ ! "$PWD" =~ /home/.*/htdocs/.* ]]; then
    warning "Você não está em um diretório do CloudPanel"
    info "Diretório atual: $PWD"
    info "Esperado: /home/usuario/htdocs/dominio.com"
    echo ""
    read -p "Continuar mesmo assim? (y/N): " CONTINUE
    if [[ ! $CONTINUE =~ ^[Yy]$ ]]; then
        error "Deploy cancelado"
    fi
fi

# Detectar configurações do CloudPanel
SITE_USER=$(whoami)
CURRENT_DIR=$(pwd)
DOMAIN=$(basename "$CURRENT_DIR")

log "Usuário: $SITE_USER"
log "Diretório: $CURRENT_DIR"
log "Domínio detectado: $DOMAIN"

# =====================================================
# CONFIGURAÇÕES
# =====================================================

echo ""
log "=== CONFIGURAÇÃO DO DEPLOY ==="
echo ""

read -p "Confirma o domínio [$DOMAIN]: " INPUT_DOMAIN
DOMAIN=${INPUT_DOMAIN:-$DOMAIN}

read -p "Digite a porta da API (padrão: 3000): " API_PORT
API_PORT=${API_PORT:-3000}

read -p "Digite o usuário do banco MySQL: " DB_USER
read -s -p "Digite a senha do banco MySQL: " DB_PASS
echo ""
read -p "Digite o nome do banco de dados: " DB_NAME

echo ""
log "=== CONFIGURAÇÕES ==="
info "Domínio: $DOMAIN"
info "Porta da API: $API_PORT"
info "Usuário do site: $SITE_USER"
info "Diretório: $CURRENT_DIR"
info "Banco: $DB_NAME"
echo ""

read -p "Confirma as configurações? (y/N): " CONFIRM
if [[ ! $CONFIRM =~ ^[Yy]$ ]]; then
    error "Deploy cancelado pelo usuário"
fi

# =====================================================
# VERIFICAR NODE.JS
# =====================================================

log "Verificando Node.js..."

if ! command -v node &> /dev/null; then
    error "Node.js não encontrado. Verifique a instalação no CloudPanel."
fi

if ! command -v npm &> /dev/null; then
    error "NPM não encontrado. Verifique a instalação no CloudPanel."
fi

NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
log "Node.js: $NODE_VERSION"
log "NPM: $NPM_VERSION"

# Verificar versão mínima
NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
if [ "$NODE_MAJOR" -lt 16 ]; then
    error "Node.js versão $NODE_VERSION não é compatível. Mínimo: Node.js 16+"
fi

# =====================================================
# VERIFICAR/INSTALAR PM2
# =====================================================

log "Verificando PM2..."

if ! command -v pm2 &> /dev/null; then
    log "Instalando PM2..."
    npm install -g pm2
    log "PM2 instalado"
else
    log "PM2 já está instalado: $(pm2 --version)"
fi

# =====================================================
# INSTALAR DEPENDÊNCIAS DO PROJETO
# =====================================================

log "Instalando dependências do projeto..."

if [ ! -f "package.json" ]; then
    error "package.json não encontrado. Execute este script no diretório do projeto."
fi

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
LOG_FILE=./logs/api-pgsoft.log

# Configurações SSL (CloudPanel gerencia)
SSL_ENABLED=true
EOF

log "Arquivo .env criado"

# =====================================================
# COMPILAR TYPESCRIPT
# =====================================================

log "Compilando TypeScript..."
npm run build || npx tsc || warning "Falha na compilação TypeScript - continuando..."

# =====================================================
# CRIAR ESTRUTURA DE LOGS
# =====================================================

log "Criando estrutura de logs..."
mkdir -p logs
mkdir -p tmp

# =====================================================
# CONFIGURAR PM2 PARA CLOUDPANEL
# =====================================================

log "Configurando PM2 para CloudPanel..."

cat > ecosystem.config.js << EOF
module.exports = {
  apps: [{
    name: 'api-pgsoft-$SITE_USER',
    script: './dist/index.js',
    instances: 1,
    exec_mode: 'fork',
    cwd: '$CURRENT_DIR',
    env: {
      NODE_ENV: 'production',
      PORT: $API_PORT,
      USER: '$SITE_USER'
    },
    error_file: './logs/api-pgsoft-error.log',
    out_file: './logs/api-pgsoft-out.log',
    log_file: './logs/api-pgsoft.log',
    time: true,
    max_memory_restart: '1G',
    restart_delay: 4000,
    max_restarts: 10,
    min_uptime: '10s',
    watch: false,
    ignore_watch: ['node_modules', 'logs', '*.log']
  }]
};
EOF

# Parar processo anterior se existir
pm2 delete "api-pgsoft-$SITE_USER" 2>/dev/null || true

# Iniciar aplicação
pm2 start ecosystem.config.js

# Salvar configuração do PM2
pm2 save

log "PM2 configurado e aplicação iniciada"

# =====================================================
# CONFIGURAR STARTUP SCRIPT PARA CLOUDPANEL
# =====================================================

log "Configurando script de inicialização..."

# Criar script de startup personalizado
cat > startup.sh << 'EOF'
#!/bin/bash
# Script de inicialização para CloudPanel
cd "$(dirname "$0")"
pm2 start ecosystem.config.js
EOF

chmod +x startup.sh

# =====================================================
# VERIFICAR PORTA
# =====================================================

log "Verificando se a porta está disponível..."

if netstat -tuln 2>/dev/null | grep -q ":$API_PORT " || ss -tuln 2>/dev/null | grep -q ":$API_PORT "; then
    warning "Porta $API_PORT já está em uso"
    netstat -tuln 2>/dev/null | grep ":$API_PORT " || ss -tuln 2>/dev/null | grep ":$API_PORT "
    echo ""
    warning "Verifique se não há conflito com outros serviços"
else
    log "Porta $API_PORT disponível"
fi

# =====================================================
# TESTAR A API
# =====================================================

log "Testando a API..."

sleep 3  # Aguardar inicialização

if curl -s http://localhost:$API_PORT/health >/dev/null 2>&1; then
    log "✅ API respondendo na porta $API_PORT"
elif curl -s http://localhost:$API_PORT >/dev/null 2>&1; then
    log "✅ API respondendo na porta $API_PORT (sem endpoint /health)"
else
    warning "⚠️ API pode não estar respondendo. Verifique os logs."
fi

# =====================================================
# FINALIZAÇÃO
# =====================================================

echo ""
log "=== DEPLOY CLOUDPANEL CONCLUÍDO! ==="
echo ""
info "🌐 Domínio: https://$DOMAIN"
info "🔧 Porta interna: $API_PORT"
info "👤 Usuário: $SITE_USER"
info "📁 Diretório: $CURRENT_DIR"
info "📊 Status: pm2 status"
info "📋 Logs: pm2 logs api-pgsoft-$SITE_USER"
info "🔄 Restart: pm2 restart api-pgsoft-$SITE_USER"
echo ""
warning "PRÓXIMOS PASSOS NO CLOUDPANEL:"
warning "1. Acesse o painel: https://seu-servidor:8443"
warning "2. Vá em Sites → $DOMAIN"
warning "3. Configure 'App Port' para: $API_PORT"
warning "4. Ative SSL se ainda não estiver ativo"
warning "5. Teste: https://$DOMAIN"
echo ""
info "COMANDOS ÚTEIS:"
info "• Ver status: pm2 status"
info "• Ver logs: pm2 logs api-pgsoft-$SITE_USER"
info "• Reiniciar: pm2 restart api-pgsoft-$SITE_USER"
info "• Parar: pm2 stop api-pgsoft-$SITE_USER"
echo ""
log "Deploy finalizado! 🚀"

# Mostrar status final
echo ""
log "Status atual do PM2:"
pm2 status
