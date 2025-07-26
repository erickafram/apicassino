# 🔧 CORREÇÃO DO ERRO "INVALID_USER"

## 📋 Problema Identificado

O erro `INVALID_USER` está ocorrendo porque:

1. **Usuário ID 38 existe na API** (`apipg` database) com saldo R$ 280,98
2. **Usuário ID 38 NÃO existe no Cassino** (`cassino` database)
3. **O EvergameTrait.php** está tentando encontrar o usuário na tabela `wallets` do cassino
4. **Estruturas de banco diferentes** entre API e Cassino

## 🛠️ Solução Implementada

### 1. **EvergameTrait.php Atualizado**

O arquivo `cassino/EvergameTrait.php` foi modificado para:

- ✅ **Conectar aos dois bancos** (API e Cassino)
- ✅ **Sincronizar usuários automaticamente** quando não encontrados
- ✅ **Manter saldos sincronizados** entre os sistemas
- ✅ **Criar wallets automaticamente** quando necessário

### 2. **Novos Métodos Adicionados**

```php
// Sincronizar usuário entre bancos
syncUserBetweenDatabases($userId)

// Atualizar saldo na API após transação
updateApiBalance($userId, $newBalance, $balanceType)

// Obter conexões específicas
getApiConnection()
getCassinoConnection()
```

## 📝 PASSOS PARA IMPLEMENTAR

### **Passo 1: Configurar Conexões de Banco**

1. **Adicione ao seu `.env`:**
```env
# Configurações do banco da API
API_DB_HOST=127.0.0.1
API_DB_PORT=3306
API_DB_DATABASE=apipg
API_DB_USERNAME=root
API_DB_PASSWORD=

# Configurações do banco do Cassino (já existentes)
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=cassino
DB_USERNAME=root
DB_PASSWORD=
```

2. **Adicione ao `config/database.php` na seção `connections`:**
```php
'mysql_api' => [
    'driver' => 'mysql',
    'host' => env('API_DB_HOST', '127.0.0.1'),
    'port' => env('API_DB_PORT', '3306'),
    'database' => env('API_DB_DATABASE', 'apipg'),
    'username' => env('API_DB_USERNAME', 'root'),
    'password' => env('API_DB_PASSWORD', ''),
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'prefix' => '',
    'strict' => true,
    'engine' => null,
],
```

### **Passo 2: Substituir o EvergameTrait.php**

1. **Faça backup do arquivo atual:**
```bash
cp cassino/EvergameTrait.php cassino/EvergameTrait.php.backup
```

2. **O arquivo já foi atualizado** com as correções necessárias

### **Passo 3: Testar a Sincronização**

1. **Execute o script de teste:**
```bash
cd cassino
php test_sync_user.php
```

2. **Verifique se o usuário 38 foi sincronizado corretamente**

### **Passo 4: Testar o Jogo**

1. **Faça uma nova tentativa de jogo com o usuário 38**
2. **Verifique os logs para confirmar que não há mais erro `INVALID_USER`**

## 🔍 COMO FUNCIONA AGORA

### **Fluxo de Transação Corrigido:**

1. **API recebe callback** do jogo com `user_id: 38`
2. **EvergameTrait verifica** se usuário existe no cassino
3. **Se não existir:**
   - Busca usuário na API (`apipg.users`)
   - Cria usuário no cassino (`cassino.users`)
   - Cria wallet no cassino (`cassino.wallets`)
   - Sincroniza saldo da API para o cassino
4. **Processa a transação** normalmente
5. **Atualiza saldo** no cassino
6. **Sincroniza saldo de volta** para a API

### **Sincronização Bidirecional:**

- **API → Cassino:** Saldo inicial e dados do usuário
- **Cassino → API:** Saldo atualizado após cada transação

## 🚨 PONTOS IMPORTANTES

### **1. Configurações de Produção**

Se estiver em produção, ajuste as configurações conforme seu ambiente:
- Host dos bancos (podem ser diferentes)
- Usuários e senhas específicos
- Nomes dos bancos de dados

### **2. Permissões de Banco**

Certifique-se de que o usuário do banco tem permissões para:
- `SELECT` nas duas bases
- `INSERT` e `UPDATE` na base do cassino
- `UPDATE` na base da API

### **3. Logs de Debug**

Os logs agora mostrarão:
```
[INFO] Usuário ID 38 criado no cassino
[INFO] Wallet criado para usuário ID 38 com saldo 280.98
[INFO] Saldo sincronizado para usuário ID 38: 280.98
[INFO] Saldo atualizado na API para usuário 38: saldo = 280.48
```

## ✅ VERIFICAÇÃO FINAL

Após implementar, verifique:

1. **Usuário 38 existe em ambos os bancos**
2. **Wallet do usuário 38 existe no cassino**
3. **Saldos estão sincronizados**
4. **Transações funcionam sem erro `INVALID_USER`**
5. **Logs mostram sincronização funcionando**

## 🆘 TROUBLESHOOTING

### **Se ainda der erro:**

1. **Verifique conexões de banco:**
```bash
php artisan tinker
DB::connection('mysql_api')->getPdo();
DB::connection('mysql')->getPdo();
```

2. **Verifique se as tabelas existem:**
```sql
-- No banco apipg
SELECT * FROM users WHERE id = 38;

-- No banco cassino  
SELECT * FROM users WHERE id = 38;
SELECT * FROM wallets WHERE user_id = 38;
```

3. **Execute o script de teste novamente**

---

**🎯 Com essas correções, o erro `INVALID_USER` deve ser resolvido e o sistema funcionará corretamente!**
