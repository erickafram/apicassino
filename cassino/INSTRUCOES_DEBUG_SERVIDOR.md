# 🚨 INSTRUÇÕES PARA DEBUG NO SERVIDOR

O erro `INVALID_USER` ainda persiste. Vamos debugar diretamente no servidor do cassino.

## 📋 PASSOS PARA EXECUTAR NO SERVIDOR

### **1. Conectar no servidor do cassino**
```bash
# Conecte no servidor onde está o cassino (não a API)
ssh root@seu-servidor-cassino
```

### **2. Navegar para o diretório do cassino**
```bash
# Encontre onde está o projeto do cassino
cd /path/to/cassino
# Exemplo: cd /var/www/cassino
# Ou: cd /home/cassino/htdocs
```

### **3. Executar scripts de debug**

#### **A. Debug do banco de dados:**
```bash
php debug_webhook.php
```

#### **B. Verificar configuração:**
```bash
php check_webhook_route.php
```

### **4. Verificar se o trait foi atualizado**
```bash
# Ver as primeiras linhas do trait
head -20 app/Traits/Providers/EvergameTrait.php

# Procurar pelo método GetBalanceInfoEvergame
grep -A 10 "GetBalanceInfoEvergame" app/Traits/Providers/EvergameTrait.php
```

### **5. Limpar cache do Laravel**
```bash
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan route:cache
```

### **6. Verificar rotas**
```bash
# Listar rotas do evergame
php artisan route:list | grep -i evergame

# Se não aparecer nada, o problema está na rota!
```

### **7. Testar webhook diretamente**
```bash
# Testar o endpoint
curl -X POST http://localhost/api/evergame/webhook \
     -H 'Content-Type: application/json' \
     -d '{"method":"GetBalance","userCode":38}'
```

### **8. Ver logs em tempo real**
```bash
# Em um terminal separado, monitore os logs
tail -f storage/logs/laravel.log | grep -i "balance\|invalid\|user"
```

## 🔍 POSSÍVEIS PROBLEMAS E SOLUÇÕES

### **Problema 1: Trait não atualizado**
```bash
# Verificar se o git pull funcionou
git log --oneline -5

# Se necessário, fazer pull novamente
git pull origin main
```

### **Problema 2: Rota não configurada**
Se `php artisan route:list | grep evergame` não retornar nada:

**Adicionar em `routes/api.php`:**
```php
Route::post('/evergame/webhook', [EvergameController::class, 'webhook']);
```

**Criar `app/Http/Controllers/EvergameController.php`:**
```php
<?php
namespace App\Http\Controllers;
use App\Traits\Providers\EvergameTrait;
use Illuminate\Http\Request;

class EvergameController extends Controller
{
    use EvergameTrait;

    public function webhook(Request $request)
    {
        return self::WebhooksEvergame($request);
    }
}
```

### **Problema 3: Usuário sem wallet**
Se o debug mostrar que o usuário não tem wallet:

```sql
-- Conectar no MySQL
mysql -u root -p cassino

-- Verificar usuário
SELECT * FROM users WHERE id = 38;

-- Verificar wallet
SELECT * FROM wallets WHERE user_id = 38;

-- Criar wallet se não existir
INSERT INTO wallets (user_id, balance, balance_bonus, balance_withdrawal, currency, active, created_at, updated_at)
VALUES (38, 140.74, 0.00, 0.00, 'BRL', 1, NOW(), NOW());
```

### **Problema 4: Cache do Laravel**
```bash
# Limpar todos os caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
php artisan optimize:clear

# Recriar cache
php artisan config:cache
php artisan route:cache
```

## 📤 ENVIE OS RESULTADOS

Após executar os scripts, envie:

1. **Resultado do `debug_webhook.php`**
2. **Resultado do `check_webhook_route.php`**
3. **Resultado do `php artisan route:list | grep evergame`**
4. **Primeiras 20 linhas do trait atual**

## 🎯 DIAGNÓSTICO RÁPIDO

Execute este comando para diagnóstico rápido:

```bash
echo "=== DIAGNÓSTICO RÁPIDO ===" && \
echo "1. Usuário 38:" && \
mysql -u root -p cassino -e "SELECT id, name, status FROM users WHERE id = 38;" && \
echo "2. Wallet 38:" && \
mysql -u root -p cassino -e "SELECT user_id, balance, balance_withdrawal, active FROM wallets WHERE user_id = 38;" && \
echo "3. Trait existe:" && \
ls -la app/Traits/Providers/EvergameTrait.php && \
echo "4. Rotas evergame:" && \
php artisan route:list | grep -i evergame
```

---

**🚨 IMPORTANTE:** Execute estes comandos no **servidor do cassino**, não no servidor da API!

O problema está no cassino retornando `INVALID_USER`, então precisamos debugar lá.
