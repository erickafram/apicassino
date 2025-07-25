-- =====================================================
-- SCRIPT PARA VERIFICAR SALDOS NO BANCO DA API
-- Execute este script no banco de dados da API
-- =====================================================

-- 1. Verificar estrutura da tabela users
SELECT 'ESTRUTURA DA TABELA USERS:' as info;
DESCRIBE users;

-- 2. Verificar todos os usuários com saldo
SELECT 
    '=== USUÁRIOS COM SALDO NA API ===' as info,
    '' as id,
    '' as username,
    '' as saldo,
    '' as balance_bonus,
    '' as balance_withdrawal,
    '' as total_calculado
UNION ALL
SELECT 
    'Dados:' as info,
    CAST(id as CHAR) as id,
    username,
    CAST(COALESCE(saldo, 0) as CHAR) as saldo,
    CAST(COALESCE(balance_bonus, 0) as CHAR) as balance_bonus,
    CAST(COALESCE(balance_withdrawal, 0) as CHAR) as balance_withdrawal,
    CAST((COALESCE(saldo, 0) + COALESCE(balance_bonus, 0) + COALESCE(balance_withdrawal, 0)) as CHAR) as total_calculado
FROM users 
WHERE status = 'active'
  AND (COALESCE(saldo, 0) > 0 OR COALESCE(balance_bonus, 0) > 0 OR COALESCE(balance_withdrawal, 0) > 0)
ORDER BY id;

-- 3. Verificar usuário específico (substitua 1 pelo ID do usuário)
SELECT 
    '=== USUÁRIO ESPECÍFICO (ID = 1) ===' as info,
    '' as campo,
    '' as valor
UNION ALL
SELECT 
    'Campo' as info,
    'id' as campo,
    CAST(id as CHAR) as valor
FROM users WHERE id = 1
UNION ALL
SELECT 
    '' as info,
    'username' as campo,
    username as valor
FROM users WHERE id = 1
UNION ALL
SELECT 
    '' as info,
    'saldo' as campo,
    CAST(COALESCE(saldo, 0) as CHAR) as valor
FROM users WHERE id = 1
UNION ALL
SELECT 
    '' as info,
    'balance_bonus' as campo,
    CAST(COALESCE(balance_bonus, 0) as CHAR) as valor
FROM users WHERE id = 1
UNION ALL
SELECT 
    '' as info,
    'balance_withdrawal' as campo,
    CAST(COALESCE(balance_withdrawal, 0) as CHAR) as valor
FROM users WHERE id = 1
UNION ALL
SELECT 
    '' as info,
    'total_calculado' as campo,
    CAST((COALESCE(saldo, 0) + COALESCE(balance_bonus, 0) + COALESCE(balance_withdrawal, 0)) as CHAR) as valor
FROM users WHERE id = 1
UNION ALL
SELECT 
    '' as info,
    'status' as campo,
    status as valor
FROM users WHERE id = 1;

-- 4. Resumo geral
SELECT 
    '=== RESUMO GERAL API ===' as info,
    '' as metrica,
    '' as valor
UNION ALL
SELECT 
    'Métrica' as info,
    'Total de usuários ativos' as metrica,
    CAST(COUNT(*) as CHAR) as valor
FROM users WHERE status = 'active'
UNION ALL
SELECT 
    '' as info,
    'Usuários com saldo > 0' as metrica,
    CAST(COUNT(*) as CHAR) as valor
FROM users 
WHERE status = 'active'
  AND (COALESCE(saldo, 0) > 0 OR COALESCE(balance_bonus, 0) > 0 OR COALESCE(balance_withdrawal, 0) > 0)
UNION ALL
SELECT 
    '' as info,
    'Soma total de saldos' as metrica,
    CAST(SUM(COALESCE(saldo, 0) + COALESCE(balance_bonus, 0) + COALESCE(balance_withdrawal, 0)) as CHAR) as valor
FROM users WHERE status = 'active';

-- 5. Verificar campos disponíveis relacionados a saldo
SELECT 
    '=== CAMPOS DE SALDO DISPONÍVEIS ===' as info;

SELECT 
    id,
    username,
    COALESCE(saldo, 0) as saldo,
    COALESCE(balance_bonus, 0) as balance_bonus,
    COALESCE(balance_withdrawal, 0) as balance_withdrawal,
    COALESCE(valorapostado, 0) as valorapostado,
    COALESCE(valorganho, 0) as valorganho,
    COALESCE(total_bet, 0) as total_bet,
    COALESCE(total_won, 0) as total_won,
    COALESCE(total_lose, 0) as total_lose,
    status,
    agentid,
    created_at,
    updated_at
FROM users 
WHERE id IN (1, 2, 3, 4, 5) -- Primeiros 5 usuários
ORDER BY id;

-- 6. Verificar se há discrepâncias nos campos de saldo
SELECT 
    '=== VERIFICAÇÃO DE CONSISTÊNCIA ===' as info;

SELECT 
    id,
    username,
    saldo,
    valorapostado,
    valorganho,
    total_bet,
    total_won,
    CASE 
        WHEN COALESCE(valorapostado, 0) != COALESCE(total_bet, 0) THEN 'INCONSISTENTE'
        WHEN COALESCE(valorganho, 0) != COALESCE(total_won, 0) THEN 'INCONSISTENTE'
        ELSE 'OK'
    END as status_consistencia
FROM users 
WHERE status = 'active'
  AND (
    COALESCE(valorapostado, 0) != COALESCE(total_bet, 0) OR
    COALESCE(valorganho, 0) != COALESCE(total_won, 0)
  )
LIMIT 10;
