<?php

/**
 * Script para verificar se a rota do webhook está configurada corretamente
 * Execute este script no diretório do cassino
 */

echo "🔍 VERIFICANDO CONFIGURAÇÃO DO WEBHOOK\n";
echo str_repeat("=", 50) . "\n\n";

// 1. Verificar se o arquivo de rotas existe
$routeFiles = [
    'routes/api.php',
    'routes/web.php',
    'app/Http/Controllers/Api/EvergameController.php',
    'app/Http/Controllers/EvergameController.php'
];

echo "1️⃣ VERIFICANDO ARQUIVOS:\n";
foreach ($routeFiles as $file) {
    if (file_exists($file)) {
        echo "   ✅ {$file} - EXISTE\n";
    } else {
        echo "   ❌ {$file} - NÃO ENCONTRADO\n";
    }
}
echo "\n";

// 2. Procurar pela rota do evergame
echo "2️⃣ PROCURANDO ROTAS DO EVERGAME:\n";

$searchFiles = ['routes/api.php', 'routes/web.php'];
foreach ($searchFiles as $file) {
    if (file_exists($file)) {
        $content = file_get_contents($file);
        
        if (strpos($content, 'evergame') !== false || strpos($content, 'Evergame') !== false) {
            echo "   ✅ Rota evergame encontrada em: {$file}\n";
            
            // Extrair linhas que contêm evergame
            $lines = explode("\n", $content);
            foreach ($lines as $lineNum => $line) {
                if (stripos($line, 'evergame') !== false) {
                    echo "      Linha " . ($lineNum + 1) . ": " . trim($line) . "\n";
                }
            }
        } else {
            echo "   ⚠️  Nenhuma rota evergame encontrada em: {$file}\n";
        }
    }
}
echo "\n";

// 3. Verificar controller
echo "3️⃣ VERIFICANDO CONTROLLER:\n";

$controllerPaths = [
    'app/Http/Controllers/Api/EvergameController.php',
    'app/Http/Controllers/EvergameController.php',
    'app/Http/Controllers/GameController.php'
];

foreach ($controllerPaths as $path) {
    if (file_exists($path)) {
        echo "   ✅ Controller encontrado: {$path}\n";
        
        $content = file_get_contents($path);
        
        // Verificar se usa o trait
        if (strpos($content, 'EvergameTrait') !== false) {
            echo "      ✅ Usa EvergameTrait\n";
        } else {
            echo "      ❌ NÃO usa EvergameTrait\n";
        }
        
        // Verificar se tem método webhook
        if (strpos($content, 'webhook') !== false || strpos($content, 'WebhooksEvergame') !== false) {
            echo "      ✅ Tem método webhook\n";
        } else {
            echo "      ❌ NÃO tem método webhook\n";
        }
        
        echo "\n";
    }
}

// 4. Criar exemplo de rota e controller se não existir
echo "4️⃣ EXEMPLO DE CONFIGURAÇÃO NECESSÁRIA:\n\n";

echo "📁 routes/api.php:\n";
echo "```php\n";
echo "Route::post('/evergame/webhook', [EvergameController::class, 'webhook']);\n";
echo "// OU\n";
echo "Route::post('/evergame/webhook', 'EvergameController@webhook');\n";
echo "```\n\n";

echo "📁 app/Http/Controllers/EvergameController.php:\n";
echo "```php\n";
echo "<?php\n";
echo "namespace App\\Http\\Controllers;\n";
echo "use App\\Traits\\Providers\\EvergameTrait;\n";
echo "use Illuminate\\Http\\Request;\n\n";
echo "class EvergameController extends Controller\n";
echo "{\n";
echo "    use EvergameTrait;\n\n";
echo "    public function webhook(Request \$request)\n";
echo "    {\n";
echo "        return self::WebhooksEvergame(\$request);\n";
echo "    }\n";
echo "}\n";
echo "```\n\n";

// 5. Comandos para testar
echo "5️⃣ COMANDOS PARA TESTAR NO SERVIDOR:\n\n";

echo "# Limpar cache do Laravel:\n";
echo "php artisan config:clear\n";
echo "php artisan cache:clear\n";
echo "php artisan route:clear\n";
echo "php artisan route:cache\n\n";

echo "# Listar todas as rotas:\n";
echo "php artisan route:list | grep evergame\n\n";

echo "# Testar webhook diretamente:\n";
echo "curl -X POST http://localhost/api/evergame/webhook \\\n";
echo "     -H 'Content-Type: application/json' \\\n";
echo "     -d '{\"method\":\"GetBalance\",\"userCode\":38}'\n\n";

echo "# Ver logs em tempo real:\n";
echo "tail -f storage/logs/laravel.log\n\n";

// 6. Verificar se o trait foi atualizado
echo "6️⃣ VERIFICAR SE O TRAIT FOI ATUALIZADO:\n\n";

$traitPath = 'app/Traits/Providers/EvergameTrait.php';
if (file_exists($traitPath)) {
    echo "   ✅ Trait existe: {$traitPath}\n";
    
    $content = file_get_contents($traitPath);
    $lines = explode("\n", $content);
    
    echo "   📄 Primeiras 10 linhas do trait:\n";
    for ($i = 0; $i < min(10, count($lines)); $i++) {
        echo "      " . ($i + 1) . ": " . trim($lines[$i]) . "\n";
    }
    
    // Verificar se tem o método GetBalanceInfoEvergame correto
    if (strpos($content, 'GetBalanceInfoEvergame') !== false) {
        echo "\n   ✅ Método GetBalanceInfoEvergame encontrado\n";
        
        // Extrair o método
        $methodStart = strpos($content, 'private static function GetBalanceInfoEvergame');
        if ($methodStart !== false) {
            $methodEnd = strpos($content, '}', strpos($content, '{', $methodStart));
            $method = substr($content, $methodStart, $methodEnd - $methodStart + 1);
            
            echo "   📋 Método atual:\n";
            $methodLines = explode("\n", $method);
            foreach (array_slice($methodLines, 0, 15) as $line) {
                echo "      " . trim($line) . "\n";
            }
        }
    } else {
        echo "\n   ❌ Método GetBalanceInfoEvergame NÃO encontrado\n";
    }
    
} else {
    echo "   ❌ Trait NÃO encontrado: {$traitPath}\n";
    echo "   🚨 ESTE É O PROBLEMA! O trait não existe.\n";
}

echo "\n" . str_repeat("=", 50) . "\n";
echo "EXECUTE ESTE SCRIPT NO SERVIDOR DO CASSINO!\n";
echo str_repeat("=", 50) . "\n";
