#!/bin/bash

# =====================================================
# VERIFICAÇÃO DO SERVIDOR - PRÉ-DEPLOY
# =====================================================
# Verifica se o servidor está pronto para o deploy
# =====================================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função para log colorido
log() {
    echo -e "${GREEN}[CHECK] $1${NC}"
}

error() {
    echo -e "${RED}[❌] $1${NC}"
}

warning() {
    echo -e "${YELLOW}[⚠️] $1${NC}"
}

success() {
    echo -e "${GREEN}[✅] $1${NC}"
}

info() {
    echo -e "${BLUE}[ℹ️] $1${NC}"
}

echo -e "${BLUE}"
cat << "EOF"
 ____   ____   ____  ___  _____ _____   _    ____ ___ 
|  _ \ / ___| / ___|/ _ \|  ___|_   _| / \  |  _ \_ _|
| |_) | |  _  \___ \ | | | |_    | |  / _ \ | |_) | | 
|  __/| |_| |  ___) | |_| |  _|   | | / ___ \|  __/| | 
|_|    \____| |____/ \___/|_|     |_|/_/   \_\_|  |___|
                                                       
        VERIFICAÇÃO PRÉ-DEPLOY DO SERVIDOR
EOF
echo -e "${NC}"

log "Iniciando verificação do servidor..."
echo ""

# =====================================================
# VERIFICAR SISTEMA OPERACIONAL
# =====================================================

log "Verificando sistema operacional..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    success "Sistema: $PRETTY_NAME"
    
    # Verificar se é Ubuntu/Debian
    if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
        success "Sistema compatível (Ubuntu/Debian)"
    else
        warning "Sistema pode não ser totalmente compatível. Recomendado: Ubuntu 18.04+ ou Debian 10+"
    fi
else
    error "Não foi possível identificar o sistema operacional"
fi

echo ""

# =====================================================
# VERIFICAR PRIVILÉGIOS
# =====================================================

log "Verificando privilégios..."

if [[ $EUID -eq 0 ]]; then
    error "Você está executando como root. Use um usuário com sudo."
    exit 1
else
    success "Usuário não é root ✓"
fi

# Verificar sudo
if sudo -n true 2>/dev/null; then
    success "Usuário tem privilégios sudo ✓"
else
    if sudo -v; then
        success "Usuário tem privilégios sudo ✓"
    else
        error "Usuário não tem privilégios sudo"
        exit 1
    fi
fi

echo ""

# =====================================================
# VERIFICAR NODE.JS
# =====================================================

log "Verificando Node.js..."

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    success "Node.js encontrado: $NODE_VERSION"
    
    # Verificar versão
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 16 ]; then
        success "Versão do Node.js é compatível (v$NODE_MAJOR) ✓"
        
        if [ "$NODE_MAJOR" -eq 22 ]; then
            success "Node.js 22 LTS detectado - PERFEITO! ✓"
        fi
    else
        error "Versão do Node.js muito antiga ($NODE_VERSION). Mínimo: Node.js 16+"
    fi
else
    error "Node.js não encontrado"
    info "Instale Node.js 18+ ou use o script deploy-production.sh"
fi

# Verificar NPM
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    success "NPM encontrado: $NPM_VERSION ✓"
else
    error "NPM não encontrado"
fi

echo ""

# =====================================================
# VERIFICAR PORTAS
# =====================================================

log "Verificando portas..."

# Verificar porta 80 (HTTP)
if netstat -tuln 2>/dev/null | grep -q ":80 " || ss -tuln 2>/dev/null | grep -q ":80 "; then
    warning "Porta 80 já está em uso"
    netstat -tuln 2>/dev/null | grep ":80 " || ss -tuln 2>/dev/null | grep ":80 "
else
    success "Porta 80 disponível ✓"
fi

# Verificar porta 443 (HTTPS)
if netstat -tuln 2>/dev/null | grep -q ":443 " || ss -tuln 2>/dev/null | grep -q ":443 "; then
    warning "Porta 443 já está em uso"
    netstat -tuln 2>/dev/null | grep ":443 " || ss -tuln 2>/dev/null | grep ":443 "
else
    success "Porta 443 disponível ✓"
fi

# Verificar porta 3000 (API)
if netstat -tuln 2>/dev/null | grep -q ":3000 " || ss -tuln 2>/dev/null | grep -q ":3000 "; then
    warning "Porta 3000 já está em uso"
    netstat -tuln 2>/dev/null | grep ":3000 " || ss -tuln 2>/dev/null | grep ":3000 "
else
    success "Porta 3000 disponível ✓"
fi

echo ""

# =====================================================
# VERIFICAR RECURSOS DO SISTEMA
# =====================================================

log "Verificando recursos do sistema..."

# Verificar RAM
TOTAL_RAM=$(free -m | awk 'NR==2{printf "%.0f", $2}')
if [ "$TOTAL_RAM" -ge 1024 ]; then
    success "RAM: ${TOTAL_RAM}MB ✓"
