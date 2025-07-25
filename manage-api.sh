#!/bin/bash

# =====================================================
# SCRIPT DE GERENCIAMENTO - API PG SOFT NODE
# =====================================================
# Script para gerenciar a API após o deploy
# Comandos: start, stop, restart, status, logs, update
# =====================================================

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configurações
APP_NAME="api-pgsoft"
PROJECT_DIR="/var/www/api-pgsoft-node"

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

# Função para mostrar uso
show_usage() {
    echo -e "${BLUE}"
    cat << "EOF"
 ____   ____   ____  ___  _____ _____   _    ____ ___ 
|  _ \ / ___| / ___|/ _ \|  ___|_   _| / \  |  _ \_ _|
| |_) | |  _  \___ \ | | | |_    | |  / _ \ | |_) | | 
|  __/| |_| |  ___) | |_| |  _|   | | / ___ \|  __/| | 
|_|    \____| |____/ \___/|_|     |_|/_/   \_\_|  |___|
                                                       
           GERENCIADOR DA API - PRODUÇÃO
EOF
    echo -e "${NC}"
    echo "Uso: $0 {start|stop|restart|status|logs|update|backup|restore|health}"
    echo ""
    echo "Comandos disponíveis:"
    echo "  start     - Iniciar a API"
    echo "  stop      - Parar a API"
    echo "  restart   - Reiniciar a API"
    echo "  status    - Ver status da API"
    echo "  logs      - Ver logs em tempo real"
    echo "  update    - Atualizar código e reiniciar"
    echo "  backup    - Fazer backup do projeto"
    echo "  restore   - Restaurar backup"
    echo "  health    - Verificar saúde da API"
    echo "  monitor   - Monitorar recursos"
    echo ""
}

# Verificar se PM2 está instalado
check_pm2() {
    if ! command -v pm2 &> /dev/null; then
        error "PM2 não está instalado. Execute o script de deploy primeiro."
    fi
}

# Verificar se o projeto existe
check_project() {
    if [ ! -d "$PROJECT_DIR" ]; then
        error "Projeto não encontrado em $PROJECT_DIR"
    fi
}

# Função para iniciar a API
start_api() {
    log "Iniciando API..."
    check_pm2
    check_project
    
    cd $PROJECT_DIR
    pm2 start ecosystem.config.js
    pm2 save
    
    log "API iniciada com sucesso!"
    pm2 status
}

# Função para parar a API
stop_api() {
    log "Parando API..."
    check_pm2
    
    pm2 stop $APP_NAME
    log "API parada com sucesso!"
}

# Função para reiniciar a API
restart_api() {
    log "Reiniciando API..."
    check_pm2
    check_project
    
    cd $PROJECT_DIR
    pm2 restart $APP_NAME
    
    log "API reiniciada com sucesso!"
    pm2 status
}

# Função para ver status
show_status() {
    check_pm2
    
    echo -e "${BLUE}=== STATUS DA API ===${NC}"
    pm2 status
    echo ""
    
    echo -e "${BLUE}=== INFORMAÇÕES DO SISTEMA ===${NC}"
    echo "Uptime do sistema: $(uptime -p)"
    echo "Uso de memória: $(free -h | grep '^Mem:' | awk '{print $3 "/" $2}')"
    echo "Uso de disco: $(df -h / | tail -1 | awk '{print $3 "/" $2 " (" $5 ")"}')"
    echo ""
    
    echo -e "${BLUE}=== STATUS DO NGINX ===${NC}"
    sudo systemctl status nginx --no-pager -l
}

# Função para ver logs
show_logs() {
    check_pm2
    
    echo -e "${BLUE}=== LOGS DA API (Ctrl+C para sair) ===${NC}"
    pm2 logs $APP_NAME --lines 50
}

# Função para atualizar
update_api() {
    log "Atualizando API..."
    check_project
    
    cd $PROJECT_DIR
    
    # Fazer backup antes da atualização
    backup_api
    
    # Atualizar código (assumindo git)
    if [ -d ".git" ]; then
        log "Atualizando código do repositório..."
        git pull origin main || git pull origin master
    else
        warning "Repositório git não encontrado. Atualize os arquivos manualmente."
    fi
    
    # Instalar dependências
    log "Instalando dependências..."
    npm install
    
    # Compilar TypeScript
    log "Compilando TypeScript..."
    npm run build || npx tsc
    
    # Reiniciar aplicação
    log "Reiniciando aplicação..."
    pm2 restart $APP_NAME
    
    log "Atualização concluída!"
    pm2 status
}

