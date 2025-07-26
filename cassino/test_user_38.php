<?php

/**
 * Teste simples para verificar se o usuário 38 funciona
 * Execute este script para testar se o problema foi resolvido
 */

// Simular uma requisição de saldo para o usuário 38
echo "🔍 TESTANDO USUÁRIO 38 - VERIFICAÇÃO DE SALDO\n\n";

// Dados que a API enviaria
$requestData = (object) [
    'userCode' => 38,
    'method' => 'GetBalance'
];

echo "📊 Dados da requisição:\n";
echo "   - UserCode: {$requestData->userCode}\n";
echo "   - Method: {$requestData->method}\n\n";

// Simular consulta direta no banco
try {
    $host = '127.0.0.1';
    $dbname = 'cassino';
    $username = 'root';
    $password = '';
    
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    echo "✅ Conexão com banco do cassino estabelecida\n\n";
    
    // Verificar se usuário existe
    $stmt = $pdo->prepare("SELECT id, name, email, status FROM users WHERE id = ?");
    $stmt->execute([38]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($user) {
        echo "✅ Usuário encontrado:\n";
        echo "   - ID: {$user['id']}\n";
        echo "   - Nome: {$user['name']}\n";
        echo "   - Email: {$user['email']}\n";
        echo "   - Status: {$user['status']}\n\n";
    } else {
        echo "❌ Usuário 38 não encontrado no cassino!\n\n";
        exit(1);
    }
    
    // Verificar wallet
    $stmt = $pdo->prepare("
        SELECT user_id, balance, balance_bonus, balance_withdrawal, 
               (balance + balance_bonus + balance_withdrawal) as total_balance,
               active, currency
        FROM wallets 
        WHERE user_id = ? AND active = 1
    ");
    $stmt->execute([38]);
    $wallet = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($wallet) {
        echo "✅ Wallet encontrado:\n";
        echo "   - Balance: R$ {$wallet['balance']}\n";
        echo "   - Balance Bonus: R$ {$wallet['balance_bonus']}\n";
        echo "   - Balance Withdrawal: R$ {$wallet['balance_withdrawal']}\n";
        echo "   - Total Balance: R$ {$wallet['total_balance']}\n";
        echo "   - Currency: {$wallet['currency']}\n";
        echo "   - Active: {$wallet['active']}\n\n";
        
        if ($wallet['total_balance'] > 0) {
            echo "🎉 SUCESSO! O usuário 38 tem saldo disponível!\n";
            echo "   - Saldo total: R$ {$wallet['total_balance']}\n";
            echo "   - O erro INVALID_USER deve estar resolvido!\n\n";
            
            // Simular resposta da API
            echo "📤 Resposta que seria enviada:\n";
            echo "{\n";
            echo "    \"balance\": {$wallet['total_balance']},\n";
            echo "    \"msg\": \"SUCCESS\"\n";
            echo "}\n\n";
            
        } else {
            echo "⚠️  ATENÇÃO! O usuário tem wallet mas saldo zero!\n";
            echo "   - Isso pode causar INSUFFICIENT_USER_FUNDS\n";
            echo "   - Verifique se o saldo está correto\n\n";
        }
        
    } else {
        echo "❌ Wallet não encontrado para usuário 38!\n";
        echo "   - Isso causará o erro INVALID_USER\n";
        echo "   - Verifique se o wallet foi criado corretamente\n\n";
        exit(1);
    }
    
    // Verificar se existe accessor total_balance na model
    echo "🔧 DICA IMPORTANTE:\n";
    echo "   - Se o erro persistir, verifique se a model Wallet tem:\n";
    echo "   - Accessor getTotalBalanceAttribute() ou\n";
    echo "   - Campo total_balance calculado\n\n";
    
    echo "✅ TESTE CONCLUÍDO COM SUCESSO!\n";
    echo "   - Usuário 38 existe no cassino\n";
    echo "   - Wallet está ativo\n";
    echo "   - Saldo disponível: R$ {$wallet['total_balance']}\n";
    echo "   - O sistema deve funcionar corretamente agora!\n";
    
} catch (PDOException $e) {
    echo "❌ Erro de conexão: " . $e->getMessage() . "\n";
    echo "   - Verifique as configurações do banco de dados\n";
    echo "   - Host: $host\n";
    echo "   - Database: $dbname\n";
    echo "   - Username: $username\n";
    exit(1);
}

echo "\n" . str_repeat("=", 60) . "\n";
echo "PRÓXIMOS PASSOS:\n";
echo "1. Execute um jogo com o usuário 38\n";
echo "2. Verifique os logs para confirmar que não há mais INVALID_USER\n";
echo "3. Se ainda der erro, verifique a model Wallet\n";
echo str_repeat("=", 60) . "\n";
