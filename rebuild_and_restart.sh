#!/bin/bash

# Script para recompilar e reiniciar a API

echo "🔄 Recompilando código TypeScript..."
npm run build

echo "🔄 Parando processo PM2..."
pm2 stop indexprod

echo "🔄 Reiniciando processo PM2..."
pm2 start indexprod

echo "📊 Status do PM2:"
pm2 status

echo "📋 Últimos logs:"
pm2 logs indexprod --lines 5

echo "✅ Processo concluído!"
