-- =====================================================
-- SCRIPT DE CORREÇÃO SIMPLES DO BANCO DE DADOS
-- Corrige problemas de tabelas ausentes
-- =====================================================

-- Criar banco se não existir
CREATE DATABASE IF NOT EXISTS `apipg` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `apipg`;

-- --------------------------------------------------------
-- Tabela de Agentes (estrutura básica)
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agentCode` varchar(50) DEFAULT NULL,
  `saldo` decimal(15,2) NOT NULL DEFAULT 0.00,
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
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `agentCode` (`agentCode`),
  UNIQUE KEY `agentToken` (`agentToken`),
  UNIQUE KEY `secretKey` (`secretKey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Usuários (estrutura básica)
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `token` varchar(255) NOT NULL DEFAULT '',
  `atk` varchar(255) NOT NULL,
  `saldo` decimal(15,2) NOT NULL DEFAULT 0.00,
  `valorapostado` decimal(15,2) NOT NULL DEFAULT 0.00,
  `valordebitado` decimal(15,2) NOT NULL DEFAULT 0.00,
  `valorganho` decimal(15,2) NOT NULL DEFAULT 0.00,
  `rtp` decimal(5,2) NOT NULL DEFAULT 0.00,
  `isinfluencer` tinyint(1) NOT NULL DEFAULT 0,
  `agentid` int(11) NOT NULL DEFAULT 1,
  `status` enum('active','inactive','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `token` (`token`),
  UNIQUE KEY `atk` (`atk`),
  KEY `idx_token` (`token`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Transações (estrutura básica)
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `round_id` varchar(255) NOT NULL,
  `type` enum('bet','win','refund') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `balance_before` decimal(15,2) NOT NULL,
  `balance_after` decimal(15,2) NOT NULL,
  `transaction_id` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_game_code` (`game_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Inserir dados de teste
-- --------------------------------------------------------

-- Agente de teste
INSERT IGNORE INTO `agents` (`id`, `agentCode`, `saldo`, `agentToken`, `secretKey`, `callbackurl`) VALUES
(1, 'AGENT001', 10000.00, 'edd5e0d8-5d0f-4c3a-a08a-3da52a8a728d', '85418049-ce94-4fc7-adba-656f01a360f4', 'https://lary777.online/webhook');

-- Usuário de teste
INSERT IGNORE INTO `users` (`id`, `username`, `token`, `atk`, `saldo`, `agentid`) VALUES
(1, 'testuser', '9167ffb6-2b4f-4cfb-8543-5b0551a792ea', 'test_atk_123', 1000.00, 1);

COMMIT;

-- Verificar se as tabelas foram criadas
SHOW TABLES;

-- Verificar estrutura da tabela users
DESCRIBE users;
