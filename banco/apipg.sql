-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Tempo de geração: 26/07/2025 às 00:18
-- Versão do servidor: 8.0.36-28
-- Versão do PHP: 8.1.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `apipg`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agents`
--

CREATE TABLE `agents` (
  `id` int NOT NULL,
  `agentCode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `saldo` decimal(15,2) NOT NULL DEFAULT '0.00',
  `agentToken` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `secretKey` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `probganho` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `probbonus` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `probganhortp` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `probganhoinfluencer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `probbonusinfluencer` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `probganhoaposta` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `probganhosaldo` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `callbackurl` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('active','inactive','suspended') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `agents`
--

INSERT INTO `agents` (`id`, `agentCode`, `saldo`, `agentToken`, `secretKey`, `probganho`, `probbonus`, `probganhortp`, `probganhoinfluencer`, `probbonusinfluencer`, `probganhoaposta`, `probganhosaldo`, `callbackurl`, `status`, `created_at`, `updated_at`) VALUES
(1, 'lary777', 100000.00, 'edd5e0d8-5d0f-4c3a-a08a-3da52a8a728d', '85418049-ce94-4fc7-adba-656f01a360f4', '30', '5', '25', '35', '8', '28', '20', 'https://lary777.online/', 'active', '2025-07-25 13:46:23', '2025-07-25 16:12:30');

-- --------------------------------------------------------

--
-- Estrutura para tabela `bikineparadisejson`
--

CREATE TABLE `bikineparadisejson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `butterflyblossomplayerjson`
--

