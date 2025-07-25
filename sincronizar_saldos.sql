-- =====================================================
-- SCRIPT PARA SINCRONIZAR SALDOS
-- ATENÇÃO: Execute com cuidado após verificar os dados
-- =====================================================

-- =====================================================
-- PARTE 1: EXECUTE NO BANCO DO CASSINO
-- Para obter os dados que serão sincronizados
-- =====================================================

-- Consulta para obter dados do cassino (COPIE O RESULTADO)
SELECT 
    'DADOS PARA SINCRONIZAÇÃO (CASSINO → API):' as info;

SELECT 
    CONCAT(
        'UPDATE users SET ',
        'saldo = ', balance, ', ',
        'balance_bonus = ', balance_bonus, ', ',
        'balance_withdrawal = ', balance_withdrawal, ', ',
        'updated_at = NOW() ',
        'WHERE id = ', user_id, ';'
    ) as sql_update
FROM wallets 
WHERE active = 1 
  AND (balance > 0 OR balance_bonus > 0 OR balance_withdrawal > 0)
ORDER BY user_id;

-- =====================================================
-- PARTE 2: EXECUTE NO BANCO DA API
-- Após copiar os comandos UPDATE da consulta acima
-- =====================================================

-- EXEMPLO DE COMO FICARÁ (substitua pelos valores reais):
-- UPDATE users SET saldo = 281.48, balance_bonus = 0.00, balance_withdrawal = 0.00, updated_at = NOW() WHERE id = 1;
-- UPDATE users SET saldo = 150.00, balance_bonus = 50.00, balance_withdrawal = 0.00, updated_at = NOW() WHERE id = 2;

-- =====================================================
-- ALTERNATIVA: SCRIPT MANUAL PARA USUÁRIO ESPECÍFICO
-- Execute no banco da API após verificar os valores
-- =====================================================

-- Para o usuário com saldo R$ 281,48 (substitua os valores corretos):
-- UPDATE users 
-- SET 
--     saldo = 281.48,
--     balance_bonus = 0.00,
--     balance_withdrawal = 0.00,
--     updated_at = NOW()
-- WHERE id = 1; -- Substitua pelo ID correto

-- =====================================================
-- VERIFICAÇÃO APÓS SINCRONIZAÇÃO
-- Execute no banco da API para confirmar
-- =====================================================

-- Verificar se a sincronização funcionou
SELECT 
    'VERIFICAÇÃO PÓS-SINCRONIZAÇÃO:' as info;

SELECT 
    id,
    username,
    saldo,
    balance_bonus,
    balance_withdrawal,
    (saldo + balance_bonus + balance_withdrawal) as total_saldo,
    updated_at
FROM users 
WHERE id IN (1, 2, 3, 4, 5) -- IDs dos usuários sincronizados
ORDER BY id;

-- =====================================================
-- BACKUP ANTES DA SINCRONIZAÇÃO (RECOMENDADO)
-- Execute no banco da API ANTES de fazer as alterações
-- =====================================================

-- Criar backup da tabela users
-- CREATE TABLE users_backup_$(date +%Y%m%d) AS SELECT * FROM users;

-- =====================================================
-- INSTRUÇÕES DE USO:
-- =====================================================

/*
1. Execute o script verificar_saldo_cassino.sql no banco do cassino
2. Execute o script verificar_saldo_api.sql no banco da API
3. Compare os resultados para identificar discrepâncias
4. Execute a PARTE 1 deste script no banco do cassino
5. Copie os comandos UPDATE gerados
6. Execute os comandos UPDATE no banco da API
7. Execute a verificação pós-sincronização
*/
