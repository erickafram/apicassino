// Configuração SSL para produção
// Este arquivo deve ser usado se você tiver certificados SSL

const fs = require('fs');
const path = require('path');

function getSSLConfig() {
  try {
    // Caminhos para os certificados SSL
    const keyPath = process.env.SSL_KEY_PATH || './ssl/private.key';
    const certPath = process.env.SSL_CERT_PATH || './ssl/certificate.crt';
    const caPath = process.env.SSL_CA_PATH || './ssl/ca_bundle.crt';

    // Verificar se os arquivos existem
    if (fs.existsSync(keyPath) && fs.existsSync(certPath)) {
      const config = {
        key: fs.readFileSync(keyPath, 'utf8'),
        cert: fs.readFileSync(certPath, 'utf8')
      };

      // Adicionar CA bundle se existir
      if (fs.existsSync(caPath)) {
        config.ca = fs.readFileSync(caPath, 'utf8');
      }

      console.log('✅ Certificados SSL carregados com sucesso');
      return config;
    } else {
      console.log('⚠️  Certificados SSL não encontrados, usando HTTP');
      return null;
    }
  } catch (error) {
    console.error('❌ Erro ao carregar certificados SSL:', error.message);
    return null;
  }
}

module.exports = { getSSLConfig };
