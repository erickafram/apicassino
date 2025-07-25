const mysql = require('mysql2/promise');

// Configurações dos bancos de dados
const configAPI = {
    host: 'localhost',
    user: 'root',
    password: '', // Ajuste conforme necessário
    database: 'apipg' // Nome do banco da API
};

const configCassino = {
    host: 'localhost', 
    user: 'root',
    password: '', // Ajuste conforme necessário
    database: 'cassino' // Nome do banco do cassino
};

async function verificarSaldos() {
    let connectionAPI = null;
    let connectionCassino = null;
    
    try {
        // Conectar aos bancos
        connectionAPI = await mysql.createConnection(configAPI);
        connectionCassino = await mysql.createConnection(configCassino);
        
        console.log('🔍 VERIFICANDO SALDOS ENTRE API E CASSINO\n');
        
        // Buscar usuários da API
        const [usersAPI] = await connectionAPI.execute(`
            SELECT id, username, saldo, balance_bonus, balance_withdrawal 
            FROM users 
            ORDER BY id
        `);
        
        console.log(`📊 Encontrados ${usersAPI.length} usuários na API\n`);
        
        for (const userAPI of usersAPI) {
            const saldoTotalAPI = parseFloat(userAPI.saldo || 0) + 
                                 parseFloat(userAPI.balance_bonus || 0) + 
                                 parseFloat(userAPI.balance_withdrawal || 0);
            
            // Buscar wallet correspondente no cassino
            const [walletsC] = await connectionCassino.execute(`
                SELECT user_id, balance, balance_bonus, balance_withdrawal, 
                       (balance + balance_bonus + balance_withdrawal) as total_balance
                FROM wallets 
                WHERE user_id = ? AND active = 1
            `, [userAPI.id]);
            
            if (walletsC.length > 0) {
                const walletCassino = walletsC[0];
                const saldoCassino = parseFloat(walletCassino.total_balance || 0);
                
                console.log(`👤 Usuário: ${userAPI.username} (ID: ${userAPI.id})`);
                console.log(`   API:     R$ ${saldoTotalAPI.toFixed(2)}`);
                console.log(`   Cassino: R$ ${saldoCassino.toFixed(2)}`);
                
                if (Math.abs(saldoTotalAPI - saldoCassino) > 0.01) {
                    console.log(`   ⚠️  DISCREPÂNCIA: Diferença de R$ ${(saldoCassino - saldoTotalAPI).toFixed(2)}`);
                    
                    // Mostrar detalhes
                    console.log(`   📋 Detalhes API:`);
                    console.log(`      - Saldo: R$ ${parseFloat(userAPI.saldo || 0).toFixed(2)}`);
                    console.log(`      - Bônus: R$ ${parseFloat(userAPI.balance_bonus || 0).toFixed(2)}`);
                    console.log(`      - Saque: R$ ${parseFloat(userAPI.balance_withdrawal || 0).toFixed(2)}`);
                    
                    console.log(`   📋 Detalhes Cassino:`);
                    console.log(`      - Saldo: R$ ${parseFloat(walletCassino.balance || 0).toFixed(2)}`);
                    console.log(`      - Bônus: R$ ${parseFloat(walletCassino.balance_bonus || 0).toFixed(2)}`);
                    console.log(`      - Saque: R$ ${parseFloat(walletCassino.balance_withdrawal || 0).toFixed(2)}`);
                } else {
                    console.log(`   ✅ Saldos sincronizados`);
                }
                console.log('');
            } else {
                console.log(`👤 Usuário: ${userAPI.username} (ID: ${userAPI.id})`);
                console.log(`   API:     R$ ${saldoTotalAPI.toFixed(2)}`);
                console.log(`   Cassino: ❌ Wallet não encontrado`);
                console.log('');
            }
        }
        
    } catch (error) {
        console.error('❌ Erro:', error.message);
    } finally {
        if (connectionAPI) await connectionAPI.end();
        if (connectionCassino) await connectionCassino.end();
    }
}

async function sincronizarSaldos() {
    let connectionAPI = null;
    let connectionCassino = null;
    
    try {
        connectionAPI = await mysql.createConnection(configAPI);
        connectionCassino = await mysql.createConnection(configCassino);
        
        console.log('🔄 SINCRONIZANDO SALDOS (CASSINO → API)\n');
        
        // Buscar wallets do cassino
        const [wallets] = await connectionCassino.execute(`
            SELECT user_id, balance, balance_bonus, balance_withdrawal,
                   (balance + balance_bonus + balance_withdrawal) as total_balance
            FROM wallets 
            WHERE active = 1 AND (balance > 0 OR balance_bonus > 0 OR balance_withdrawal > 0)
        `);
        
        console.log(`📊 Encontrados ${wallets.length} wallets com saldo no cassino\n`);
        
        for (const wallet of wallets) {
            // Verificar se usuário existe na API
            const [users] = await connectionAPI.execute(`
                SELECT id, username, saldo 
                FROM users 
                WHERE id = ?
            `, [wallet.user_id]);
            
            if (users.length > 0) {
                const user = users[0];
                
                // Atualizar saldos na API baseado no cassino
                await connectionAPI.execute(`
                    UPDATE users 
                    SET saldo = ?, 
                        balance_bonus = ?, 
                        balance_withdrawal = ?,
                        updated_at = NOW()
                    WHERE id = ?
                `, [
                    wallet.balance,
                    wallet.balance_bonus, 
                    wallet.balance_withdrawal,
                    wallet.user_id
                ]);
                
                console.log(`✅ Sincronizado: ${user.username} (ID: ${user.id})`);
                console.log(`   Saldo: R$ ${parseFloat(wallet.balance).toFixed(2)}`);
                console.log(`   Bônus: R$ ${parseFloat(wallet.balance_bonus).toFixed(2)}`);
                console.log(`   Saque: R$ ${parseFloat(wallet.balance_withdrawal).toFixed(2)}`);
                console.log(`   Total: R$ ${parseFloat(wallet.total_balance).toFixed(2)}\n`);
            } else {
                console.log(`⚠️  Usuário ID ${wallet.user_id} não encontrado na API`);
            }
        }
        
        console.log('🎉 Sincronização concluída!');
        
    } catch (error) {
        console.error('❌ Erro na sincronização:', error.message);
    } finally {
        if (connectionAPI) await connectionAPI.end();
        if (connectionCassino) await connectionCassino.end();
    }
}

// Executar baseado no argumento
const acao = process.argv[2];

if (acao === 'sync') {
    sincronizarSaldos();
} else {
    verificarSaldos();
}
