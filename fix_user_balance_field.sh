#!/bin/bash

# Script para corrigir o campo de saldo em todos os controllers
# Substitui checkuserbalance.data.balance por checkuserbalance.data.user_balance

echo "🔧 CORRIGINDO CAMPO DE SALDO EM TODOS OS CONTROLLERS"
echo "Substituindo .data.balance por .data.user_balance"
echo ""

# Contador de arquivos corrigidos
corrected=0

# Lista de arquivos TypeScript para corrigir
files=(
    "src/controllers/wild-bounty-sd/wildbountrysd.ts"
    "src/controllers/three-cz-pigs/threeczpigs.ts"
    "src/controllers/treasures-aztec/treasuresaztec.ts"
    "src/controllers/shaolin-soccer/shaolinsoccer.ts"
    "src/controllers/gdn-ice-fire/gdnicefire.ts"
    "src/controllers/prosper-ftree/prosperftree.ts"
    "src/controllers/bikini-paradise/bikiniparadise.ts"
    "src/controllers/majestic-ts/majesticts.ts"
    "src/controllers/CONTROLLER QUEBRA DE SPIN/treasuresaztec.ts"
    "src/controllers/fortune-rabbit/fortunerabbit.ts"
    "src/controllers/fortune-dragon/fortunedragon.ts"
    "src/controllers/fortune-mouse/fortunemouse.ts"
    "src/controllers/fortune-ox/fortuneox.ts"
    "src/controllers/ganesha-gold/ganeshagold.ts"
    "src/controllers/piggy-gold/piggygold.ts"
    "src/controllers/wild-bandito/wildbandito.ts"
    "src/controllers/zombie-outbreak/zombieoutbreak.ts"
    "src/controllers/ninja-raccoon/ninjaraccoon.ts"
    "src/controllers/lucky-clover/luckyclover.ts"
    "src/controllers/wings-iguazu/wingsiguazu.ts"
    "src/controllers/rise-apollo/riseapollo.ts"
    "src/controllers/btrfly-blossom/butterfly-blossom.ts"
    "src/controllers/jogo-jean/jogojean.ts"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "📝 Verificando: $file"
        
        # Verificar se o arquivo contém o padrão a ser corrigido
        if grep -q "checkuserbalance\.data\.balance" "$file"; then
            echo "   🔧 Corrigindo campo de saldo..."
            
            # Fazer backup
            cp "$file" "$file.backup"
            
            # Substituir o campo
            sed -i 's/checkuserbalance\.data\.balance/checkuserbalance.data.user_balance/g' "$file"
            
            # Verificar se a correção foi aplicada
            if grep -q "checkuserbalance\.data\.user_balance" "$file"; then
                echo "   ✅ CORRIGIDO: $file"
                rm "$file.backup"
                ((corrected++))
            else
                echo "   ❌ FALHOU: $file"
                mv "$file.backup" "$file"
            fi
        else
            echo "   ✅ JÁ CORRETO: $file"
        fi
    else
        echo "   ⚠️  ARQUIVO NÃO ENCONTRADO: $file"
    fi
    echo ""
done

echo "🎉 CORREÇÃO CONCLUÍDA!"
echo "📊 Arquivos corrigidos: $corrected"
echo ""
echo "🔄 PRÓXIMOS PASSOS:"
echo "1. Execute: npm run build"
echo "2. Execute: pm2 restart indexprod"
echo "3. Teste o jogo novamente"
