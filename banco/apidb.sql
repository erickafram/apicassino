-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Tempo de geração: 04/05/2024 às 18:10
-- Versão do servidor: 11.3.2-MariaDB-log
-- Versão do PHP: 8.2.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `apidb`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `agents`
--

CREATE TABLE `agents` (
  `id` int(11) NOT NULL,
  `agentCode` varchar(50) DEFAULT NULL,
  `saldo` float NOT NULL DEFAULT 0,
  `agentToken` varchar(255) NOT NULL,
  `secretKey` varchar(255) NOT NULL,
  `probganho` varchar(50) DEFAULT '0',
  `probbonus` varchar(10) DEFAULT '0',
  `probganhortp` varchar(10) DEFAULT '0',
  `probganhoinfluencer` varchar(10) DEFAULT '0',
  `probbonusinfluencer` varchar(10) DEFAULT '0',
  `probganhoaposta` varchar(10) DEFAULT '0',
  `probganhosaldo` varchar(10) DEFAULT '0',
  `callbackurl` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `bikineparadisejson`
--

CREATE TABLE `bikineparadisejson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `butterflyblossomplayerjson`
--

CREATE TABLE `butterflyblossomplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `calls`
--

CREATE TABLE `calls` (
  `id` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `gamecode` varchar(255) NOT NULL,
  `jsonname` varchar(255) NOT NULL DEFAULT '0',
  `steps` int(11) DEFAULT NULL,
  `bycall` varchar(255) DEFAULT NULL,
  `aw` float DEFAULT 0,
  `status` varchar(255) NOT NULL DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `doublefortunejson`
--

CREATE TABLE `doublefortunejson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"lwm":null,"slw":null,"nk":null,"sc":0,"fs":null,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":1,"cs":0.01,"rl":[8,16,9,11,5,18,1,2,4,12,6,17,7,15,10],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":0.31,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}}}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragontigerluckjson`
--

CREATE TABLE `dragontigerluckjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"mrl":{"1":{"wp":null,"lw":null,"tw":0.00,"rl":[1,2,3,2,3,1,2,0,3],"orl":[2,3,0]},"2":{"wp":null,"lw":null,"tw":0.00,"rl":[2,0,1,3,1,2,3,2,1],"orl":[0,1,2]}},"gpt":3,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":1,"cs":0.5,"rl":null,"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":0.26,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunedragonplayerjson`
--

CREATE TABLE `fortunedragonplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"gm":1,"it":false,"orl":[2,2,5,0,0,0,6,3,3],"fs":null,"mf":{"mt":[2],"ms":[true],"mi":[0]},"ssaw":0.00,"crtw":0.0,"imw":false,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,5,0,0,0,6,3,3],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunemouseplayerjson`
--

CREATE TABLE `fortunemouseplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"idr":false,"ir":false,"ist":false,"rc":0,"itw":false,"wc":0,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[1,1,1,0,0,0,2,2,2],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortuneoxrplayerjson`
--

CREATE TABLE `fortuneoxrplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wc":31,"ist":false,"itw":true,"fws":0,"wp":null,"orl":[5,7,6,5,6,3,3,7,6],"lw":null,"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"1758600495495052800","psid":"1758600495495052800","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":44409,"blab":44408.6,"bl":44408.6,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunerabbitplayerjson`
--

CREATE TABLE `fortunerabbitplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":[2,2,0,99,8,8,8,8,2,2,0,99],"ift":false,"iff":false,"cpf":{"1":{"p":4,"bv":3000.00,"m":500.0},"2":{"p":5,"bv":120.00,"m":20.0},"3":{"p":6,"bv":30.00,"m":5.0},"4":{"p":7,"bv":3.00,"m":0.5}},"cptw":0.0,"crtw":0.0,"imw":false,"fs":null,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,0,99,8,8,8,8,2,2,0,99],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null},"cc":"PGC"},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunetigerplayerjson`
--

CREATE TABLE `fortunetigerplayerjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wc":31,"ist":false,"itw":true,"fws":0,"wp":null,"orl":[5,7,6,5,6,3,3,7,6],"lw":null,"irs":false,"gwt":-1,"fb":null,"ctw":0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":"0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#","ml":"1","cs":"0.08","rl":[5,7,6,5,6,3,3,7,6],"sid":"1758600495495052800","psid":"1758600495495052800","st":1,"nst":1,"pf":1,"aw":0,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":44409,"blab":44408.6,"bl":44408.6,"tb":0.4,"tbb":0.4,"tw":0,"np":-0.4,"ocr":null,"mr":null,"ge":[1,11]}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ganeshagoldjson`
--

CREATE TABLE `ganeshagoldjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"ltw":0.0,"snww":null,"fs":null,"sc":0,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,1,5,4,3,3,0,9,7,8,8,6,7,3,6],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `jungledelightjson`
--

CREATE TABLE `jungledelightjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"c":null,"orl":null,"fs":null,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":1,"cs":0.02,"rl":[3,6,7,6,3,7,4,5,4,8,9,7,9,8,7],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":0.62,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `cashmania`
--

CREATE TABLE `cashmania` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `chickyrun`
--

CREATE TABLE `chickyrun` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragonhatch`
--

CREATE TABLE `dragonhatch` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragonhatch2`
--

CREATE TABLE `dragonhatch2` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dragonhatchjson`
--

CREATE TABLE `dragonhatchjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `fortunerabbitjson`
--

CREATE TABLE `fortunerabbitjson` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":[2,2,0,99,8,8,8,8,2,2,0,99],"ift":false,"iff":false,"cpf":{"1":{"p":4,"bv":3000.00,"m":500.0},"2":{"p":5,"bv":120.00,"m":20.0},"3":{"p":6,"bv":30.00,"m":5.0},"4":{"p":7,"bv":3.00,"m":0.5}},"cptw":0.0,"crtw":0.0,"imw":false,"fs":null,"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[2,2,0,99,8,8,8,8,2,2,0,99],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null},"cc":"PGC"},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `freespins`
--

