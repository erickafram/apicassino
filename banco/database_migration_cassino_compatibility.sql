-- =====================================================
-- MIGRAÇÃO PARA COMPATIBILIDADE COM CASSINO
-- =====================================================
-- Este arquivo contém as alterações necessárias para tornar
-- a API compatível com o sistema de saldo do cassino
-- =====================================================

-- Backup das tabelas antes da migração
CREATE TABLE `users_backup` AS SELECT * FROM `users`;
CREATE TABLE `transactions_backup` AS SELECT * FROM `transactions`;

-- =====================================================
-- ALTERAÇÕES NA TABELA USERS
-- =====================================================

-- Aumentar precisão dos campos decimais
ALTER TABLE `users` 
MODIFY COLUMN `saldo` decimal(20,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN `valorapostado` decimal(20,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN `valordebitado` decimal(20,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN `valorganho` decimal(20,2) NOT NULL DEFAULT 0.00;

-- Adicionar novos campos para compatibilidade com cassino
ALTER TABLE `users` 
ADD COLUMN `balance_bonus` decimal(20,2) NOT NULL DEFAULT 0.00 AFTER `valorganho`,
ADD COLUMN `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT 0.00 AFTER `balance_bonus`,
ADD COLUMN `balance_bonus_rollover` decimal(10,2) DEFAULT 0.00 AFTER `balance_withdrawal`,
ADD COLUMN `balance_deposit_rollover` decimal(10,2) DEFAULT 0.00 AFTER `balance_bonus_rollover`,
ADD COLUMN `currency` varchar(20) NOT NULL DEFAULT 'BRL' AFTER `balance_deposit_rollover`,
ADD COLUMN `symbol` varchar(5) NOT NULL DEFAULT 'R$' AFTER `currency`,
ADD COLUMN `balance_type` enum('balance','balance_bonus','balance_withdrawal') DEFAULT 'balance' AFTER `symbol`,
ADD COLUMN `total_bet` decimal(20,2) NOT NULL DEFAULT 0.00 AFTER `balance_type`,
ADD COLUMN `total_won` decimal(20,2) NOT NULL DEFAULT 0.00 AFTER `total_bet`,
ADD COLUMN `total_lose` decimal(20,2) NOT NULL DEFAULT 0.00 AFTER `total_won`;

-- Adicionar índices para os novos campos
ALTER TABLE `users` 
ADD KEY `idx_currency` (`currency`),
ADD KEY `idx_balance_type` (`balance_type`);

-- =====================================================
-- ALTERAÇÕES NA TABELA TRANSACTIONS
-- =====================================================

-- Aumentar precisão dos campos decimais
ALTER TABLE `transactions` 
MODIFY COLUMN `amount` decimal(20,2) NOT NULL,
MODIFY COLUMN `balance_before` decimal(20,2) NOT NULL,
MODIFY COLUMN `balance_after` decimal(20,2) NOT NULL;

-- Adicionar novos campos para compatibilidade com cassino
ALTER TABLE `transactions` 
ADD COLUMN `balance_type` enum('balance','balance_bonus','balance_withdrawal') DEFAULT 'balance' AFTER `balance_after`,
ADD COLUMN `currency` varchar(20) NOT NULL DEFAULT 'BRL' AFTER `balance_type`,
ADD COLUMN `bet_amount` decimal(20,2) DEFAULT 0.00 AFTER `currency`,
ADD COLUMN `win_amount` decimal(20,2) DEFAULT 0.00 AFTER `bet_amount`,
ADD COLUMN `provider` varchar(50) DEFAULT 'PGSOFT' AFTER `win_amount`,
ADD COLUMN `aggregator` varchar(50) DEFAULT 'pgapi' AFTER `provider`,
ADD COLUMN `transaction_id` varchar(255) DEFAULT NULL AFTER `aggregator`,
ADD COLUMN `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp() AFTER `created_at`;

-- Adicionar índices para os novos campos
ALTER TABLE `transactions` 
ADD KEY `idx_balance_type` (`balance_type`),
ADD KEY `idx_currency` (`currency`),
ADD KEY `idx_provider` (`provider`),
ADD KEY `idx_transaction_id` (`transaction_id`);

-- =====================================================
-- CRIAR TABELA GGR_GAMES (COMPATIBILIDADE COM CASSINO)
-- =====================================================

CREATE TABLE `ggr_games` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `provider` varchar(191) NOT NULL,
  `game` varchar(191) NOT NULL,
  `balance_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_win` decimal(20,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(50) DEFAULT NULL,
  `aggregator` varchar(255) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_provider` (`provider`),
  KEY `idx_game` (`game`),
  KEY `idx_type` (`type`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- CRIAR TABELA ORDERS (COMPATIBILIDADE COM CASSINO)
-- =====================================================

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int(10) UNSIGNED NOT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `type` varchar(50) NOT NULL,
  `type_money` varchar(50) DEFAULT 'balance',
  `amount` decimal(20,2) NOT NULL,
  `providers` varchar(100) DEFAULT NULL,
  `game` varchar(100) DEFAULT NULL,
  `game_uuid` varchar(255) DEFAULT NULL,
  `round_id` int(11) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_type` (`type`),
  KEY `idx_providers` (`providers`),
  KEY `idx_game` (`game`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- ATUALIZAR DADOS EXISTENTES
-- =====================================================

-- Migrar saldo principal para balance_withdrawal (usado pelo cassino)
UPDATE `users` SET `balance_withdrawal` = `saldo` WHERE `saldo` > 0;

-- Atualizar totais baseados em transações existentes
UPDATE `users` u SET 
  `total_bet` = (
    SELECT COALESCE(SUM(amount), 0) 
    FROM `transactions` t 
    WHERE t.user_id = u.id AND t.type = 'bet'
  ),
  `total_won` = (
    SELECT COALESCE(SUM(amount), 0) 
    FROM `transactions` t 
    WHERE t.user_id = u.id AND t.type = 'win'
  );

-- Calcular total_lose
UPDATE `users` SET `total_lose` = `total_bet` - `total_won` WHERE `total_bet` >= `total_won`;

-- Atualizar transações existentes com novos campos
UPDATE `transactions` t 
JOIN `users` u ON t.user_id = u.id 
SET 
  t.currency = u.currency,
  t.balance_type = u.balance_type,
  t.bet_amount = CASE WHEN t.type = 'bet' THEN t.amount ELSE 0 END,
  t.win_amount = CASE WHEN t.type = 'win' THEN t.amount ELSE 0 END,
  t.transaction_id = CONCAT('TXN_', t.id, '_', UNIX_TIMESTAMP(t.created_at));

-- =====================================================
-- VERIFICAÇÕES PÓS-MIGRAÇÃO
-- =====================================================

-- Verificar se todos os usuários têm currency definida
SELECT COUNT(*) as users_without_currency FROM `users` WHERE `currency` IS NULL OR `currency` = '';

-- Verificar se todas as transações têm transaction_id
SELECT COUNT(*) as transactions_without_id FROM `transactions` WHERE `transaction_id` IS NULL OR `transaction_id` = '';

-- Verificar totais de saldo
SELECT 
  COUNT(*) as total_users,
  SUM(saldo) as total_saldo,
  SUM(balance_withdrawal) as total_balance_withdrawal,
  SUM(total_bet) as total_apostado,
  SUM(total_won) as total_ganho
FROM `users`;

-- =====================================================
-- COMENTÁRIOS FINAIS
-- =====================================================

-- Esta migração adiciona compatibilidade com o sistema do cassino
-- mantendo a compatibilidade com o sistema existente da API.
-- 
-- Principais mudanças:
-- 1. Campos de saldo compatíveis com cassino (balance_bonus, balance_withdrawal, etc.)
-- 2. Campos de moeda e tipo de saldo
-- 3. Tabelas GGR e Orders para compatibilidade
-- 4. Campos de transação expandidos
-- 5. Índices otimizados para performance
--
-- Após executar esta migração, será necessário:
-- 1. Atualizar o código da API para usar os novos campos
-- 2. Atualizar os webhooks para enviar dados compatíveis
-- 3. Testar a integração com o cassino