else
    warning "RAM baixa: ${TOTAL_RAM}MB (recomendado: 1GB+)"
fi

# Verificar espaço em disco
DISK_SPACE=$(df -BG / | awk 'NR==2{print $4}' | sed 's/G//')
if [ "$DISK_SPACE" -ge 5 ]; then
    success "Espaço em disco: ${DISK_SPACE}GB disponível ✓"
else
    warning "Pouco espaço em disco: ${DISK_SPACE}GB (recomendado: 5GB+)"
fi

# Verificar CPU
CPU_CORES=$(nproc)
success "CPU: $CPU_CORES core(s) ✓"

echo ""

# =====================================================
# VERIFICAR CONECTIVIDADE
# =====================================================

log "Verificando conectividade..."

# Verificar conexão com internet
if ping -c 1 google.com &> /dev/null; then
    success "Conexão com internet ✓"
else
    error "Sem conexão com internet"
fi

# Verificar se pode resolver DNS
if nslookup google.com &> /dev/null; then
    success "Resolução DNS funcionando ✓"
else
    warning "Problemas com resolução DNS"
fi

echo ""

# =====================================================
# VERIFICAR SOFTWARES EXISTENTES
# =====================================================

log "Verificando softwares existentes..."

# Verificar PM2
if command -v pm2 &> /dev/null; then
    PM2_VERSION=$(pm2 --version)
    success "PM2 já instalado: $PM2_VERSION ✓"
else
    info "PM2 não instalado (será instalado durante o deploy)"
fi

# Verificar Nginx
if command -v nginx &> /dev/null; then
    NGINX_VERSION=$(nginx -v 2>&1 | cut -d' ' -f3)
    success "Nginx já instalado: $NGINX_VERSION ✓"
else
    info "Nginx não instalado (será instalado durante o deploy)"
fi

# Verificar Certbot
if command -v certbot &> /dev/null; then
    success "Certbot já instalado ✓"
else
    info "Certbot não instalado (será instalado durante o deploy)"
fi

# Verificar MySQL/MariaDB
if command -v mysql &> /dev/null; then
    MYSQL_VERSION=$(mysql --version | cut -d' ' -f6 | cut -d',' -f1)
    success "MySQL/MariaDB encontrado: $MYSQL_VERSION ✓"
else
    warning "MySQL/MariaDB não encontrado - você precisará instalar"
fi

echo ""

# =====================================================
# VERIFICAR ARQUIVOS DO PROJETO
# =====================================================

log "Verificando arquivos do projeto..."

if [ -f "package.json" ]; then
    success "package.json encontrado ✓"
    
    # Verificar se tem script de build
    if grep -q '"build"' package.json; then
        success "Script de build encontrado ✓"
    else
        warning "Script de build não encontrado em package.json"
    fi
    
    # Verificar se tem TypeScript
    if grep -q 'typescript' package.json; then
        success "TypeScript detectado ✓"
    else
        info "TypeScript não detectado"
    fi
else
    error "package.json não encontrado - execute no diretório do projeto"
fi

if [ -f "src/index.ts" ] || [ -f "src/index.js" ]; then
    success "Arquivo principal encontrado ✓"
else
    warning "Arquivo principal (src/index.ts/js) não encontrado"
fi

if [ -f "deploy-existing-node.sh" ]; then
    success "Script de deploy encontrado ✓"
else
    warning "Script de deploy não encontrado"
fi

echo ""

# =====================================================
# RESUMO E RECOMENDAÇÕES
# =====================================================

echo -e "${BLUE}=== RESUMO DA VERIFICAÇÃO ===${NC}"
echo ""

# Determinar qual script usar
if command -v node &> /dev/null; then
    NODE_MAJOR=$(echo $(node --version) | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 16 ]; then
        success "✅ SERVIDOR PRONTO PARA DEPLOY!"
        echo ""
        info "🚀 RECOMENDAÇÃO: Use o script para servidor existente:"
        echo -e "${GREEN}chmod +x deploy-existing-node.sh${NC}"
        echo -e "${GREEN}./deploy-existing-node.sh${NC}"
    else
        warning "⚠️  Node.js precisa ser atualizado"
        echo ""
        info "🚀 RECOMENDAÇÃO: Use o script completo:"
        echo -e "${GREEN}chmod +x deploy-production.sh${NC}"
        echo -e "${GREEN}./deploy-production.sh${NC}"
    fi
else
    warning "⚠️  Node.js não encontrado"
    echo ""
    info "🚀 RECOMENDAÇÃO: Use o script completo:"
    echo -e "${GREEN}chmod +x deploy-production.sh${NC}"
    echo -e "${GREEN}./deploy-production.sh${NC}"
fi

echo ""
info "📋 CHECKLIST PRÉ-DEPLOY:"
echo "  □ Domínio apontando para este servidor"
echo "  □ Banco MySQL criado e configurado"
echo "  □ Portas 80, 443 e 3000 liberadas no firewall"
echo "  □ Arquivos do projeto no servidor"

echo ""
log "Verificação concluída! 🎯"
