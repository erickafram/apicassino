-- =====================================================
-- SCRIPT PARA VERIFICAR SALDOS NO BANCO DO CASSINO
-- Execute este script no banco de dados do cassino
-- =====================================================

-- 1. Verificar estrutura da tabela wallets
SELECT 'ESTRUTURA DA TABELA WALLETS:' as info;
DESCRIBE wallets;

-- 2. Verificar todos os usuários com saldo
SELECT 
    '=== USUÁRIOS COM SALDO NO CASSINO ===' as info,
    '' as user_id,
    '' as balance,
    '' as balance_bonus,
    '' as balance_withdrawal,
    '' as total_balance,
    '' as active
UNION ALL
SELECT 
    'Dados:' as info,
    CAST(user_id as CHAR) as user_id,
    CAST(balance as CHAR) as balance,
    CAST(balance_bonus as CHAR) as balance_bonus, 
    CAST(balance_withdrawal as CHAR) as balance_withdrawal,
    CAST((balance + balance_bonus + balance_withdrawal) as CHAR) as total_balance,
    CAST(active as CHAR) as active
FROM wallets 
WHERE active = 1 
  AND (balance > 0 OR balance_bonus > 0 OR balance_withdrawal > 0)
ORDER BY user_id;

-- 3. Verificar usuário específico (substitua 1 pelo ID do usuário)
SELECT 
    '=== USUÁRIO ESPECÍFICO (ID = 1) ===' as info,
    '' as campo,
    '' as valor
UNION ALL
SELECT 
    'Campo' as info,
    'user_id' as campo,
    CAST(user_id as CHAR) as valor
FROM wallets WHERE user_id = 1 AND active = 1
UNION ALL
SELECT 
    '' as info,
    'balance' as campo,
    CAST(balance as CHAR) as valor
FROM wallets WHERE user_id = 1 AND active = 1
UNION ALL
SELECT 
    '' as info,
    'balance_bonus' as campo,
    CAST(balance_bonus as CHAR) as valor
FROM wallets WHERE user_id = 1 AND active = 1
UNION ALL
SELECT 
    '' as info,
    'balance_withdrawal' as campo,
    CAST(balance_withdrawal as CHAR) as valor
FROM wallets WHERE user_id = 1 AND active = 1
UNION ALL
SELECT 
    '' as info,
    'total_balance' as campo,
    CAST((balance + balance_bonus + balance_withdrawal) as CHAR) as valor
FROM wallets WHERE user_id = 1 AND active = 1
UNION ALL
SELECT 
    '' as info,
    'active' as campo,
    CAST(active as CHAR) as valor
FROM wallets WHERE user_id = 1 AND active = 1;

-- 4. Resumo geral
SELECT 
    '=== RESUMO GERAL CASSINO ===' as info,
    '' as metrica,
    '' as valor
UNION ALL
SELECT 
    'Métrica' as info,
    'Total de wallets ativas' as metrica,
    CAST(COUNT(*) as CHAR) as valor
FROM wallets WHERE active = 1
UNION ALL
SELECT 
    '' as info,
    'Wallets com saldo > 0' as metrica,
    CAST(COUNT(*) as CHAR) as valor
FROM wallets 
WHERE active = 1 
  AND (balance > 0 OR balance_bonus > 0 OR balance_withdrawal > 0)
UNION ALL
SELECT 
    '' as info,
    'Soma total de saldos' as metrica,
    CAST(SUM(balance + balance_bonus + balance_withdrawal) as CHAR) as valor
FROM wallets WHERE active = 1;

-- 5. Verificar se existe campo total_balance (accessor)
SELECT 
    '=== VERIFICAÇÃO CAMPO TOTAL_BALANCE ===' as info;

-- Como total_balance pode ser um accessor no Laravel, vamos calcular manualmente
SELECT 
    user_id,
    balance,
    balance_bonus,
    balance_withdrawal,
    (balance + balance_bonus + balance_withdrawal) as total_balance_calculado,
    active,
    created_at,
    updated_at
FROM wallets 
WHERE active = 1 
  AND user_id IN (1, 2, 3, 4, 5) -- Primeiros 5 usuários
ORDER BY user_id;
