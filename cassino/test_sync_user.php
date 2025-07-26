<?php

/**
 * Script de teste para sincronização de usuários
 * Execute este script para testar a sincronização do usuário 38
 */

require_once __DIR__ . '/../vendor/autoload.php';

use Illuminate\Database\Capsule\Manager as Capsule;

// Configurar conexões de banco
$capsule = new Capsule;

// Conexão com banco da API
$capsule->addConnection([
    'driver' => 'mysql',
    'host' => '127.0.0.1',
    'database' => 'apipg',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
], 'api');

// Conexão com banco do Cassino
$capsule->addConnection([
    'driver' => 'mysql',
    'host' => '127.0.0.1',
    'database' => 'cassino',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
], 'cassino');

$capsule->setAsGlobal();
$capsule->bootEloquent();

function testUserSync($userId = 38) {
    echo "🔍 TESTANDO SINCRONIZAÇÃO DO USUÁRIO {$userId}\n\n";
    
    try {
        // 1. Verificar usuário na API
        echo "1. Verificando usuário na API...\n";
        $apiUser = Capsule::connection('api')
            ->table('users')
            ->where('id', $userId)
            ->first();
            
        if (!$apiUser) {
            echo "❌ Usuário {$userId} não encontrado na API\n";
            return false;
        }
        
        echo "✅ Usuário encontrado na API:\n";
        echo "   - ID: {$apiUser->id}\n";
        echo "   - Username: {$apiUser->username}\n";
        echo "   - Saldo: R$ {$apiUser->saldo}\n";
        echo "   - Balance Bonus: R$ {$apiUser->balance_bonus}\n";
        echo "   - Balance Withdrawal: R$ {$apiUser->balance_withdrawal}\n\n";
        
        // 2. Verificar usuário no Cassino
        echo "2. Verificando usuário no Cassino...\n";
        $cassinoUser = Capsule::connection('cassino')
            ->table('users')
            ->where('id', $userId)
            ->first();
            
        if (!$cassinoUser) {
            echo "⚠️  Usuário {$userId} não encontrado no Cassino. Criando...\n";
            
            // Criar usuário no cassino
            Capsule::connection('cassino')
                ->table('users')
                ->insert([
                    'id' => $userId,
                    'name' => $apiUser->username,
                    'email' => $apiUser->username . '@cassino.local',
                    'password' => password_hash('default_password', PASSWORD_DEFAULT),
                    'status' => 'active',
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
                
            echo "✅ Usuário criado no Cassino\n\n";
        } else {
            echo "✅ Usuário já existe no Cassino\n\n";
        }
        
        // 3. Verificar wallet no Cassino
        echo "3. Verificando wallet no Cassino...\n";
        $wallet = Capsule::connection('cassino')
            ->table('wallets')
            ->where('user_id', $userId)
            ->where('active', 1)
            ->first();
            
        if (!$wallet) {
            echo "⚠️  Wallet não encontrado. Criando...\n";
            
            // Criar wallet
            Capsule::connection('cassino')
                ->table('wallets')
                ->insert([
                    'user_id' => $userId,
                    'balance' => $apiUser->saldo,
                    'balance_bonus' => $apiUser->balance_bonus ?? 0,
                    'balance_withdrawal' => $apiUser->balance_withdrawal ?? 0,
                    'currency' => $apiUser->currency ?? 'BRL',
                    'active' => 1,
                    'created_at' => date('Y-m-d H:i:s'),
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
                
            echo "✅ Wallet criado com saldo R$ {$apiUser->saldo}\n\n";
        } else {
            echo "✅ Wallet encontrado:\n";
            echo "   - Balance: R$ {$wallet->balance}\n";
            echo "   - Balance Bonus: R$ {$wallet->balance_bonus}\n";
            echo "   - Balance Withdrawal: R$ {$wallet->balance_withdrawal}\n";
            echo "   - Total: R$ " . ($wallet->balance + $wallet->balance_bonus + $wallet->balance_withdrawal) . "\n\n";
            
            // Sincronizar saldo
            echo "4. Sincronizando saldo da API para o Cassino...\n";
            Capsule::connection('cassino')
                ->table('wallets')
                ->where('user_id', $userId)
                ->where('active', 1)
                ->update([
                    'balance' => $apiUser->saldo,
                    'balance_bonus' => $apiUser->balance_bonus ?? 0,
                    'balance_withdrawal' => $apiUser->balance_withdrawal ?? 0,
                    'updated_at' => date('Y-m-d H:i:s'),
                ]);
                
            echo "✅ Saldo sincronizado\n\n";
        }
        
        // 5. Verificar resultado final
        echo "5. Verificação final...\n";
        $finalWallet = Capsule::connection('cassino')
            ->table('wallets')
            ->where('user_id', $userId)
            ->where('active', 1)
            ->first();
            
        if ($finalWallet) {
            $totalBalance = $finalWallet->balance + $finalWallet->balance_bonus + $finalWallet->balance_withdrawal;
            echo "✅ Sincronização concluída!\n";
            echo "   - Saldo total no Cassino: R$ {$totalBalance}\n";
            echo "   - Saldo na API: R$ {$apiUser->saldo}\n";
            
            if (abs($totalBalance - $apiUser->saldo) < 0.01) {
                echo "✅ Saldos estão sincronizados!\n";
                return true;
            } else {
                echo "⚠️  Diferença de saldo detectada\n";
                return false;
            }
        }
        
    } catch (Exception $e) {
        echo "❌ Erro: " . $e->getMessage() . "\n";
        return false;
    }
}

// Executar teste
if (testUserSync(38)) {
    echo "\n🎉 TESTE CONCLUÍDO COM SUCESSO!\n";
    echo "O usuário 38 agora deve funcionar corretamente no sistema.\n";
} else {
    echo "\n❌ TESTE FALHOU!\n";
    echo "Verifique as configurações de banco de dados.\n";
}
