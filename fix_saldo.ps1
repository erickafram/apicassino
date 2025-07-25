# Script para corrigir todas as funções attsaldobyatk
Write-Host "Iniciando correção..." -ForegroundColor Yellow

$files = @(
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

$corrected = 0
$notFound = 0

foreach ($file in $files) {
    Write-Host "Processando: $file"
    
    if (Test-Path $file) {
        $content = Get-Content $file -Raw
        
        if ($content -match "UPDATE users SET saldo") {
            Copy-Item $file "$file.backup"
            
            $newFunc = "  async attsaldobyatk(atk: string, novosaldo: number) {`n    // SALDO É GERENCIADO PELO CASSINO - NÃO ATUALIZAR LOCALMENTE`n    if (isNaN(novosaldo)) {`n      console.error(`"ERRO: Tentativa de atualizar saldo com valor NaN para ATK: `" + atk)`n      return null`n    }`n    console.log(`"INFO: Saldo calculado para ATK `" + atk + `": `" + novosaldo + `" (não atualizado localmente)`")`n    return { affectedRows: 1 }`n  },"

            $pattern = "async attsaldobyatk\(atk: string, novosaldo: number\) \{\s*const res = await promisePool\.query<ResultSetHeader>\(`UPDATE users SET saldo = '\$\{novosaldo\}' WHERE atk= '\$\{atk\}'\`\);\s*return res\[0\];\s*\},"
            $content = $content -replace $pattern, $newFunc
            
            Set-Content $file $content -Encoding UTF8
            
            $verify = Get-Content $file -Raw
            if ($verify -match "SALDO É GERENCIADO PELO CASSINO") {
                Write-Host "CORRIGIDO: $file" -ForegroundColor Green
                Remove-Item "$file.backup"
                $corrected++
            } else {
                Write-Host "FALHOU: $file" -ForegroundColor Red
                Move-Item "$file.backup" $file -Force
            }
        } else {
            Write-Host "SEM PADRÃO: $file" -ForegroundColor Yellow
        }
    } else {
        Write-Host "NÃO ENCONTRADO: $file" -ForegroundColor Red
        $notFound++
    }
}

Write-Host ""
Write-Host "CONCLUÍDO!" -ForegroundColor Green
Write-Host "Arquivos corrigidos: $corrected"
Write-Host "Arquivos não encontrados: $notFound"
Write-Host ""
Write-Host "Próximos passos:"
Write-Host "1. npm run build"
Write-Host "2. pm2 restart indexprod"
