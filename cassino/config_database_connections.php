<?php

/**
 * Configuração de múltiplas conexões de banco de dados
 * Para integração entre API e Cassino
 * 
 * Adicione estas configurações ao seu config/database.php
 */

return [
    'connections' => [
        
        // Conexão padrão do Cassino (mantém a existente)
        'mysql' => [
            'driver' => 'mysql',
            'url' => env('DATABASE_URL'),
            'host' => env('DB_HOST', '127.0.0.1'),
            'port' => env('DB_PORT', '3306'),
            'database' => env('DB_DATABASE', 'cassino'),
            'username' => env('DB_USERNAME', 'root'),
            'password' => env('DB_PASSWORD', ''),
            'unix_socket' => env('DB_SOCKET', ''),
            'charset' => 'utf8mb4',
            'collation' => 'utf8mb4_unicode_ci',
            'prefix' => '',
            'prefix_indexes' => true,
            'strict' => true,
            'engine' => null,
            'options' => extension_loaded('pdo_mysql') ? array_filter([
                PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
            ]) : [],
        ],

        // Nova conexão para a API
        'mysql_api' => [
            'driver' => 'mysql',
            'host' => env('API_DB_HOST', '127.0.0.1'),
            'port' => env('API_DB_PORT', '3306'),
            'database' => env('API_DB_DATABASE', 'apipg'),
            'username' => env('API_DB_USERNAME', 'root'),
            'password' => env('API_DB_PASSWORD', ''),
            'unix_socket' => env('API_DB_SOCKET', ''),
            'charset' => 'utf8mb4',
            'collation' => 'utf8mb4_unicode_ci',
            'prefix' => '',
            'prefix_indexes' => true,
            'strict' => true,
            'engine' => null,
            'options' => extension_loaded('pdo_mysql') ? array_filter([
                PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
            ]) : [],
        ],

    ],
];

/**
 * INSTRUÇÕES DE INSTALAÇÃO:
 * 
 * 1. Adicione as seguintes variáveis ao seu arquivo .env:
 * 
 * # Configurações do banco da API
 * API_DB_HOST=127.0.0.1
 * API_DB_PORT=3306
 * API_DB_DATABASE=apipg
 * API_DB_USERNAME=root
 * API_DB_PASSWORD=
 * 
 * 2. Adicione a conexão 'mysql_api' ao seu config/database.php na seção 'connections'
 * 
 * 3. Se estiver em produção, ajuste as configurações conforme seu ambiente:
 *    - Host do banco (pode ser diferente para cada banco)
 *    - Usuário e senha
 *    - Nomes dos bancos de dados
 */
