<?php

namespace App\Traits\Providers;

use App\Models\Order;
use App\Models\User;
use App\Models\Wallet;
use App\Models\GamesKey;
use App\Models\GameExclusive;
use App\Models\GameFavorite;
use App\Models\GgrgamesModel;
use App\Models\HistoryGame;
use App\Models\Setting;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

trait EvergameTrait
{
    /**
     * Mapear jogos PG Soft
     */
    private static function getGameMapping()
    {
        return [
            // Fortune Series
            'fortune-tiger' => 'fortune-tiger',
            'fortune-ox' => 'fortune-ox', 
            'fortune-mouse' => 'fortune-mouse',
            'fortune-dragon' => 'fortune-dragon',
            'fortune-rabbit' => 'fortune-rabbit',
            'fortune-tree' => 'prosper-ftree',
            
            // Popular Games
            'bikini-paradise' => 'bikine-paradise',
            'jungle-delight' => 'jungle-delight',
            'double-fortune' => 'double-fortune',
            'ganesha-gold' => 'ganesha-gold',
            'dragon-tiger-luck' => 'dragon-tiger-luck',
            'cash-mania' => 'cash-mania',
            'ultimate-striker' => 'ultimate-striker',
            'butterfly-blossom' => 'butterfly-blossom',
            'lucky-clover' => 'lucky-clover',
            'ninja-raccoon' => 'ninja-raccoon',
            'chicky-run' => 'chicky-run',
            'wings-iguazu' => 'wings-iguazu',
            'piggy-gold' => 'piggy-gold',
            'wild-bandito' => 'wild-bandito',
            'zombie-outbreak' => 'zombie-outbreak',
            'majestic-ts' => 'majestic-ts',
            'treasures-aztec' => 'treasures-aztec',
            'thai-river' => 'thai-river',
            'shaolin-soccer' => 'shaolin-soccer',
            'gdn-ice-fire' => 'gdn-ice-fire',
            'rise-apollo' => 'rise-apollo',
            'wild-bounty-sd' => 'wild-bounty-sd',
            'three-cz-pigs' => 'three-cz-pigs',
            
            // Adicionar mais jogos conforme necessário
        ];
    }

    /**
     * Obter saldo disponível por tipo
     */
    private static function getAvailableBalanceByType($wallet, $balanceType = 'balance')
    {
        switch ($balanceType) {
            case 'balance_bonus':
                return $wallet->balance_bonus ?? 0;
            case 'balance_withdrawal':
                return $wallet->balance_withdrawal ?? 0;
            case 'balance':
            default:
                return $wallet->balance ?? 0;
        }
    }

    /**
     * Atualizar saldo por tipo
     */
    private static function updateBalanceByType($wallet, $balanceType, $amount, $operation = 'subtract')
    {
        $currentBalance = self::getAvailableBalanceByType($wallet, $balanceType);
        
        if ($operation === 'subtract') {
            $newBalance = $currentBalance - $amount;
        } else {
            $newBalance = $currentBalance + $amount;
        }

        switch ($balanceType) {
            case 'balance_bonus':
                $wallet->balance_bonus = max(0, $newBalance);
                break;
            case 'balance_withdrawal':
                $wallet->balance_withdrawal = max(0, $newBalance);
                break;
            case 'balance':
            default:
                $wallet->balance = max(0, $newBalance);
                break;
        }

        $wallet->save();
        return $newBalance;
    }

    /**
     * Lançar jogo
     */
    public static function LaunchGameEvergame(Request $request)
    {
        $user = auth()->user();
        if (!$user) {
            return response()->json(['error' => 'User not authenticated'], 401);
        }

        $wallet = Wallet::where('user_id', $user->id)->first();
        if (!$wallet) {
            return response()->json(['error' => 'Wallet not found'], 404);
        }

        $gameMapping = self::getGameMapping();
        $gameCode = $request->input('game_code');
        
        if (!isset($gameMapping[$gameCode])) {
            return response()->json(['error' => 'Game not supported'], 400);
        }

        $apiGameCode = $gameMapping[$gameCode];
        $apiUrl = env('EVERGAME_API_URL', 'https://api.innocodepg.online');

        try {
            $response = Http::timeout(30)->post($apiUrl . '/api/v1/game_launch', [
                'user_id' => $user->id,
                'game_code' => $apiGameCode,
                'balance' => $wallet->balance,
                'currency' => 'BRL',
                'callback_url' => route('evergame.callback'),
                'agent_code' => env('EVERGAME_AGENT_CODE', 'default'),
                'agent_token' => env('EVERGAME_AGENT_TOKEN', 'default'),
            ]);

            if ($response->successful()) {
                $data = $response->json();
                
                // Salvar sessão do jogo
                HistoryGame::create([
                    'user_id' => $user->id,
                    'game' => $gameCode,
                    'game_uuid' => $data['session_id'] ?? uniqid(),
                    'balance_before' => $wallet->balance,
                    'balance_after' => $wallet->balance,
                    'multiplier' => 0,
                    'win' => 0,
                    'bet' => 0,
                    'currency' => 'BRL',
                    'json' => json_encode($data),
                ]);

                return response()->json([
                    'success' => true,
                    'game_url' => $data['game_url'] ?? '',
                    'session_id' => $data['session_id'] ?? '',
                ]);
            }

            return response()->json(['error' => 'Failed to launch game'], 500);

        } catch (\Exception $e) {
            Log::error('Evergame Launch Error: ' . $e->getMessage());
            return response()->json(['error' => 'Internal server error'], 500);
        }
    }

