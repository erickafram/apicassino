-- =====================================================
-- BANCO DE DADOS COMPLETO - API PG SOFT
-- Gerado baseado na análise completa do projeto
-- Data: 2025-07-23
-- =====================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- =====================================================
-- CRIAÇÃO DO BANCO DE DADOS
-- =====================================================

CREATE DATABASE IF NOT EXISTS `pgapi` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pgapi`;

-- =====================================================
-- TABELAS PRINCIPAIS DO SISTEMA
-- =====================================================

-- --------------------------------------------------------
-- Tabela de Agentes
-- --------------------------------------------------------

CREATE TABLE `agents` (
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
  KEY `idx_agent_code` (`agentCode`),
  KEY `idx_agent_token` (`agentToken`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Usuários
-- --------------------------------------------------------

CREATE TABLE `users` (
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
  KEY `idx_status` (`status`),
  KEY `idx_currency` (`currency`),
  KEY `idx_balance_type` (`balance_type`),
  CONSTRAINT `fk_users_agent` FOREIGN KEY (`agentid`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Transações
-- --------------------------------------------------------

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `type` enum('bet','win','refund','bonus','jackpot') NOT NULL,
  `amount` decimal(20,2) NOT NULL,
  `balance_before` decimal(20,2) NOT NULL,
  `balance_after` decimal(20,2) NOT NULL,
  `balance_type` enum('balance','balance_bonus','balance_withdrawal') DEFAULT 'balance',
  `currency` varchar(20) NOT NULL DEFAULT 'BRL',
  `bet_amount` decimal(20,2) DEFAULT 0.00,
  `win_amount` decimal(20,2) DEFAULT 0.00,
  `provider` varchar(50) DEFAULT 'PGSOFT',
  `aggregator` varchar(50) DEFAULT 'pgapi',
  `transaction_id` varchar(255) DEFAULT NULL,
  `reference_id` varchar(255) DEFAULT NULL,
  `session_id` varchar(255) DEFAULT NULL,
  `round_id` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_agent_id` (`agent_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_type` (`type`),
  KEY `idx_balance_type` (`balance_type`),
  KEY `idx_currency` (`currency`),
  KEY `idx_provider` (`provider`),
  KEY `idx_transaction_id` (`transaction_id`),
  KEY `idx_reference_id` (`reference_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_session_id` (`session_id`),
  CONSTRAINT `fk_transactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transactions_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Spins dos Usuários
-- --------------------------------------------------------

CREATE TABLE `spins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `bet_amount` decimal(15,2) DEFAULT NULL,
  `win_amount` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_game_unique` (`user_id`, `game_code`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_spins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Configurações Iniciais dos Jogos
-- --------------------------------------------------------

CREATE TABLE `spins_inicial` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `game_code` varchar(100) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `version` varchar(20) DEFAULT '1.0',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `game_code_version` (`game_code`, `version`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_is_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Calls (Sistema de Chamadas)
-- --------------------------------------------------------

CREATE TABLE `calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iduser` int(11) NOT NULL,
  `gamecode` varchar(100) NOT NULL,
  `jsonname` varchar(255) NOT NULL DEFAULT '0',
  `steps` int(11) DEFAULT NULL,
  `bycall` varchar(255) DEFAULT NULL,
  `aw` decimal(15,2) DEFAULT 0.00,
  `status` enum('pending','completed','cancelled','expired') NOT NULL DEFAULT 'pending',
  `priority` tinyint(1) DEFAULT 0,
  `expires_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`iduser`),
  KEY `idx_game_code` (`gamecode`),
  KEY `idx_status` (`status`),
  KEY `idx_created_at` (`created_at`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `fk_calls_user` FOREIGN KEY (`iduser`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Free Spins
-- --------------------------------------------------------

CREATE TABLE `freespins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `freespins` int(11) NOT NULL DEFAULT 0,
  `used_freespins` int(11) NOT NULL DEFAULT 0,
  `bonus_type` varchar(50) DEFAULT 'regular',
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_expires_at` (`expires_at`),
  CONSTRAINT `fk_freespins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Tabela de Sessões de Jogo
-- --------------------------------------------------------

CREATE TABLE `game_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `game_code` varchar(100) NOT NULL,
  `session_token` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `ended_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','ended','expired') DEFAULT 'active',
  `total_bets` int(11) DEFAULT 0,
  `total_bet_amount` decimal(15,2) DEFAULT 0.00,
  `total_win_amount` decimal(15,2) DEFAULT 0.00,
  PRIMARY KEY (`id`),
  UNIQUE KEY `session_token` (`session_token`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_agent_id` (`agent_id`),
  KEY `idx_game_code` (`game_code`),
  KEY `idx_status` (`status`),
  KEY `idx_started_at` (`started_at`),
  CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sessions_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABELAS JSON DOS JOGOS ESPECÍFICOS
-- =====================================================

-- --------------------------------------------------------
-- Fortune Series Games
-- --------------------------------------------------------

CREATE TABLE `fortunetigerplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fortunerabbitplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fortunemouseplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fortunedragonplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `fortuneoxrplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Other Popular Games
-- --------------------------------------------------------

CREATE TABLE `bikineparadisejson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `butterflyblossomplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `doublefortunejson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dragontigerluckjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ganeshagoldjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `jungledelightjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Slot Games
-- --------------------------------------------------------

CREATE TABLE `luckycloverplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `majestictsjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ninjaraccoonplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `piggygold` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `prosperftreeplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `riseapolloplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `shaolinsoccerplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `threeczpigsplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Wild Series Games
-- --------------------------------------------------------

CREATE TABLE `wildbandito` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wildbanditojson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wildbountysdplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Additional Games
-- --------------------------------------------------------

CREATE TABLE `cashmania` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `chickyrun` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dragonhatch` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dragonhatch2` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `dragonhatchjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `gdnicefireplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `luckyclover` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `mysticpotion` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wildchaos` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `wingsiguazuplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `zombieoutbreakplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- DADOS INICIAIS PARA TESTE
-- =====================================================

-- Inserir agente padrão
INSERT INTO `agents` (`id`, `agentCode`, `saldo`, `agentToken`, `secretKey`, `probganho`, `probbonus`, `probganhortp`, `probganhoinfluencer`, `probbonusinfluencer`, `probganhoaposta`, `probganhosaldo`, `callbackurl`, `status`) VALUES
(1, 'AGENT001', 100000.00, 'test_agent_token_123456', 'test_secret_key_123456', '30', '5', '25', '35', '8', '28', '20', 'http://localhost:3006/callback', 'active');

-- Inserir usuário de teste
INSERT INTO `users` (`id`, `username`, `token`, `atk`, `saldo`, `valorapostado`, `valordebitado`, `valorganho`, `balance_bonus`, `balance_withdrawal`, `balance_bonus_rollover`, `balance_deposit_rollover`, `currency`, `symbol`, `balance_type`, `total_bet`, `total_won`, `total_lose`, `rtp`, `isinfluencer`, `agentid`, `status`) VALUES
(1, 'testuser', 'test_user_token_123456', 'test_atk_token_123456', 1000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'BRL', 'R$', 'balance', 0.00, 0.00, 0.00, 0.00, 0, 1, 'active');

-- Inserir configurações iniciais dos jogos principais
INSERT INTO `spins_inicial` (`game_code`, `json`, `version`, `is_active`) VALUES
('fortune-tiger', '{"dt":{"si":{"wc":31,"ist":false,"itw":true,"fws":0,"wp":null,"orl":[5,7,6,5,6,3,3,7,6],"lw":null,"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"0","psid":"0","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0,"blab":0,"bl":0,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}', '1.0', 1),
('fortune-rabbit', '{"dt":{"si":{"wp":null,"lw":null,"orl":[2,2,0,99,8,8,8,8,2,2,0,99],"ift":false,"iff":false,"cpf":{"1":{"p":4,"bv":3000.00,"m":500.0},"2":{"p":5,"bv":120.00,"m":20.0},"3":{"p":6,"bv":30.00,"m":5.0},"4":{"p":7,"bv":3.00,"m":0.5}},"cptw":0.0,"crtw":0.0,"imw":false,"fs":null,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,0,99,8,8,8,8,2,2,0,99],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null},"cc":"PGC"},"err":null}', '1.0', 1),
('fortune-mouse', '{"dt":{"si":{"wp":null,"lw":null,"orl":[2,2,5,0,0,0,6,3,3],"gm":1,"it":false,"fs":null,"mf":{"mt":[2],"ms":[true],"mi":[0]},"ssaw":0.00,"crtw":0.0,"imw":false,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,5,0,0,0,6,3,3],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}', '1.0', 1),
('fortune-dragon', '{"dt":{"si":{"wp":null,"lw":null,"orl":[5,7,6,5,6,3,3,7,6],"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"0","psid":"0","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0,"blab":0,"bl":0,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}', '1.0', 1),
('fortune-ox', '{"dt":{"si":{"wp":null,"lw":null,"orl":[5,7,6,5,6,3,3,7,6],"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"0","psid":"0","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0,"blab":0,"bl":0,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}', '1.0', 1);

-- Inserir dados iniciais nas tabelas JSON dos jogos principais
INSERT INTO `fortunetigerplayerjson` (`id`, `json`) VALUES
(1, '{"dt":{"si":{"wc":31,"ist":false,"itw":true,"fws":0,"wp":null,"orl":[5,7,6,5,6,3,3,7,6],"lw":null,"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"0","psid":"0","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0,"blab":0,"bl":0,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}');

INSERT INTO `fortunerabbitplayerjson` (`id`, `json`) VALUES
(1, '{"dt":{"si":{"wp":null,"lw":null,"orl":[2,2,0,99,8,8,8,8,2,2,0,99],"ift":false,"iff":false,"cpf":{"1":{"p":4,"bv":3000.00,"m":500.0},"2":{"p":5,"bv":120.00,"m":20.0},"3":{"p":6,"bv":30.00,"m":5.0},"4":{"p":7,"bv":3.00,"m":0.5}},"cptw":0.0,"crtw":0.0,"imw":false,"fs":null,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,0,99,8,8,8,8,2,2,0,99],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null},"cc":"PGC"},"err":null}');

INSERT INTO `fortunemouseplayerjson` (`id`, `json`) VALUES
(1, '{"dt":{"si":{"wp":null,"lw":null,"orl":[2,2,5,0,0,0,6,3,3],"gm":1,"it":false,"fs":null,"mf":{"mt":[2],"ms":[true],"mi":[0]},"ssaw":0.00,"crtw":0.0,"imw":false,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,5,0,0,0,6,3,3],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}');

-- =====================================================
-- CONFIGURAÇÕES FINAIS
-- =====================================================

-- Configurar AUTO_INCREMENT para as tabelas principais
ALTER TABLE `agents` AUTO_INCREMENT = 2;
ALTER TABLE `users` AUTO_INCREMENT = 2;
ALTER TABLE `transactions` AUTO_INCREMENT = 1;
ALTER TABLE `spins` AUTO_INCREMENT = 1;
ALTER TABLE `spins_inicial` AUTO_INCREMENT = 6;
ALTER TABLE `calls` AUTO_INCREMENT = 1;
ALTER TABLE `freespins` AUTO_INCREMENT = 1;
ALTER TABLE `game_sessions` AUTO_INCREMENT = 1;

-- Configurar AUTO_INCREMENT para tabelas JSON dos jogos
ALTER TABLE `fortunetigerplayerjson` AUTO_INCREMENT = 2;
ALTER TABLE `fortunerabbitplayerjson` AUTO_INCREMENT = 2;
ALTER TABLE `fortunemouseplayerjson` AUTO_INCREMENT = 2;
ALTER TABLE `fortunedragonplayerjson` AUTO_INCREMENT = 1;
ALTER TABLE `fortuneoxrplayerjson` AUTO_INCREMENT = 1;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

-- =====================================================
-- FIM DO SCRIPT - BANCO DE DADOS COMPLETO
-- =====================================================
