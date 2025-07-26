<?php

/**
 * Script de debug para testar o webhook do cassino
 * Execute este script no servidor do cassino para debugar o problema
 */

echo "🔍 DEBUG WEBHOOK CASSINO - USUÁRIO 38\n";
echo str_repeat("=", 60) . "\n\n";

// Simular dados que a API está enviando
$webhookData = [
    'method' => 'GetBalance',
    'userCode' => 38
];

echo "📤 DADOS ENVIADOS PELA API:\n";
echo json_encode($webhookData, JSON_PRETTY_PRINT) . "\n\n";

// Verificar conexão com banco
try {
    $host = '127.0.0.1';
    $dbname = 'cassino';
    $username = 'root';
    $password = '';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "✅ Conexão com banco estabelecida\n\n";
    
} catch (PDOException $e) {
    echo "❌ ERRO DE CONEXÃO: " . $e->getMessage() . "\n";
    echo "   Verifique as configurações do banco\n\n";
    exit(1);
}

// 1. Verificar usuário
echo "1️⃣ VERIFICANDO USUÁRIO 38:\n";
$stmt = $pdo->prepare("SELECT id, name, email, status FROM users WHERE id = ?");
$stmt->execute([38]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    echo "   ✅ Usuário encontrado:\n";
    echo "      - ID: {$user['id']}\n";
    echo "      - Nome: {$user['name']}\n";
    echo "      - Status: {$user['status']}\n\n";
} else {
    echo "   ❌ USUÁRIO 38 NÃO ENCONTRADO!\n";
    echo "   🚨 ESTE É O PROBLEMA! O usuário não existe no cassino.\n\n";
    exit(1);
}

// 2. Verificar wallet
echo "2️⃣ VERIFICANDO WALLET:\n";
$stmt = $pdo->prepare("
    SELECT user_id, balance, balance_bonus, balance_withdrawal, 
           (balance + balance_bonus + balance_withdrawal) as total_balance,
           active, currency
    FROM wallets 
    WHERE user_id = ?
");
$stmt->execute([38]);
$wallet = $stmt->fetch(PDO::FETCH_ASSOC);

if ($wallet) {
    echo "   ✅ Wallet encontrado:\n";
    echo "      - Balance: R$ {$wallet['balance']}\n";
    echo "      - Balance Bonus: R$ {$wallet['balance_bonus']}\n";
    echo "      - Balance Withdrawal: R$ {$wallet['balance_withdrawal']}\n";
    echo "      - Total: R$ {$wallet['total_balance']}\n";
    echo "      - Active: {$wallet['active']}\n\n";
    
    if ($wallet['active'] != 1) {
        echo "   ⚠️  WALLET INATIVO! Active = {$wallet['active']}\n";
        echo "   🚨 ESTE PODE SER O PROBLEMA!\n\n";
    }
    
    if ($wallet['total_balance'] <= 0) {
        echo "   ⚠️  SALDO ZERO! Total = {$wallet['total_balance']}\n";
        echo "   🚨 ISSO CAUSARÁ INSUFFICIENT_USER_FUNDS!\n\n";
    }
    
} else {
    echo "   ❌ WALLET NÃO ENCONTRADO!\n";
    echo "   🚨 ESTE É O PROBLEMA! Wallet não existe para usuário 38.\n\n";
    
    // Tentar criar wallet
    echo "3️⃣ TENTANDO CRIAR WALLET:\n";
    try {
        $stmt = $pdo->prepare("
            INSERT INTO wallets (user_id, balance, balance_bonus, balance_withdrawal, currency, active, created_at, updated_at)
            VALUES (?, 140.74, 0.00, 0.00, 'BRL', 1, NOW(), NOW())
        ");
        $stmt->execute([38]);
        
        echo "   ✅ Wallet criado com sucesso!\n";
        echo "      - Saldo inicial: R$ 140,74\n\n";
        
    } catch (PDOException $e) {
        echo "   ❌ Erro ao criar wallet: " . $e->getMessage() . "\n\n";
    }
    
    exit(1);
}

// 3. Simular chamada do webhook
echo "3️⃣ SIMULANDO WEBHOOK GetBalance:\n";

// Simular a lógica do EvergameTrait::GetBalanceInfoEvergame
if (!empty($wallet) && $wallet['total_balance'] > 0) {
    $response = [
        'balance' => $wallet['total_balance'],
        'msg' => "SUCCESS"
    ];
    echo "   ✅ RESPOSTA ESPERADA:\n";
    echo "   " . json_encode($response, JSON_PRETTY_PRINT) . "\n\n";
} else {
    $response = [
        'balance' => 0,
        'msg' => "INSUFFICIENT_USER_FUNDS"
    ];
    echo "   ❌ RESPOSTA DE ERRO:\n";
    echo "   " . json_encode($response, JSON_PRETTY_PRINT) . "\n\n";
}

// 4. Verificar se o trait está sendo usado
echo "4️⃣ VERIFICAÇÕES ADICIONAIS:\n";
echo "   📁 Verifique se o arquivo existe:\n";
echo "      app/Traits/Providers/EvergameTrait.php\n\n";
echo "   🔗 Verifique se o controller está usando o trait:\n";
echo "      use App\\Traits\\Providers\\EvergameTrait;\n\n";
echo "   🌐 Verifique se a rota do webhook está correta:\n";
echo "      POST /api/evergame/webhook\n\n";

// 5. Logs para debug
echo "5️⃣ COMANDOS PARA DEBUG NO SERVIDOR:\n";
echo "   # Ver logs do Laravel:\n";
echo "   tail -f storage/logs/laravel.log | grep -i 'balance\\|invalid\\|user'\n\n";
echo "   # Ver logs do servidor web:\n";
echo "   tail -f /var/log/nginx/error.log\n\n";
echo "   # Testar webhook diretamente:\n";
echo "   curl -X POST http://localhost/api/evergame/webhook \\\n";
echo "        -H 'Content-Type: application/json' \\\n";
echo "        -d '{\"method\":\"GetBalance\",\"userCode\":38}'\n\n";

echo "🎯 CONCLUSÃO:\n";
if ($user && $wallet && $wallet['active'] == 1 && $wallet['total_balance'] > 0) {
    echo "   ✅ Tudo parece estar correto no banco!\n";
    echo "   🔍 O problema pode estar:\n";
    echo "      - No código do trait não atualizado\n";
    echo "      - Na rota do webhook\n";
    echo "      - No controller que chama o trait\n";
    echo "      - Cache do Laravel\n\n";
    echo "   💡 EXECUTE NO SERVIDOR:\n";
    echo "      php artisan config:clear\n";
    echo "      php artisan cache:clear\n";
    echo "      php artisan route:clear\n\n";
} else {
    echo "   ❌ Problema encontrado no banco de dados!\n";
    echo "   🔧 Corrija os problemas identificados acima.\n\n";
}

echo str_repeat("=", 60) . "\n";
echo "FIM DO DEBUG\n";
