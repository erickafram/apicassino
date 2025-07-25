-- =====================================================
-- ATUALIZAÇÃO SEGURA DO BANCO DE DADOS
-- Adiciona apenas campos que não existem
-- =====================================================

USE apipg;

-- Verificar se a tabela users existe, se não, criar
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `token` varchar(255) NOT NULL DEFAULT '',
  `atk` varchar(255) NOT NULL,
  `saldo` decimal(20,2) NOT NULL DEFAULT 0.00,
  `valorapostado` decimal(20,2) NOT NULL DEFAULT 0.00,
  `valordebitado` decimal(20,2) NOT NULL DEFAULT 0.00,
  `valorganho` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_bonus` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_bonus_rollover` decimal(10,2) DEFAULT 0.00,
  `balance_deposit_rollover` decimal(10,2) DEFAULT 0.00,
  `currency` varchar(20) NOT NULL DEFAULT 'BRL',
  `symbol` varchar(5) NOT NULL DEFAULT 'R$',
  `balance_type` enum('balance','balance_bonus','balance_withdrawal') DEFAULT 'balance',
  `total_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `total_won` decimal(20,2) NOT NULL DEFAULT 0.00,
  `total_lose` decimal(20,2) NOT NULL DEFAULT 0.00,
  `rtp` decimal(5,2) NOT NULL DEFAULT 0.00,
  `isinfluencer` tinyint(1) NOT NULL DEFAULT 0,
  `agentid` int(11) NOT NULL,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_agent` (`username`, `agentid`),
  UNIQUE KEY `atk` (`atk`),
  KEY `idx_username` (`username`),
  KEY `idx_token` (`token`),
  KEY `idx_atk` (`atk`),
  KEY `idx_agent_id` (`agentid`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Adicionar campos que podem estar faltando na tabela users
ALTER TABLE `users` 
ADD COLUMN IF NOT EXISTS `balance_bonus` decimal(20,2) NOT NULL DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `balance_bonus_rollover` decimal(10,2) DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `balance_deposit_rollover` decimal(10,2) DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `currency` varchar(20) NOT NULL DEFAULT 'BRL',
ADD COLUMN IF NOT EXISTS `symbol` varchar(5) NOT NULL DEFAULT 'R$',
ADD COLUMN IF NOT EXISTS `balance_type` enum('balance','balance_bonus','balance_withdrawal') DEFAULT 'balance',
ADD COLUMN IF NOT EXISTS `total_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `total_won` decimal(20,2) NOT NULL DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `total_lose` decimal(20,2) NOT NULL DEFAULT 0.00,
ADD COLUMN IF NOT EXISTS `status` enum('active','inactive','suspended') DEFAULT 'active',
ADD COLUMN IF NOT EXISTS `last_login` timestamp NULL DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
ADD COLUMN IF NOT EXISTS `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp();

-- Modificar tipo de dados se necessário
ALTER TABLE `users` 
MODIFY COLUMN `saldo` decimal(20,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN `valorapostado` decimal(20,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN `valordebitado` decimal(20,2) NOT NULL DEFAULT 0.00,
MODIFY COLUMN `valorganho` decimal(20,2) NOT NULL DEFAULT 0.00;

-- Criar tabela transactions se não existir
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `game_code` varchar(100) DEFAULT NULL,
  `game_name` varchar(255) DEFAULT NULL,
  `provider_code` varchar(100) DEFAULT NULL,
  `type` enum('bet','win','refund','bonus') NOT NULL,
  `type_money` enum('balance','balance_bonus','balance_withdrawal') DEFAULT 'balance',
  `amount` decimal(20,2) NOT NULL,
  `balance_before` decimal(20,2) NOT NULL,
  `balance_after` decimal(20,2) NOT NULL,
  `balance_bet` decimal(20,2) DEFAULT 0.00,
  `balance_win` decimal(20,2) DEFAULT 0.00,
  `currency` varchar(20) DEFAULT 'BRL',
  `symbol` varchar(5) DEFAULT 'R$',
  `status` enum('pending','completed','failed','cancelled') DEFAULT 'completed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_type` (`type`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserir usuário de teste se não existir
INSERT IGNORE INTO `users` (`id`, `username`, `token`, `atk`, `saldo`, `agentid`, `currency`, `symbol`, `status`) VALUES
(1, 'testuser', 'test_user_token_123456', 'test_atk_token_123456', 1000.00, 1, 'BRL', 'R$', 'active');

-- Criar tabelas JSON dos jogos se não existirem
CREATE TABLE IF NOT EXISTS `fortunetigerplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Inserir dados iniciais se não existirem
INSERT IGNORE INTO `fortunetigerplayerjson` (`id`, `json`) VALUES
(1, '{"dt":{"si":{"wc":31,"ist":false,"itw":true,"fws":0,"wp":null,"orl":[5,7,6,5,6,3,3,7,6],"lw":null,"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"0","psid":"0","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0,"blab":0,"bl":0,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}');

COMMIT;