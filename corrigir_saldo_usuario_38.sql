-- =====================================================
-- CORREÇÃO ESPECÍFICA PARA O USUÁRIO COM SALDO R$ 281,48
-- Execute no banco da API
-- =====================================================

-- 1. VERIFICAR SITUAÇÃO ATUAL
SELECT 'SITUAÇÃO ATUAL NA API:' as info;

SELECT 
    id,
    username,
    saldo,
    balance_bonus,
    balance_withdrawal,
    (saldo + balance_bonus + balance_withdrawal) as total_saldo,
    valorapostado,
    valorganho,
    total_bet,
    total_won
FROM users 
WHERE username = '38' OR saldo = 281.48;

-- 2. CORRIGIR OS CAMPOS INCONSISTENTES
-- Execute apenas se confirmar que é o usuário correto

-- Opção A: Sincronizar total_bet e total_won com valorapostado e valorganho
UPDATE users 
SET 
    total_bet = valorapostado,
    total_won = valorganho,
    total_lose = GREATEST(0, valorapostado - valorganho),
    updated_at = NOW()
WHERE username = '38';

-- Opção B: Zerar campos inconsistentes (se preferir começar do zero)
-- UPDATE users 
-- SET 
--     valorapostado = total_bet,
--     valorganho = total_won,
--     valordebitado = 0.00,
--     updated_at = NOW()
-- WHERE username = '38';

-- 3. VERIFICAR APÓS CORREÇÃO
SELECT 'SITUAÇÃO APÓS CORREÇÃO:' as info;

SELECT 
    id,
    username,
    saldo,
    balance_bonus,
    balance_withdrawal,
    (saldo + balance_bonus + balance_withdrawal) as total_saldo,
    valorapostado,
    valorganho,
    total_bet,
    total_won,
    total_lose,
    CASE 
        WHEN valorapostado = total_bet AND valorganho = total_won THEN 'CONSISTENTE'
        ELSE 'INCONSISTENTE'
    END as status_consistencia
FROM users 
WHERE username = '38';

-- =====================================================
-- VERIFICAÇÃO FINAL - COMPARAR COM CASSINO
-- =====================================================

-- Execute esta consulta para confirmar que está tudo certo:
SELECT 
    'RESUMO FINAL:' as info,
    '' as campo,
    '' as valor_api,
    '' as valor_cassino,
    '' as status
UNION ALL
SELECT 
    'Comparação' as info,
    'Saldo Principal' as campo,
    CAST((SELECT saldo FROM users WHERE username = '38') as CHAR) as valor_api,
    '281.48' as valor_cassino,
    CASE 
        WHEN (SELECT saldo FROM users WHERE username = '38') = 281.48 THEN '✅ OK'
        ELSE '❌ DIFERENTE'
    END as status
UNION ALL
SELECT 
    '' as info,
    'Total Apostado' as campo,
    CAST((SELECT total_bet FROM users WHERE username = '38') as CHAR) as valor_api,
    'N/A' as valor_cassino,
    '📊 Verificar' as status
UNION ALL
SELECT 
    '' as info,
    'Total Ganho' as campo,
    CAST((SELECT total_won FROM users WHERE username = '38') as CHAR) as valor_api,
    'N/A' as valor_cassino,
    '📊 Verificar' as status;

-- =====================================================
-- INSTRUÇÕES:
-- =====================================================

/*
1. Execute a seção 1 para verificar a situação atual
2. Escolha entre Opção A ou B na seção 2
3. Execute a seção 3 para verificar se ficou correto
4. Execute a verificação final

RECOMENDAÇÃO:
- Use a Opção A se quiser manter o histórico de apostas
- Use a Opção B se quiser zerar e começar do zero
*/
