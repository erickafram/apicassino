-- =====================================================
-- SCRIPT DE CORREÇÃO DO BANCO DE DADOS
-- Corrige problemas de tabelas ausentes
-- =====================================================

-- Criar banco se não existir
CREATE DATABASE IF NOT EXISTS `apipg` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `apipg`;

-- --------------------------------------------------------
-- Tabela de Agentes
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agentCode` varchar(50) DEFAULT NULL,
  `saldo` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_bonus` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_demo` decimal(20,2) NOT NULL DEFAULT 0.00,
  `agentToken` varchar(255) NOT NULL,
  `secretKey` varchar(255) NOT NULL,
  `probganho` varchar(50) DEFAULT '0',
  `probbonus` varchar(10) DEFAULT '0',
  `probganhortp` varchar(10) DEFAULT '0',
  `probganhoinfluencer` varchar(10) DEFAULT '0',
  `probbonusinfluencer` varchar(10) DEFAULT '0',
  `probganhoaposta` varchar(10) DEFAULT '0',
  `probganhosaldo` varchar(10) DEFAULT '0',
  `callbackurl` varchar(500) DEFAULT NULL,
  `currency` varchar(10) DEFAULT 'BRL',
  `symbol` varchar(10) DEFAULT 'R$',
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `agentCode` (`agentCode`),
  UNIQUE KEY `agentToken` (`agentToken`),
  UNIQUE KEY `secretKey` (`secretKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Usuários
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `token` varchar(255) NOT NULL DEFAULT '',
  `atk` varchar(255) NOT NULL,
  `saldo` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_bonus` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_demo` decimal(20,2) NOT NULL DEFAULT 0.00,
  `currency` varchar(10) DEFAULT 'BRL',
  `symbol` varchar(10) DEFAULT 'R$',
  `rtp` decimal(5,2) DEFAULT 94.00,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_token` (`token`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Transações
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `round_id` varchar(255) NOT NULL,
  `type` enum('bet','win','refund','bonus') NOT NULL,
  `amount` decimal(20,2) NOT NULL,
  `balance_before` decimal(20,2) NOT NULL,
  `balance_after` decimal(20,2) NOT NULL,
  `balance_type` enum('balance','balance_bonus','balance_withdrawal','balance_demo') DEFAULT 'balance',
  `currency` varchar(10) DEFAULT 'BRL',
  `symbol` varchar(10) DEFAULT 'R$',
  `rollover_before` decimal(20,2) DEFAULT 0.00,
  `rollover_after` decimal(20,2) DEFAULT 0.00,
  `transaction_id` varchar(255) NOT NULL,
  `provider` varchar(100) DEFAULT 'pgsoft',
  `status` enum('pending','completed','failed','cancelled') DEFAULT 'completed',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_agent_id` (`agent_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_round_id` (`round_id`),
  KEY `idx_type` (`type`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Jogos
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_code` varchar(100) NOT NULL,
  `game_name` varchar(255) NOT NULL,
  `provider` varchar(100) DEFAULT 'pgsoft',
  `rtp` decimal(5,2) DEFAULT 94.00,
  `volatility` enum('low','medium','high') DEFAULT 'medium',
  `max_win` decimal(20,2) DEFAULT 0.00,
  `min_bet` decimal(10,2) DEFAULT 0.01,
  `max_bet` decimal(10,2) DEFAULT 100.00,
  `status` enum('active','inactive','maintenance') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_code` (`game_code`),
  KEY `idx_provider` (`provider`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Sessões
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `session_id` varchar(255) NOT NULL,
  `balance_initial` decimal(20,2) NOT NULL DEFAULT 0.00,
  `balance_final` decimal(20,2) DEFAULT NULL,
  `total_bet` decimal(20,2) NOT NULL DEFAULT 0.00,
  `total_win` decimal(20,2) NOT NULL DEFAULT 0.00,
  `rounds_played` int(11) NOT NULL DEFAULT 0,
  `status` enum('active','completed','abandoned') DEFAULT 'active',
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `ended_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_agent_id` (`agent_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Inserir dados de teste
-- --------------------------------------------------------

-- Agente de teste
INSERT IGNORE INTO `agents` (`id`, `agentCode`, `saldo`, `agentToken`, `secretKey`, `callbackurl`, `currency`, `symbol`) VALUES
(1, 'AGENT001', 10000.00, 'edd5e0d8-5d0f-4c3a-a08a-3da52a8a728d', '85418049-ce94-4fc7-adba-656f01a360f4', 'https://lary777.online/webhook', 'BRL', 'R$');

-- Usuário de teste
INSERT IGNORE INTO `users` (`id`, `username`, `token`, `atk`, `saldo`, `currency`, `symbol`) VALUES
(1, 'testuser', '9167ffb6-2b4f-4cfb-8543-5b0551a792ea', 'test_atk_123', 1000.00, 'BRL', 'R$');

-- Jogos principais
INSERT IGNORE INTO `games` (`game_code`, `game_name`, `provider`, `rtp`) VALUES
('fortune-tiger', 'Fortune Tiger', 'pgsoft', 96.81),
('fortune-ox', 'Fortune Ox', 'pgsoft', 96.75),
('fortune-mouse', 'Fortune Mouse', 'pgsoft', 96.74),
('fortune-rabbit', 'Fortune Rabbit', 'pgsoft', 96.72),
('fortune-dragon', 'Fortune Dragon', 'pgsoft', 96.73),
('bikini-paradise', 'Bikini Paradise', 'pgsoft', 96.68),
('jungle-delight', 'Jungle Delight', 'pgsoft', 96.31),
('ganesha-gold', 'Ganesha Gold', 'pgsoft', 96.52),
('double-fortune', 'Double Fortune', 'pgsoft', 96.09),
('dragon-tiger-luck', 'Dragon Tiger Luck', 'pgsoft', 96.29);

COMMIT;

-- Verificar se as tabelas foram criadas
SHOW TABLES;

-- Verificar estrutura da tabela users
DESCRIBE users;