CREATE TABLE `freespins` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `game_code` varchar(255) NOT NULL,
  `freespins` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `luckyclover`
--

CREATE TABLE `luckyclover` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `mysticpotion`
--

CREATE TABLE `mysticpotion` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `piggygold`
--

CREATE TABLE `piggygold` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `spins`
--

CREATE TABLE `spins` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `game_code` varchar(255) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `spins_inicial`
--

CREATE TABLE `spins_inicial` (
  `id` int(11) NOT NULL,
  `game_code` varchar(255) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `game_code` varchar(255) NOT NULL,
  `type` enum('bet','win','refund') NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `balance_before` decimal(10,2) NOT NULL,
  `balance_after` decimal(10,2) NOT NULL,
  `reference_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `token` varchar(255) NOT NULL DEFAULT '',
  `atk` varchar(255) NOT NULL,
  `saldo` float NOT NULL DEFAULT 0,
  `valorapostado` float NOT NULL DEFAULT 0,
  `valordebitado` float NOT NULL DEFAULT 0,
  `valorganho` float NOT NULL DEFAULT 0,
  `rtp` double NOT NULL DEFAULT 0,
  `isinfluencer` float NOT NULL DEFAULT 0,
  `agentid` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `agents`
--
ALTER TABLE `agents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Índices de tabela `bikineparadisejson`
--
ALTER TABLE `bikineparadisejson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `butterflyblossomplayerjson`
--
ALTER TABLE `butterflyblossomplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `calls`
--
ALTER TABLE `calls`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Índices de tabela `doublefortunejson`
--
ALTER TABLE `doublefortunejson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `dragontigerluckjson`
--
ALTER TABLE `dragontigerluckjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `fortunedragonplayerjson`
--
ALTER TABLE `fortunedragonplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `fortunemouseplayerjson`
--
ALTER TABLE `fortunemouseplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `fortuneoxrplayerjson`
--
ALTER TABLE `fortuneoxrplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `fortunerabbitplayerjson`
--
ALTER TABLE `fortunerabbitplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `fortunetigerplayerjson`
--
ALTER TABLE `fortunetigerplayerjson`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Índices de tabela `ganeshagoldjson`
--
ALTER TABLE `ganeshagoldjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `jungledelightjson`
--
ALTER TABLE `jungledelightjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `cashmania`
--
ALTER TABLE `cashmania`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `chickyrun`
--
ALTER TABLE `chickyrun`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `dragonhatch`
--
ALTER TABLE `dragonhatch`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `dragonhatch2`
--
ALTER TABLE `dragonhatch2`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `dragonhatchjson`
--
ALTER TABLE `dragonhatchjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `fortunerabbitjson`
--
ALTER TABLE `fortunerabbitjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `freespins`
--
ALTER TABLE `freespins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `game_code` (`game_code`);

--
-- Índices de tabela `luckyclover`
--
ALTER TABLE `luckyclover`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `mysticpotion`
--
ALTER TABLE `mysticpotion`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `piggygold`
--
ALTER TABLE `piggygold`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `spins`
--
ALTER TABLE `spins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `game_code` (`game_code`);

--
-- Índices de tabela `spins_inicial`
--
ALTER TABLE `spins_inicial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `game_code` (`game_code`);

--
-- Índices de tabela `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `agent_id` (`agent_id`),
  ADD KEY `game_code` (`game_code`),
  ADD KEY `reference_id` (`reference_id`);

--
-- Índices de tabela `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Índices de tabela `wildbandito`
--
ALTER TABLE `wildbandito`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `wildchaos`
--
ALTER TABLE `wildchaos`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `calls`
--
ALTER TABLE `calls`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `freespins`
--
ALTER TABLE `freespins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `spins`
--
ALTER TABLE `spins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `spins_inicial`
--
ALTER TABLE `spins_inicial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
-- --------------------------------------------------------

--
-- Estrutura para tabela `wildbandito`
--

CREATE TABLE `wildbandito` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildchaos`
--

CREATE TABLE `wildchaos` (
  `id` int(11) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `majestictsjson`
--

CREATE TABLE `majestictsjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildbanditojson`
--

CREATE TABLE `wildbanditojson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `gdnicefireplayerjson`
--

CREATE TABLE `gdnicefireplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `prosperftreeplayerjson`
--

CREATE TABLE `prosperftreeplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `threeczpigsplayerjson`
--

CREATE TABLE `threeczpigsplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `ninjaraccoonplayerjson`
--

CREATE TABLE `ninjaraccoonplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `luckycloverplayerjson`
--

CREATE TABLE `luckycloverplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `shaolinsoccerplayerjson`
--

CREATE TABLE `shaolinsoccerplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wildbountysdplayerjson`
--

CREATE TABLE `wildbountysdplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `zombieoutbreakplayerjson`
--

CREATE TABLE `zombieoutbreakplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `riseapolloplayerjson`
--

CREATE TABLE `riseapolloplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `wingsiguazuplayerjson`
--

CREATE TABLE `wingsiguazuplayerjson` (
  `id` int(10) NOT NULL,
  `json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{"dt":{"si":{"wp":null,"lw":null,"orl":null,"wm":0,"rwm":null,"wabm":0.0,"fs":null,"sc":0,"wppr":[[],[],[0,1,2,3],[],[]],"gwt":0,"fb":null,"ctw":0.0,"pmt":null,"cwc":0,"fstc":null,"pcwc":0,"rwsp":null,"hashr":null,"ml":2,"cs":0.3,"rl":[3,8,4,12,9,1,10,5,0,0,0,0,9,1,10,5,3,8,4,12],"sid":"0","psid":"0","st":1,"nst":1,"pf":0,"aw":0.00,"wid":0,"wt":"C","wk":"0_C","wbn":null,"wfg":null,"blb":0.00,"blab":0.00,"bl":100000.00,"tb":0.00,"tbb":0.00,"tw":0.00,"np":0.00,"ocr":null,"mr":null,"ge":null}},"err":null}'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `majestictsjson`
--
ALTER TABLE `majestictsjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `wildbanditojson`
--
ALTER TABLE `wildbanditojson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `gdnicefireplayerjson`
--
ALTER TABLE `gdnicefireplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `prosperftreeplayerjson`
--
ALTER TABLE `prosperftreeplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `threeczpigsplayerjson`
--
ALTER TABLE `threeczpigsplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `ninjaraccoonplayerjson`
--
ALTER TABLE `ninjaraccoonplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `luckycloverplayerjson`
--
ALTER TABLE `luckycloverplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `shaolinsoccerplayerjson`
--
ALTER TABLE `shaolinsoccerplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `wildbountysdplayerjson`
--
ALTER TABLE `wildbountysdplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `zombieoutbreakplayerjson`
--
ALTER TABLE `zombieoutbreakplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `riseapolloplayerjson`
--
ALTER TABLE `riseapolloplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

--
-- Índices de tabela `wingsiguazuplayerjson`
--
ALTER TABLE `wingsiguazuplayerjson`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id` (`id`) USING BTREE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;