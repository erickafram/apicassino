const axios = require('axios');

// Configuração do teste
const config = {
    // Substitua pela URL real do seu cassino
    cassinoUrl: 'http://localhost', // ou a URL do cassino
    userCode: '38', // Username do usuário
};

async function testarEndpointSaldo() {
    console.log('🔍 TESTANDO ENDPOINT gold_api/user_balance\n');
    
    try {
        // Teste 1: Endpoint direto
        console.log('📡 Testando endpoint direto...');
        const response = await axios({
            method: 'POST',
            url: `${config.cassinoUrl}/gold_api/user_balance`,
            headers: {
                'Content-Type': 'application/json',
            },
            data: {
                user_code: config.userCode,
            },
            timeout: 10000
        });
        
        console.log('✅ Resposta do endpoint:');
        console.log('Status:', response.status);
        console.log('Data:', response.data);
        
        if (response.data.balance) {
            console.log(`💰 Saldo retornado: R$ ${response.data.balance}`);
        }
        
    } catch (error) {
        console.log('❌ Erro ao testar endpoint:');
        
        if (error.response) {
            console.log('Status:', error.response.status);
            console.log('Data:', error.response.data);
        } else if (error.request) {
            console.log('Erro de rede:', error.message);
            console.log('URL testada:', `${config.cassinoUrl}/gold_api/user_balance`);
        } else {
            console.log('Erro:', error.message);
        }
    }
    
    // Teste 2: Verificar se o endpoint existe
    console.log('\n🔍 Testando se o endpoint existe...');
    try {
        const response = await axios({
            method: 'GET',
            url: `${config.cassinoUrl}/gold_api/user_balance`,
            timeout: 5000
        });
        console.log('✅ Endpoint responde a GET');
    } catch (error) {
        if (error.response && error.response.status === 405) {
            console.log('✅ Endpoint existe mas só aceita POST (correto)');
        } else {
            console.log('❌ Endpoint pode não existir ou estar inacessível');
        }
    }
}

// Executar teste
testarEndpointSaldo();