# Função para fazer backup
backup_api() {
    log "Fazendo backup..."
    check_project
    
    BACKUP_DIR="/var/backups/api-pgsoft"
    BACKUP_FILE="$BACKUP_DIR/backup-$(date +%Y%m%d_%H%M%S).tar.gz"
    
    sudo mkdir -p $BACKUP_DIR
    
    # Criar backup
    sudo tar -czf $BACKUP_FILE -C $(dirname $PROJECT_DIR) $(basename $PROJECT_DIR) \
        --exclude=node_modules \
        --exclude=dist \
        --exclude=logs \
        --exclude=*.log
    
    sudo chown $USER:$USER $BACKUP_FILE
    
    log "Backup criado: $BACKUP_FILE"
    
    # Manter apenas os 5 backups mais recentes
    sudo find $BACKUP_DIR -name "backup-*.tar.gz" -type f -mtime +5 -delete
}

# Função para restaurar backup
restore_api() {
    log "Restaurando backup..."
    
    BACKUP_DIR="/var/backups/api-pgsoft"
    
    if [ ! -d "$BACKUP_DIR" ]; then
        error "Diretório de backup não encontrado: $BACKUP_DIR"
    fi
    
    # Listar backups disponíveis
    echo -e "${BLUE}Backups disponíveis:${NC}"
    ls -la $BACKUP_DIR/backup-*.tar.gz 2>/dev/null || error "Nenhum backup encontrado"
    
    echo ""
    read -p "Digite o nome do arquivo de backup: " BACKUP_FILE
    
    if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
        error "Arquivo de backup não encontrado: $BACKUP_DIR/$BACKUP_FILE"
    fi
    
    # Parar aplicação
    pm2 stop $APP_NAME
    
    # Fazer backup do estado atual
    mv $PROJECT_DIR $PROJECT_DIR.old.$(date +%Y%m%d_%H%M%S)
    
    # Restaurar backup
    sudo tar -xzf $BACKUP_DIR/$BACKUP_FILE -C $(dirname $PROJECT_DIR)
    sudo chown -R $USER:$USER $PROJECT_DIR
    
    # Reinstalar dependências
    cd $PROJECT_DIR
    npm install
    npm run build || npx tsc
    
    # Reiniciar aplicação
    pm2 start ecosystem.config.js
    
    log "Backup restaurado com sucesso!"
}

# Função para verificar saúde da API
health_check() {
    log "Verificando saúde da API..."
    
    # Verificar se o processo está rodando
    if pm2 list | grep -q $APP_NAME; then
        info "✅ Processo PM2 está rodando"
    else
        error "❌ Processo PM2 não está rodando"
    fi
    
    # Verificar se a porta está aberta
    PORT=$(grep "PORT=" $PROJECT_DIR/.env | cut -d'=' -f2)
    if netstat -tuln | grep -q ":$PORT "; then
        info "✅ Porta $PORT está aberta"
    else
        warning "⚠️  Porta $PORT não está aberta"
    fi
    
    # Verificar Nginx
    if sudo systemctl is-active --quiet nginx; then
        info "✅ Nginx está rodando"
    else
        warning "⚠️  Nginx não está rodando"
    fi
    
    # Verificar SSL
    DOMAIN=$(grep "DOMAIN=" $PROJECT_DIR/.env | cut -d'=' -f2)
    if [ ! -z "$DOMAIN" ]; then
        if curl -s -o /dev/null -w "%{http_code}" https://$DOMAIN/health | grep -q "200"; then
            info "✅ API respondendo via HTTPS"
        else
            warning "⚠️  API não está respondendo via HTTPS"
        fi
    fi
    
    # Verificar logs de erro
    ERROR_COUNT=$(pm2 logs $APP_NAME --lines 100 --nostream | grep -i error | wc -l)
    if [ $ERROR_COUNT -eq 0 ]; then
        info "✅ Nenhum erro recente nos logs"
    else
        warning "⚠️  $ERROR_COUNT erros encontrados nos logs recentes"
    fi
    
    log "Verificação de saúde concluída!"
}

# Função para monitorar recursos
monitor_api() {
    log "Monitorando recursos da API..."
    
    echo -e "${BLUE}=== MONITORAMENTO EM TEMPO REAL ===${NC}"
    echo "Pressione Ctrl+C para sair"
    echo ""
    
    pm2 monit
}

# Função principal
main() {
    case "$1" in
        start)
            start_api
            ;;
        stop)
            stop_api
            ;;
        restart)
            restart_api
            ;;
        status)
            show_status
            ;;
        logs)
            show_logs
            ;;
        update)
            update_api
            ;;
        backup)
            backup_api
            ;;
        restore)
            restore_api
            ;;
        health)
            health_check
            ;;
        monitor)
            monitor_api
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
}

# Executar função principal
main "$@"
