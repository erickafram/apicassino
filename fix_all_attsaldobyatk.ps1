# Script para corrigir todas as funções attsaldobyatk
# Evita erro de NaN no MySQL

$functionFiles = @(
    "src/functions/majestic-ts/majestictsfunctions.ts",
    "src/functions/jogo-jean/jogojeanfunctions.ts", 
    "src/functions/zombie-outbreak/zombieoutbreakfunctions.ts",
    "src/functions/bikini-paradise/bikiniparadisefunctions.ts",
    "src/functions/btrfly-blossom/butterflyblossomfunctions.ts",
    "src/functions/cash-mania/cashmaniafunctions.ts",
    "src/functions/chicky-run/chickyrunfunctions.ts",
    "src/functions/double-fortune/doublefortunefunctions.ts",
    "src/functions/dragon-tiger-luck/dragontigerluckfunctions.ts",
    "src/functions/fortune-dragon/fortunedragonfunctions.ts",
    "src/functions/fortune-mouse/fortunemousefunctions.ts",
    "src/functions/fortune-rabbit/fortunerabbitfunctions.ts",
    "src/functions/ganesha-gold/ganeshagoldfunctions.ts",
    "src/functions/gdn-ice-fire/icefirefunctions.ts",
    "src/functions/jungle-delight/jungledelightfunctions.ts",
    "src/functions/lucky-clover/luckycloverfunctions.ts",
    "src/functions/ninja-raccoon/raccoonfunctions.ts",
    "src/functions/piggy-gold/piggygoldfunctions.ts",
    "src/functions/prosper-ftree/prosperftreefunctions.ts",
    "src/functions/rise-apollo/riseapollofunctions.ts",
    "src/functions/thai-river/riverfunctions.ts",
    "src/functions/three-cz-pigs/threeczpigsfunctions.ts",
    "src/functions/treasures-aztec/aztecfunctions.ts",
    "src/functions/ultimate-striker/ultimatestrikerfunctions.ts",
    "src/functions/wild-ape/wildapefunctions.ts",
    "src/functions/wings-iguazu/wingsiguazufunctions.ts"
)

$oldPattern = @"
async attsaldobyatk\(atk: string, novosaldo: number\) \{
    const res = await promisePool\.query<ResultSetHeader>\(`UPDATE users SET saldo = '\$\{novosaldo\}' WHERE atk= '\$\{atk\}'`\);
    return res\[0\];
  \},
"@

$newReplacement = @"
async attsaldobyatk(atk: string, novosaldo: number) {
    // SALDO É GERENCIADO PELO CASSINO - NÃO ATUALIZAR LOCALMENTE
    // Apenas validar se o valor não é NaN para evitar erros
    if (isNaN(novosaldo)) {
      console.error(`ERRO: Tentativa de atualizar saldo com valor NaN para ATK: ${atk}`)
      return null
    }
    
    console.log(`INFO: Saldo calculado para ATK ${atk}: ${novosaldo} (não atualizado localmente - gerenciado pelo cassino)`)
    return { affectedRows: 1 } // Simular sucesso sem fazer update
  },
"@

Write-Host "🔧 Iniciando correção de todas as funções attsaldobyatk..." -ForegroundColor Yellow

foreach ($file in $functionFiles) {
    if (Test-Path $file) {
        Write-Host "📝 Corrigindo: $file" -ForegroundColor Green
        
        $content = Get-Content $file -Raw
        
        # Padrão mais flexível para diferentes formatações
        $patterns = @(
            "async attsaldobyatk\(atk: string, novosaldo: number\) \{\s*const res = await promisePool\.query<ResultSetHeader>\(`UPDATE users SET saldo = '\$\{novosaldo\}' WHERE atk= '\$\{atk\}'`\);\s*return res\[0\];\s*\},"
            "async attsaldobyatk\(atk: string, novosaldo: number\) \{\s*const res = await promisePool\.query<ResultSetHeader>\(\s*`UPDATE users SET saldo = '\$\{novosaldo\}' WHERE atk= '\$\{atk\}'`,\s*\)\s*return res\[0\]\s*\},"
        )
        
        $updated = $false
        foreach ($pattern in $patterns) {
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $newReplacement
                $updated = $true
                break
            }
        }
        
        if ($updated) {
            Set-Content $file $content -Encoding UTF8
            Write-Host "✅ Arquivo corrigido: $file" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Padrão não encontrado em: $file" -ForegroundColor Yellow
        }
    } else {
        Write-Host "❌ Arquivo não encontrado: $file" -ForegroundColor Red
    }
}

Write-Host "🎉 Correção concluída!" -ForegroundColor Green
Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Recompilar o projeto: npm run build" -ForegroundColor White
Write-Host "2. Reiniciar o PM2: pm2 restart indexprod" -ForegroundColor White
Write-Host "3. Monitorar logs: pm2 logs indexprod --lines 0" -ForegroundColor White