    /**
     * Callback da API
     */
    public static function CallbackEvergame(Request $request)
    {
        try {
            $data = $request->all();
            Log::info('Evergame Callback:', $data);

            $userId = $data['user_id'] ?? null;
            $betAmount = floatval($data['betMoney'] ?? 0);
            $winAmount = floatval($data['winMoney'] ?? 0);
            $balanceType = $data['changeBonus'] ?? 'balance';
            $transactionType = $data['transaction_type'] ?? 'debit_credit';

            if (!$userId) {
                return response()->json(['error' => 'Invalid user_id'], 400);
            }

            $user = User::find($userId);
            if (!$user) {
                return response()->json(['error' => 'User not found'], 404);
            }

            $wallet = Wallet::where('user_id', $userId)->first();
            if (!$wallet) {
                return response()->json(['error' => 'Wallet not found'], 404);
            }

            $balanceBefore = self::getAvailableBalanceByType($wallet, $balanceType);

            // Processar transação
            if ($transactionType === 'debit' || $transactionType === 'debit_credit') {
                // Verificar se tem saldo suficiente
                if ($balanceBefore < $betAmount) {
                    return response()->json([
                        'error' => 'Insufficient balance',
                        'balance' => $balanceBefore
                    ], 400);
                }

                // Debitar aposta
                self::updateBalanceByType($wallet, $balanceType, $betAmount, 'subtract');
            }

            if ($transactionType === 'credit' || $transactionType === 'debit_credit') {
                // Creditar ganho
                if ($winAmount > 0) {
                    self::updateBalanceByType($wallet, $balanceType, $winAmount, 'add');
                }
            }

            $balanceAfter = self::getAvailableBalanceByType($wallet, $balanceType);

            // Criar registro da transação
            Order::create([
                'user_id' => $userId,
                'session_id' => $data['session_id'] ?? uniqid(),
                'transaction_id' => $data['transaction_id'] ?? uniqid(),
                'type' => $transactionType,
                'type_money' => $transactionType === 'debit' ? 0 : 1,
                'amount' => $transactionType === 'debit' ? $betAmount : $winAmount,
                'providers' => 'evergame',
                'game' => $data['gameCode'] ?? 'unknown',
                'game_uuid' => $data['session_id'] ?? uniqid(),
                'round_id' => $data['round_id'] ?? uniqid(),
                'currency' => $data['currency'] ?? 'BRL',
                'balance_before' => $balanceBefore,
                'balance_after' => $balanceAfter,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            // Atualizar histórico do jogo
            HistoryGame::create([
                'user_id' => $userId,
                'game' => $data['gameCode'] ?? 'unknown',
                'game_uuid' => $data['session_id'] ?? uniqid(),
                'balance_before' => $balanceBefore,
                'balance_after' => $balanceAfter,
                'multiplier' => $winAmount > 0 ? ($winAmount / max($betAmount, 1)) : 0,
                'win' => $winAmount,
                'bet' => $betAmount,
                'currency' => $data['currency'] ?? 'BRL',
                'json' => json_encode($data),
            ]);

            return response()->json([
                'success' => true,
                'balance' => $balanceAfter,
                'currency' => $data['currency'] ?? 'BRL',
                'transaction_id' => $data['transaction_id'] ?? uniqid(),
            ]);

        } catch (\Exception $e) {
            Log::error('Evergame Callback Error: ' . $e->getMessage());
            return response()->json(['error' => 'Internal server error'], 500);
        }
    }

    /**
     * Obter informações do jogo
     */
    public static function GetGameInfoEvergame(Request $request)
    {
        $gameCode = $request->input('game_code');
        $gameMapping = self::getGameMapping();

        if (!isset($gameMapping[$gameCode])) {
            return response()->json(['error' => 'Game not supported'], 400);
        }

        return response()->json([
            'success' => true,
            'game_code' => $gameCode,
            'api_game_code' => $gameMapping[$gameCode],
            'provider' => 'evergame',
            'status' => 'active',
        ]);
    }
}