CREATE TABLE `butterflyblossomplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `calls`
--

CREATE TABLE `calls` (
  `id` int NOT NULL,
  `iduser` int NOT NULL,
  `gamecode` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `jsonname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `steps` int DEFAULT NULL,
  `bycall` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `aw` decimal(15,2) DEFAULT '0.00',
  `status` enum('pending','completed','cancelled','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `priority` tinyint(1) DEFAULT '0',
  `expires_at` timestamp NULL DEFAULT NULL,
  `completed_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `calls`
--

INSERT INTO `calls` (`id`, `iduser`, `gamecode`, `jsonname`, `steps`, `bycall`, `aw`, `status`, `priority`, `expires_at`, `completed_at`, `created_at`, `updated_at`) VALUES
(1, 3, 'fortune-tiger', '7', 0, 'system', 0.00, 'completed', 0, NULL, NULL, '2025-07-25 18:13:44', '2025-07-25 19:47:19'),
(2, 3, 'fortune-tiger', '11', 0, 'system', 0.00, 'completed', 0, NULL, NULL, '2025-07-25 19:47:31', '2025-07-25 19:47:45'),
(3, 3, 'fortune-tiger', '12', 0, 'system', 0.00, 'completed', 0, NULL, NULL, '2025-07-25 19:47:53', '2025-07-25 19:48:05'),
(4, 3, 'fortune-tiger', '12', 0, 'system', 0.00, 'completed', 0, NULL, NULL, '2025-07-25 19:48:27', '2025-07-25 19:48:55'),
(5, 3, 'fortune-tiger', '7', 0, 'system', 0.00, 'pending', 0, NULL, NULL, '2025-07-25 20:03:20', '2025-07-25 20:04:29');

-- --------------------------------------------------------

--
-- Estrutura para tabela `cashmania`
--

CREATE TABLE `cashmania` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `chickyrun`
--

CREATE TABLE `chickyrun` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `doublefortunejson`
--

CREATE TABLE `doublefortunejson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragonhatch`
--

CREATE TABLE `dragonhatch` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragonhatch2`
--

CREATE TABLE `dragonhatch2` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragonhatchjson`
--

CREATE TABLE `dragonhatchjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragontigerluckjson`
--

CREATE TABLE `dragontigerluckjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunedragonplayerjson`
--

CREATE TABLE `fortunedragonplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunemouseplayerjson`
--

CREATE TABLE `fortunemouseplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `fortunemouseplayerjson`
--

INSERT INTO `fortunemouseplayerjson` (`id`, `json`, `created_at`, `updated_at`) VALUES
(1, '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[2,2,5,0,0,0,6,3,3],\"gm\":1,\"it\":false,\"fs\":null,\"mf\":{\"mt\":[2],\"ms\":[true],\"mi\":[0]},\"ssaw\":0.00,\"crtw\":0.0,\"imw\":false,\"gwt\":0,\"fb\":null,\"ctw\":0.0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":null,\"ml\":2,\"cs\":0.3,\"rl\":[2,2,5,0,0,0,6,3,3],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":0,\"aw\":0.00,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0.00,\"blab\":0.00,\"bl\":100000.00,\"tb\":0.00,\"tbb\":0.00,\"tw\":0.00,\"np\":0.00,\"ocr\":null,\"mr\":null,\"ge\":null}},\"err\":null}', '2025-07-25 13:46:23', '2025-07-25 13:46:23');

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortuneoxrplayerjson`
--

CREATE TABLE `fortuneoxrplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunerabbitplayerjson`
--

CREATE TABLE `fortunerabbitplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `fortunerabbitplayerjson`
--

INSERT INTO `fortunerabbitplayerjson` (`id`, `json`, `created_at`, `updated_at`) VALUES
(1, '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[2,2,0,99,8,8,8,8,2,2,0,99],\"ift\":false,\"iff\":false,\"cpf\":{\"1\":{\"p\":4,\"bv\":3000.00,\"m\":500.0},\"2\":{\"p\":5,\"bv\":120.00,\"m\":20.0},\"3\":{\"p\":6,\"bv\":30.00,\"m\":5.0},\"4\":{\"p\":7,\"bv\":3.00,\"m\":0.5}},\"cptw\":0.0,\"crtw\":0.0,\"imw\":false,\"fs\":null,\"gwt\":0,\"fb\":null,\"ctw\":0.0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":null,\"ml\":2,\"cs\":0.3,\"rl\":[2,2,0,99,8,8,8,8,2,2,0,99],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":0,\"aw\":0.00,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0.00,\"blab\":0.00,\"bl\":100000.00,\"tb\":0.00,\"tbb\":0.00,\"tw\":0.00,\"np\":0.00,\"ocr\":null,\"mr\":null,\"ge\":null},\"cc\":\"PGC\"},\"err\":null}', '2025-07-25 13:46:23', '2025-07-25 13:46:23');

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunetigerplayerjson`
--

CREATE TABLE `fortunetigerplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `fortunetigerplayerjson`
--

INSERT INTO `fortunetigerplayerjson` (`id`, `json`, `created_at`, `updated_at`) VALUES
(1, '{\"dt\":{\"si\":{\"wc\":31,\"ist\":false,\"itw\":true,\"fws\":0,\"wp\":null,\"orl\":[5,7,6,5,6,3,3,7,6],\"lw\":null,\"irs\":false,\"gwt\":-1,\"fb\":null,\"ctw\":0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":\"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#\",\"ml\":\"1\",\"cs\":\"0.08\",\"rl\":[5,7,6,5,6,3,3,7,6],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":1,\"aw\":0,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0,\"blab\":0,\"bl\":0,\"tb\":0.4,\"tbb\":0.4,\"tw\":0,\"np\":-0.4,\"ocr\":null,\"mr\":null,\"ge\":[1,11]}},\"err\":null}', '2025-07-25 13:46:23', '2025-07-25 13:46:23');

-- --------------------------------------------------------

--
-- Estrutura para tabela `freespins`
--

CREATE TABLE `freespins` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `game_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `freespins` int NOT NULL DEFAULT '0',
  `used_freespins` int NOT NULL DEFAULT '0',
  `bonus_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'regular',
  `expires_at` timestamp NULL DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `games`
--

CREATE TABLE `games` (
  `id` int NOT NULL,
  `game_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `game_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `provider` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT 'pgsoft',
  `rtp` decimal(5,2) DEFAULT '94.00',
  `volatility` enum('low','medium','high') COLLATE utf8mb4_unicode_ci DEFAULT 'medium',
  `max_win` decimal(20,2) DEFAULT '0.00',
  `min_bet` decimal(10,2) DEFAULT '0.01',
  `max_bet` decimal(10,2) DEFAULT '100.00',
  `status` enum('active','inactive','maintenance') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `game_sessions`
--

CREATE TABLE `game_sessions` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `agent_id` int NOT NULL,
  `game_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `started_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_activity` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ended_at` timestamp NULL DEFAULT NULL,
  `status` enum('active','ended','expired') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `total_bets` int DEFAULT '0',
  `total_bet_amount` decimal(15,2) DEFAULT '0.00',
  `total_win_amount` decimal(15,2) DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ganeshagoldjson`
--

CREATE TABLE `ganeshagoldjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gdnicefireplayerjson`
--

CREATE TABLE `gdnicefireplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ggr_games`
--

CREATE TABLE `ggr_games` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int UNSIGNED NOT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `game` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `balance_bet` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_win` decimal(20,2) NOT NULL DEFAULT '0.00',
  `currency` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRL',
  `aggregator` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pgapi',
  `type` enum('bet','win','loss','bonus') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `ggr_games`
--

INSERT INTO `ggr_games` (`id`, `user_id`, `provider`, `game`, `balance_bet`, `balance_win`, `currency`, `aggregator`, `type`, `created_at`, `updated_at`) VALUES
(1, 3, 'PGSOFT', 'fortune-tiger', 0.40, 0.00, 'BRL', 'pgapi', 'loss', '2025-07-25 18:13:33', '2025-07-25 18:13:33'),
(2, 3, 'PGSOFT', 'fortune-tiger', 0.40, 0.00, 'BRL', 'pgapi', 'loss', '2025-07-25 18:13:39', '2025-07-25 18:13:39'),
(3, 3, 'PGSOFT', 'fortune-tiger', 0.40, 0.00, 'BRL', 'pgapi', 'loss', '2025-07-25 18:13:42', '2025-07-25 18:13:41'),
(4, 3, 'PGSOFT', 'fortune-tiger', 0.40, 0.00, 'BRL', 'pgapi', 'loss', '2025-07-25 19:50:19', '2025-07-25 19:50:18'),
(5, 3, 'PGSOFT', 'fortune-tiger', 0.40, 0.00, 'BRL', 'pgapi', 'loss', '2025-07-25 19:51:22', '2025-07-25 19:51:21');

-- --------------------------------------------------------

--
-- Estrutura para tabela `jungledelightjson`
--

CREATE TABLE `jungledelightjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `luckyclover`
--

CREATE TABLE `luckyclover` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `luckycloverplayerjson`
--

CREATE TABLE `luckycloverplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `majestictsjson`
--

CREATE TABLE `majestictsjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `mysticpotion`
--

CREATE TABLE `mysticpotion` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ninjaraccoonplayerjson`
--

CREATE TABLE `ninjaraccoonplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `piggygold`
--

CREATE TABLE `piggygold` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `prosperftreeplayerjson`
--

CREATE TABLE `prosperftreeplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `riseapolloplayerjson`
--

CREATE TABLE `riseapolloplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `sessions`
--

CREATE TABLE `sessions` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `agent_id` int NOT NULL,
  `game_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `balance_initial` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_final` decimal(20,2) DEFAULT NULL,
  `total_bet` decimal(20,2) NOT NULL DEFAULT '0.00',
  `total_win` decimal(20,2) NOT NULL DEFAULT '0.00',
  `rounds_played` int NOT NULL DEFAULT '0',
  `status` enum('active','completed','abandoned') COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `started_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ended_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `shaolinsoccerplayerjson`
--

CREATE TABLE `shaolinsoccerplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `spins`
--

CREATE TABLE `spins` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `game_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `bet_amount` decimal(15,2) DEFAULT NULL,
  `win_amount` decimal(15,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `spins`
--

INSERT INTO `spins` (`id`, `user_id`, `game_code`, `json`, `bet_amount`, `win_amount`, `created_at`, `updated_at`) VALUES
(1, 3, 'fortune-ox', '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[5,7,6,5,6,3,3,7,6],\"irs\":false,\"gwt\":-1,\"fb\":null,\"ctw\":0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":\"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#\",\"ml\":\"1\",\"cs\":\"0.08\",\"rl\":[5,7,6,5,6,3,3,7,6],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":1,\"aw\":0,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0,\"blab\":0,\"bl\":0,\"tb\":0.4,\"tbb\":0.4,\"tw\":0,\"np\":-0.4,\"ocr\":null,\"mr\":null,\"ge\":[1,11]}},\"err\":null}', NULL, NULL, '2025-07-25 18:07:36', '2025-07-25 20:44:48');

-- --------------------------------------------------------

--
-- Estrutura para tabela `spins_inicial`
--

CREATE TABLE `spins_inicial` (
  `id` int NOT NULL,
  `game_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '1.0',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `spins_inicial`
--

INSERT INTO `spins_inicial` (`id`, `game_code`, `json`, `version`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'fortune-tiger', '{\"dt\":{\"si\":{\"wc\":31,\"ist\":false,\"itw\":true,\"fws\":0,\"wp\":null,\"orl\":[5,7,6,5,6,3,3,7,6],\"lw\":null,\"irs\":false,\"gwt\":-1,\"fb\":null,\"ctw\":0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":\"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#\",\"ml\":\"1\",\"cs\":\"0.08\",\"rl\":[5,7,6,5,6,3,3,7,6],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":1,\"aw\":0,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0,\"blab\":0,\"bl\":0,\"tb\":0.4,\"tbb\":0.4,\"tw\":0,\"np\":-0.4,\"ocr\":null,\"mr\":null,\"ge\":[1,11]}},\"err\":null}', '1.0', 1, '2025-07-25 13:46:23', '2025-07-25 13:46:23'),
(2, 'fortune-rabbit', '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[2,2,0,99,8,8,8,8,2,2,0,99],\"ift\":false,\"iff\":false,\"cpf\":{\"1\":{\"p\":4,\"bv\":3000.00,\"m\":500.0},\"2\":{\"p\":5,\"bv\":120.00,\"m\":20.0},\"3\":{\"p\":6,\"bv\":30.00,\"m\":5.0},\"4\":{\"p\":7,\"bv\":3.00,\"m\":0.5}},\"cptw\":0.0,\"crtw\":0.0,\"imw\":false,\"fs\":null,\"gwt\":0,\"fb\":null,\"ctw\":0.0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":null,\"ml\":2,\"cs\":0.3,\"rl\":[2,2,0,99,8,8,8,8,2,2,0,99],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":0,\"aw\":0.00,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0.00,\"blab\":0.00,\"bl\":100000.00,\"tb\":0.00,\"tbb\":0.00,\"tw\":0.00,\"np\":0.00,\"ocr\":null,\"mr\":null,\"ge\":null},\"cc\":\"PGC\"},\"err\":null}', '1.0', 1, '2025-07-25 13:46:23', '2025-07-25 13:46:23'),
(3, 'fortune-mouse', '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[2,2,5,0,0,0,6,3,3],\"gm\":1,\"it\":false,\"fs\":null,\"mf\":{\"mt\":[2],\"ms\":[true],\"mi\":[0]},\"ssaw\":0.00,\"crtw\":0.0,\"imw\":false,\"gwt\":0,\"fb\":null,\"ctw\":0.0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":null,\"ml\":2,\"cs\":0.3,\"rl\":[2,2,5,0,0,0,6,3,3],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":0,\"aw\":0.00,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0.00,\"blab\":0.00,\"bl\":100000.00,\"tb\":0.00,\"tbb\":0.00,\"tw\":0.00,\"np\":0.00,\"ocr\":null,\"mr\":null,\"ge\":null}},\"err\":null}', '1.0', 1, '2025-07-25 13:46:23', '2025-07-25 13:46:23'),
(4, 'fortune-dragon', '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[5,7,6,5,6,3,3,7,6],\"irs\":false,\"gwt\":-1,\"fb\":null,\"ctw\":0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":\"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#\",\"ml\":\"1\",\"cs\":\"0.08\",\"rl\":[5,7,6,5,6,3,3,7,6],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":1,\"aw\":0,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0,\"blab\":0,\"bl\":0,\"tb\":0.4,\"tbb\":0.4,\"tw\":0,\"np\":-0.4,\"ocr\":null,\"mr\":null,\"ge\":[1,11]}},\"err\":null}', '1.0', 1, '2025-07-25 13:46:23', '2025-07-25 13:46:23'),
(5, 'fortune-ox', '{\"dt\":{\"si\":{\"wp\":null,\"lw\":null,\"orl\":[5,7,6,5,6,3,3,7,6],\"irs\":false,\"gwt\":-1,\"fb\":null,\"ctw\":0,\"pmt\":null,\"cwc\":0,\"fstc\":null,\"pcwc\":0,\"rwsp\":null,\"hashr\":\"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#\",\"ml\":\"1\",\"cs\":\"0.08\",\"rl\":[5,7,6,5,6,3,3,7,6],\"sid\":\"0\",\"psid\":\"0\",\"st\":1,\"nst\":1,\"pf\":1,\"aw\":0,\"wid\":0,\"wt\":\"C\",\"wk\":\"0_C\",\"wbn\":null,\"wfg\":null,\"blb\":0,\"blab\":0,\"bl\":0,\"tb\":0.4,\"tbb\":0.4,\"tw\":0,\"np\":-0.4,\"ocr\":null,\"mr\":null,\"ge\":[1,11]}},\"err\":null}', '1.0', 1, '2025-07-25 13:46:23', '2025-07-25 13:46:23');

-- --------------------------------------------------------

--
-- Estrutura para tabela `threeczpigsplayerjson`
--

CREATE TABLE `threeczpigsplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `transactions`
--

CREATE TABLE `transactions` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `agent_id` int NOT NULL,
  `game_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('bet','win','refund','bonus','jackpot') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(20,2) NOT NULL,
  `balance_before` decimal(20,2) NOT NULL,
  `balance_after` decimal(20,2) NOT NULL,
  `balance_type` enum('balance','balance_bonus','balance_withdrawal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'balance',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRL',
  `bet_amount` decimal(20,2) DEFAULT '0.00',
  `win_amount` decimal(20,2) DEFAULT '0.00',
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PGSOFT',
  `aggregator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pgapi',
  `transaction_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `round_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `agent_id`, `game_code`, `type`, `amount`, `balance_before`, `balance_after`, `balance_type`, `currency`, `bet_amount`, `win_amount`, `provider`, `aggregator`, `transaction_id`, `reference_id`, `session_id`, `round_id`, `description`, `metadata`, `created_at`, `updated_at`) VALUES
(7, 3, 1, 'fortune-tiger', 'bet', 0.40, 281.48, 281.08, 'balance', 'BRL', 0.40, 0.00, 'PGSOFT', 'pgapi', 'BET_1753467213131_3', NULL, 'd13bcea8-7a68-4c53-872e-b7dc79edebaf', '8fb3b3386946cab7', NULL, NULL, '2025-07-25 18:13:33', '2025-07-25 18:13:33'),
(8, 3, 1, 'fortune-tiger', 'bet', 0.40, 281.08, 280.68, 'balance', 'BRL', 0.40, 0.00, 'PGSOFT', 'pgapi', 'BET_1753467219035_3', NULL, 'd13bcea8-7a68-4c53-872e-b7dc79edebaf', '4dc94c81ea2fc3ef', NULL, NULL, '2025-07-25 18:13:39', '2025-07-25 18:13:39'),
(9, 3, 1, 'fortune-tiger', 'bet', 0.40, 280.68, 280.28, 'balance', 'BRL', 0.40, 0.00, 'PGSOFT', 'pgapi', 'BET_1753467221918_3', NULL, 'd13bcea8-7a68-4c53-872e-b7dc79edebaf', 'e6216291500084e5', NULL, NULL, '2025-07-25 18:13:42', '2025-07-25 18:13:41'),
(10, 3, 1, 'fortune-tiger', 'bet', 0.40, 281.48, 281.08, 'balance', 'BRL', 0.40, 0.00, 'PGSOFT', 'pgapi', 'BET_1753473018694_3', NULL, 'd13bcea8-7a68-4c53-872e-b7dc79edebaf', '99b16c50ca2dce8e', NULL, NULL, '2025-07-25 19:50:19', '2025-07-25 19:50:18'),
(11, 3, 1, 'fortune-tiger', 'bet', 0.40, 281.08, 280.68, 'balance', 'BRL', 0.40, 0.00, 'PGSOFT', 'pgapi', 'BET_1753473081645_3', NULL, 'd13bcea8-7a68-4c53-872e-b7dc79edebaf', 'f15241d724614650', NULL, NULL, '2025-07-25 19:51:22', '2025-07-25 19:51:21');

-- --------------------------------------------------------

--
-- Estrutura para tabela `transactions_backup`
--

CREATE TABLE `transactions_backup` (
  `id` int NOT NULL DEFAULT '0',
  `user_id` int NOT NULL,
  `agent_id` int NOT NULL,
  `game_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('bet','win','refund','bonus','jackpot') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(20,2) NOT NULL,
  `balance_before` decimal(20,2) NOT NULL,
  `balance_after` decimal(20,2) NOT NULL,
  `balance_type` enum('balance','balance_bonus','balance_withdrawal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'balance',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRL',
  `bet_amount` decimal(20,2) DEFAULT '0.00',
  `win_amount` decimal(20,2) DEFAULT '0.00',
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PGSOFT',
  `aggregator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pgapi',
  `transaction_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `session_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `round_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `metadata` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `atk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `saldo` decimal(20,2) NOT NULL DEFAULT '0.00',
  `valorapostado` decimal(20,2) NOT NULL DEFAULT '0.00',
  `valordebitado` decimal(20,2) NOT NULL DEFAULT '0.00',
  `valorganho` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_bonus` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_bonus_rollover` decimal(10,2) DEFAULT '0.00',
  `balance_deposit_rollover` decimal(10,2) DEFAULT '0.00',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRL',
  `symbol` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'R$',
  `balance_type` enum('balance','balance_bonus','balance_withdrawal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'balance',
  `total_bet` decimal(20,2) NOT NULL DEFAULT '0.00',
  `total_won` decimal(20,2) NOT NULL DEFAULT '0.00',
  `total_lose` decimal(20,2) NOT NULL DEFAULT '0.00',
  `rtp` decimal(8,2) NOT NULL DEFAULT '0.00',
  `isinfluencer` tinyint(1) NOT NULL DEFAULT '0',
  `agentid` int NOT NULL,
  `status` enum('active','inactive','suspended') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `users`
--

INSERT INTO `users` (`id`, `username`, `token`, `atk`, `saldo`, `valorapostado`, `valordebitado`, `valorganho`, `balance_bonus`, `balance_withdrawal`, `balance_bonus_rollover`, `balance_deposit_rollover`, `currency`, `symbol`, `balance_type`, `total_bet`, `total_won`, `total_lose`, `rtp`, `isinfluencer`, `agentid`, `status`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'testuser', 'test_user_token_123456', 'test_atk_token_123456', 1000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'BRL', 'R$', 'balance', 0.00, 0.00, 0.00, 0.00, 0, 1, 'active', NULL, '2025-07-25 13:46:23', '2025-07-25 13:46:23'),
(2, '1', 'd35b8fce-2fbe-4ceb-a024-34d03bfbbcd1', 'cdeb8531-43f6-47e2-ab43-9bf655481db4', 5426297.50, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'BRL', 'R$', 'balance', 0.00, 0.00, 0.00, 0.00, 0, 1, 'active', NULL, '2025-07-25 16:52:44', '2025-07-25 16:52:44'),
(3, '38', '56796c67-3d71-47e2-b559-e3f6629c657d', 'd13bcea8-7a68-4c53-872e-b7dc79edebaf', 280.98, 25.80, 25.80, 482.52, 0.00, 0.00, 0.00, 0.00, 'BRL', 'R$', 'balance', 2.00, 0.00, 2.00, 1870.00, 0, 1, 'active', NULL, '2025-07-25 17:05:48', '2025-07-25 20:44:59'),
(4, 'user_token_test', '9167ffb6-2b4f-4cfb-8543-5b0551a792ea', 'atk_test_123', 1000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'BRL', 'R$', 'balance', 0.00, 0.00, 0.00, 0.00, 0, 1, 'active', NULL, '2025-07-25 17:41:45', '2025-07-25 17:41:45');

-- --------------------------------------------------------

--
-- Estrutura para tabela `users_backup`
--

CREATE TABLE `users_backup` (
  `id` int NOT NULL DEFAULT '0',
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `atk` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `saldo` decimal(20,2) NOT NULL DEFAULT '0.00',
  `valorapostado` decimal(20,2) NOT NULL DEFAULT '0.00',
  `valordebitado` decimal(20,2) NOT NULL DEFAULT '0.00',
  `valorganho` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_bonus` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_withdrawal` decimal(20,2) NOT NULL DEFAULT '0.00',
  `balance_bonus_rollover` decimal(10,2) DEFAULT '0.00',
  `balance_deposit_rollover` decimal(10,2) DEFAULT '0.00',
  `currency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'BRL',
  `symbol` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'R$',
  `balance_type` enum('balance','balance_bonus','balance_withdrawal') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'balance',
  `total_bet` decimal(20,2) NOT NULL DEFAULT '0.00',
  `total_won` decimal(20,2) NOT NULL DEFAULT '0.00',
  `total_lose` decimal(20,2) NOT NULL DEFAULT '0.00',
  `rtp` decimal(5,2) NOT NULL DEFAULT '0.00',
  `isinfluencer` tinyint(1) NOT NULL DEFAULT '0',
  `agentid` int NOT NULL,
  `status` enum('active','inactive','suspended') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Despejando dados para a tabela `users_backup`
--

INSERT INTO `users_backup` (`id`, `username`, `token`, `atk`, `saldo`, `valorapostado`, `valordebitado`, `valorganho`, `balance_bonus`, `balance_withdrawal`, `balance_bonus_rollover`, `balance_deposit_rollover`, `currency`, `symbol`, `balance_type`, `total_bet`, `total_won`, `total_lose`, `rtp`, `isinfluencer`, `agentid`, `status`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'testuser', 'test_user_token_123456', 'test_atk_token_123456', 1000.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'BRL', 'R$', 'balance', 0.00, 0.00, 0.00, 0.00, 0, 1, 'active', NULL, '2025-07-25 13:46:23', '2025-07-25 13:46:23');

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildbandito`
--

CREATE TABLE `wildbandito` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildbanditojson`
--

CREATE TABLE `wildbanditojson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildbountysdplayerjson`
--

CREATE TABLE `wildbountysdplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildchaos`
--

CREATE TABLE `wildchaos` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wingsiguazuplayerjson`
--

CREATE TABLE `wingsiguazuplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `zombieoutbreakplayerjson`
--

CREATE TABLE `zombieoutbreakplayerjson` (
  `id` int NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agents`
--
ALTER TABLE `agents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `agentToken` (`agentToken`),
  ADD UNIQUE KEY `agentCode` (`agentCode`),
  ADD KEY `idx_agent_code` (`agentCode`),
  ADD KEY `idx_agent_token` (`agentToken`),
  ADD KEY `idx_status` (`status`);

--
-- Índices de tabela `bikineparadisejson`
--
ALTER TABLE `bikineparadisejson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `butterflyblossomplayerjson`
--
ALTER TABLE `butterflyblossomplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `calls`
--
ALTER TABLE `calls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`iduser`),
  ADD KEY `idx_game_code` (`gamecode`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Índices de tabela `cashmania`
--
ALTER TABLE `cashmania`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `chickyrun`
--
ALTER TABLE `chickyrun`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `doublefortunejson`
--
ALTER TABLE `doublefortunejson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `dragonhatch`
--
ALTER TABLE `dragonhatch`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `dragonhatch2`
--
ALTER TABLE `dragonhatch2`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `dragonhatchjson`
--
ALTER TABLE `dragonhatchjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `dragontigerluckjson`
--
ALTER TABLE `dragontigerluckjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `fortunedragonplayerjson`
--
ALTER TABLE `fortunedragonplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `fortunemouseplayerjson`
--
ALTER TABLE `fortunemouseplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `fortuneoxrplayerjson`
--
ALTER TABLE `fortuneoxrplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `fortunerabbitplayerjson`
--
ALTER TABLE `fortunerabbitplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `fortunetigerplayerjson`
--
ALTER TABLE `fortunetigerplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `freespins`
--
ALTER TABLE `freespins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_game_code` (`game_code`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_expires_at` (`expires_at`);

--
-- Índices de tabela `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_code` (`game_code`),
  ADD KEY `idx_provider` (`provider`),
  ADD KEY `idx_status` (`status`);

--
-- Índices de tabela `game_sessions`
--
ALTER TABLE `game_sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_token` (`session_token`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_agent_id` (`agent_id`),
  ADD KEY `idx_game_code` (`game_code`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_started_at` (`started_at`);

--
-- Índices de tabela `ganeshagoldjson`
--
ALTER TABLE `ganeshagoldjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `gdnicefireplayerjson`
--
ALTER TABLE `gdnicefireplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `ggr_games`
--
ALTER TABLE `ggr_games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_provider` (`provider`),
  ADD KEY `idx_game` (`game`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `jungledelightjson`
--
ALTER TABLE `jungledelightjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `luckyclover`
--
ALTER TABLE `luckyclover`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `luckycloverplayerjson`
--
ALTER TABLE `luckycloverplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `majestictsjson`
--
ALTER TABLE `majestictsjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `mysticpotion`
--
ALTER TABLE `mysticpotion`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `ninjaraccoonplayerjson`
--
ALTER TABLE `ninjaraccoonplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `piggygold`
--
ALTER TABLE `piggygold`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `prosperftreeplayerjson`
--
ALTER TABLE `prosperftreeplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `riseapolloplayerjson`
--
ALTER TABLE `riseapolloplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `session_id` (`session_id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_agent_id` (`agent_id`),
  ADD KEY `idx_game_code` (`game_code`),
  ADD KEY `idx_status` (`status`);

--
-- Índices de tabela `shaolinsoccerplayerjson`
--
ALTER TABLE `shaolinsoccerplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `spins`
--
ALTER TABLE `spins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_game_unique` (`user_id`,`game_code`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_game_code` (`game_code`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Índices de tabela `spins_inicial`
--
ALTER TABLE `spins_inicial`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `game_code_version` (`game_code`,`version`),
  ADD KEY `idx_game_code` (`game_code`),
  ADD KEY `idx_is_active` (`is_active`);

--
-- Índices de tabela `threeczpigsplayerjson`
--
ALTER TABLE `threeczpigsplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_agent_id` (`agent_id`),
  ADD KEY `idx_game_code` (`game_code`),
  ADD KEY `idx_type` (`type`),
  ADD KEY `idx_balance_type` (`balance_type`),
  ADD KEY `idx_currency` (`currency`),
  ADD KEY `idx_provider` (`provider`),
  ADD KEY `idx_transaction_id` (`transaction_id`),
  ADD KEY `idx_reference_id` (`reference_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_session_id` (`session_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username_agent` (`username`,`agentid`),
  ADD UNIQUE KEY `atk` (`atk`),
  ADD KEY `idx_username` (`username`),
  ADD KEY `idx_token` (`token`),
  ADD KEY `idx_atk` (`atk`),
  ADD KEY `idx_agent_id` (`agentid`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_currency` (`currency`),
  ADD KEY `idx_balance_type` (`balance_type`);

--
-- Índices de tabela `wildbandito`
--
ALTER TABLE `wildbandito`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `wildbanditojson`
--
ALTER TABLE `wildbanditojson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `wildbountysdplayerjson`
--
ALTER TABLE `wildbountysdplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `wildchaos`
--
ALTER TABLE `wildchaos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `wingsiguazuplayerjson`
--
ALTER TABLE `wingsiguazuplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- Índices de tabela `zombieoutbreakplayerjson`
--
ALTER TABLE `zombieoutbreakplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_id` (`id`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `agents`
--
ALTER TABLE `agents`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `calls`
--
ALTER TABLE `calls`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `freespins`
--
ALTER TABLE `freespins`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `games`
--
ALTER TABLE `games`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `game_sessions`
--
ALTER TABLE `game_sessions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `ggr_games`
--
ALTER TABLE `ggr_games`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `sessions`
--
ALTER TABLE `sessions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `spins`
--
ALTER TABLE `spins`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de tabela `spins_inicial`
--
ALTER TABLE `spins_inicial`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de tabela `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `calls`
--
ALTER TABLE `calls`
  ADD CONSTRAINT `fk_calls_user` FOREIGN KEY (`iduser`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `freespins`
--
ALTER TABLE `freespins`
  ADD CONSTRAINT `fk_freespins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `game_sessions`
--
ALTER TABLE `game_sessions`
  ADD CONSTRAINT `fk_sessions_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `spins`
--
ALTER TABLE `spins`
  ADD CONSTRAINT `fk_spins_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_agent` FOREIGN KEY (`agent_id`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Restrições para tabelas `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_agent` FOREIGN KEY (`agentid`) REFERENCES `agents` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
