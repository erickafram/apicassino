#!/bin/bash

# Script para corrigir todas as funções attsaldobyatk
# Evita erro de NaN no MySQL

echo "🔧 Iniciando correção de todas as funções attsaldobyatk..."

# Lista de arquivos para corrigir
files=(
    "src/functions/majestic-ts/majestictsfunctions.ts"
    "src/functions/jogo-jean/jogojeanfunctions.ts"
    "src/functions/zombie-outbreak/zombieoutbreakfunctions.ts"
    "src/functions/bikini-paradise/bikiniparadisefunctions.ts"
    "src/functions/btrfly-blossom/butterflyblossomfunctions.ts"
    "src/functions/cash-mania/cashmaniafunctions.ts"
    "src/functions/chicky-run/chickyrunfunctions.ts"
    "src/functions/double-fortune/doublefortunefunctions.ts"
    "src/functions/dragon-tiger-luck/dragontigerluckfunctions.ts"
    "src/functions/fortune-dragon/fortunedragonfunctions.ts"
    "src/functions/fortune-mouse/fortunemousefunctions.ts"
    "src/functions/fortune-rabbit/fortunerabbitfunctions.ts"
    "src/functions/ganesha-gold/ganeshagoldfunctions.ts"
    "src/functions/gdn-ice-fire/icefirefunctions.ts"
    "src/functions/jungle-delight/jungledelightfunctions.ts"
    "src/functions/lucky-clover/luckycloverfunctions.ts"
    "src/functions/ninja-raccoon/raccoonfunctions.ts"
    "src/functions/piggy-gold/piggygoldfunctions.ts"
    "src/functions/prosper-ftree/prosperftreefunctions.ts"
    "src/functions/rise-apollo/riseapollofunctions.ts"
    "src/functions/thai-river/riverfunctions.ts"
    "src/functions/three-cz-pigs/threeczpigsfunctions.ts"
    "src/functions/treasures-aztec/aztecfunctions.ts"
    "src/functions/ultimate-striker/ultimatestrikerfunctions.ts"
    "src/functions/wild-ape/wildapefunctions.ts"
    "src/functions/wings-iguazu/wingsiguazufunctions.ts"
)

# Contador de arquivos processados
total_files=${#files[@]}
processed=0
corrected=0
not_found=0

for file in "${files[@]}"; do
    ((processed++))
    echo "📝 [$processed/$total_files] Processando: $file"
    
    if [ -f "$file" ]; then
        # Fazer backup do arquivo original
        cp "$file" "$file.backup"
        
        # Usar sed para substituir a função problemática
        sed -i '/async attsaldobyatk(atk: string, novosaldo: number) {/,/},/{
            /async attsaldobyatk(atk: string, novosaldo: number) {/c\
  async attsaldobyatk(atk: string, novosaldo: number) {\
    // SALDO É GERENCIADO PELO CASSINO - NÃO ATUALIZAR LOCALMENTE\
    // Apenas validar se o valor não é NaN para evitar erros\
    if (isNaN(novosaldo)) {\
      console.error(`ERRO: Tentativa de atualizar saldo com valor NaN para ATK: ${atk}`)\
      return null\
    }\
    \
    console.log(`INFO: Saldo calculado para ATK ${atk}: ${novosaldo} (não atualizado localmente - gerenciado pelo cassino)`)\
    return { affectedRows: 1 } // Simular sucesso sem fazer update\
  },
            /const res = await promisePool/d
            /return res\[0\]/d
        }' "$file"
        
        # Verificar se a substituição foi feita
        if grep -q "SALDO É GERENCIADO PELO CASSINO" "$file"; then
            echo "✅ Arquivo corrigido: $file"
            ((corrected++))
            # Remover backup se correção foi bem-sucedida
            rm "$file.backup"
        else
            echo "⚠️  Correção pode não ter funcionado em: $file"
            # Restaurar backup se algo deu errado
            mv "$file.backup" "$file"
        fi
    else
        echo "❌ Arquivo não encontrado: $file"
        ((not_found++))
    fi
done

echo ""
echo "🎉 Correção concluída!"
echo "📊 Estatísticas:"
echo "   - Total de arquivos: $total_files"
echo "   - Arquivos corrigidos: $corrected"
echo "   - Arquivos não encontrados: $not_found"
echo ""
echo "📋 Próximos passos:"
echo "1. Recompilar o projeto: npm run build"
echo "2. Reiniciar o PM2: pm2 restart indexprod"
echo "3. Monitorar logs: pm2 logs indexprod --lines 0"
