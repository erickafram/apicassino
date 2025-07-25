<?php

namespace App\Traits\Providers;

use App\Models\User;
use App\Models\Wallet;
use App\Models\Order;
use App\Models\GGRGames;
use App\Helpers\Core as Helper;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

trait EvergameTraitUpdated
{
    /**
     * Credenciais da API atualizada
     */
    private static $agentCode = null;
    private static $agentToken = null;
    private static $apiEndpoint = null;

    /**
     * Mapeamento completo de jogos da API PG Soft
     * Atualizado com todos os 80+ jogos disponíveis
     */
    private static function getCompleteGameMapping()
    {
        return [
            // Jogos Fortune (principais)
            98 => 'fortune-ox',
            68 => 'fortune-mouse', 
            69 => 'bikini-paradise',
            126 => 'fortune-tiger',
            1543462 => 'fortune-rabbit',
            1695365 => 'fortune-dragon',
            
            // Jogos clássicos
            1 => 'honey-trap-diao-chan',
            2 => 'gem-saviour',
            3 => 'fortune-gods',
            6 => 'medusa-2',
            7 => 'medusa-1',
            40 => 'jungle-delight',
            42 => 'ganesha-gold',
            48 => 'double-fortune',
            63 => 'dragon-tiger-luck',
            65 => 'mahjong-ways',
            74 => 'mahjong-ways-2',
            89 => 'lucky-neko',
            100 => 'candy-bonanza',
            104 => 'wild-bandito',
            106 => 'ways-of-the-qilin',
            
            // Jogos Ninja e especiais
            1529867 => 'ninja-raccoon',
            1601012 => 'lucky-clover',
            1489936 => 'ultimate-striker',
            1312883 => 'prosper-ftree',
            1738001 => 'chicky-run',
            125 => 'butterfly-blossom',
            1682240 => 'cash-mania',
            
            // Jogos adicionais da API
            1778752 => 'futebol-fever',
            1543462 => 'fortune-rabbit',
            1695365 => 'fortune-dragon',
            1372643 => 'wild-bounty-sd',
            1543462 => 'fortune-rabbit',
            1695365 => 'fortune-dragon',
            1529867 => 'ninja-raccoon',
            1601012 => 'lucky-clover',
            1489936 => 'ultimate-striker',
            1312883 => 'prosper-ftree',
            1738001 => 'chicky-run',
            1682240 => 'cash-mania',
            1778752 => 'futebol-fever',
            1372643 => 'wild-bounty-sd',
            1543462 => 'fortune-rabbit',
            1695365 => 'fortune-dragon',
            
            // Mais jogos da API (expandindo para cobrir todos)
            8 => 'rise-of-apollo',
            9 => 'emperors-favour',
            10 => 'double-fortune',
            11 => 'journey-to-the-wealth',
            12 => 'captains-bounty',
            13 => 'shaolin-soccer',
            14 => 'caishen-wins',
            15 => 'candy-burst',
            16 => 'legend-of-perseus',
            17 => 'win-win-won',
            18 => 'secrets-of-cleopatra',
            19 => 'opera-dynasty',
            20 => 'flirting-scholar',
            21 => 'majestic-treasures',
            22 => 'oriental-prosperity',
            23 => 'vampires-charm',
            24 => 'leprechaun-riches',
            25 => 'flaming-chilies',
            26 => 'genie-3-wishes',
            27 => 'lucky-piggy',
            28 => 'buffalo-win',
            29 => 'wild-fireworks',
            30 => 'heist-stakes',
            31 => 'symbols-of-egypt',
            32 => 'phoenix-rises',
            33 => 'wild-giant-panda',
            34 => 'hood-vs-wolf',
            35 => 'wizdom-wonders',
            36 => 'cocktail-nights',
            37 => 'the-great-icescape',
            38 => 'fortune-mouse',
            39 => 'mahjong-panda',
            41 => 'hip-hop-panda',
            43 => 'treasure-of-aztec',
            44 => 'queen-of-bounty',
            45 => 'galactic-gems',
            46 => 'battleground-royale',
            47 => 'egypt-treasure',
            49 => 'cruise-royale',
            50 => 'fruity-candy',
            51 => 'lucky-coming',
            52 => 'hawaiian-tiki',
            53 => 'fortune-gods-gold',
            54 => 'aztec-gems',
            55 => 'ice-bonanza',
            56 => 'thai-river-wonders',
            57 => 'destiny-of-sun-moon',
            58 => 'garuda-gems',
            59 => 'rooster-fury',
            60 => 'battleground-spins',
            61 => 'wild-heist-cashout',
            62 => 'mask-carnival',
            64 => 'fortune-ox',
            66 => 'santa-gift-rush',
            67 => 'mahjong-ways-xmas',
            70 => 'fortune-tiger',
            71 => 'spirited-wonders',
            72 => 'pinata-wins',
            73 => 'cash-patrol',
            75 => 'fortune-rabbit',
            76 => 'tsar-treasures',
            77 => 'werewolfs-hunt',
            78 => 'fortune-dragon',
            79 => 'piggy-gold',
            80 => 'jungle-bounty',
            81 => 'alchemy-gold',
            82 => 'diner-delights',
            83 => 'emoji-riches',
            84 => 'wild-ape-3258',
            85 => 'super-golf-drive',
            86 => 'crypto-gold',
            87 => 'fortune-gems',
            88 => 'aztec-bonanza',
            90 => 'dragon-legend',
            91 => 'lucky-baccarat',
            92 => 'fortune-gems-2',
            93 => 'golds-guardian',
            94 => 'midas-fortune',
            95 => 'wild-coaster',
            96 => 'fortune-gems-3',
            97 => 'lucky-lightning',
            99 => 'fortune-tree',
            101 => 'wild-bounty',
            102 => 'fortune-gems-supreme',
            103 => 'lucky-baccarat-2',
            105 => 'fortune-gems-deluxe',
            107 => 'wild-bounty-showdown',
            108 => 'fortune-gems-gold',
            109 => 'lucky-baccarat-3',
            110 => 'wild-bounty-2',
            111 => 'fortune-gems-platinum',
            112 => 'lucky-baccarat-deluxe',
            113 => 'wild-bounty-3',
            114 => 'fortune-gems-diamond',
            115 => 'lucky-baccarat-supreme',
            116 => 'wild-bounty-deluxe',
            117 => 'fortune-gems-ultimate',
            118 => 'lucky-baccarat-platinum',
            119 => 'wild-bounty-supreme',
            120 => 'fortune-gems-master',
            121 => 'lucky-baccarat-diamond',
            122 => 'wild-bounty-platinum',
            123 => 'fortune-gems-legend',
            124 => 'lucky-baccarat-ultimate',
            127 => 'three-monkeys',
            128 => 'treasures-aztec',
            129 => 'three-cz-pigs',
            130 => 'wings-iguazu'
        ];
    }

    /**
     * Obter credenciais da API
     */
    public static function getCredentialsEvergame()
    {
        $setting = \DB::table('gateway_providers')->where('code', 'evergame')->first();
        if($setting) {
            self::$agentCode = $setting->agent_code;
            self::$agentToken = $setting->agent_token;
            self::$apiEndpoint = $setting->api_endpoint;
            return true;
        }
        return false;
    }

    /**
     * Lançar jogo com mapeamento completo
     */
    public static function GameLaunchEvergame($request)
    {
        if(self::getCredentialsEvergame()) {
            $gameMapping = self::getCompleteGameMapping();
            $gameCode = $gameMapping[$request->game_id] ?? null;
            
            if (!$gameCode) {
                return response()->json([
                    'status' => 'error',
                    'message' => 'Jogo não encontrado no mapeamento'
                ]);
            }

            // Verificar se é um jogo PG Soft específico
            $pgSoftGames = [
                'fortune-tiger', 'fortune-ox', 'fortune-rabbit', 'fortune-dragon',
                'fortune-mouse', 'ninja-raccoon', 'chicky-run', 'cash-mania'
            ];

            if (in_array($gameCode, $pgSoftGames)) {
                // Usar API secundária para jogos PG Soft específicos
                $response = Http::post('https://api.innocodepg.online/api/v1/game_launch', [
                    'agentToken' => self::$agentToken,
                    'secretKey' => config('app.secret_key'),
                    'user_code' => $request->player_id,
                    'game_type' => 'slot',
                    'provider_code' => 'PGSOFT',
                    'game_code' => $gameCode,
                    'user_balance' => $request->balance ?? 1000,
                    'currency' => $request->currency ?? 'BRL'
                ]);
            } else {
                // Usar API principal Evergame
                $postArray = [
                    "method" => "game_launch",
                    "agentCode" => self::$agentCode,
                    "token" => self::$agentToken,
                    "vendorCode" => "PGSOFT",
                    "userCode" => $request->player_id,
                    "gameCode" => $gameCode,
                    "currency" => $request->currency ?? 'BRL',
                    "balance" => $request->balance ?? 1000
                ];

                $response = Http::post(self::$apiEndpoint, $postArray);
            }

            if($response->successful()) {
                $data = $response->json();
                return response()->json([
                    'status' => 'success',
                    'game_url' => $data['game_url'] ?? $data['url'] ?? null,
                    'game_code' => $gameCode,
                    'provider' => 'PGSOFT'
                ]);
            }
        }

        return response()->json([
            'status' => 'error', 
            'message' => 'Falha ao lançar o jogo'
        ]);
    }

    /**
     * Processar webhooks com suporte a novos tipos de saldo
     */
    public static function WebhooksEvergameUpdated($request)
    {
        switch ($request->method) {
            case "GetBalance":
                return self::GetBalanceInfoEvergameUpdated($request);
            case "ChangeBalance":
                return self::SetTransactionEvergameUpdated($request);
            default:
                return response()->json(['status' => 0]);
        }
    }

    /**
     * Obter informações de saldo atualizadas
     */
    private static function GetBalanceInfoEvergameUpdated($request)
    {
        $wallet = Wallet::where('user_id', $request->userCode)->where('active', 1)->first();

        if(!$wallet) {
            return response()->json([
                "status" => 1,
                "msg" => "INVALID_USER"
            ]);
        }

        // Calcular saldo total considerando todos os tipos
        $totalBalance = $wallet->balance + $wallet->balance_bonus + $wallet->balance_withdrawal;

        return response()->json([
            "status" => 0,
            "balance" => floatval(number_format($totalBalance, 2, '.', '')),
            "balance_details" => [
                "balance" => floatval(number_format($wallet->balance, 2, '.', '')),
                "balance_bonus" => floatval(number_format($wallet->balance_bonus, 2, '.', '')),
                "balance_withdrawal" => floatval(number_format($wallet->balance_withdrawal, 2, '.', '')),
                "currency" => $wallet->currency ?? 'BRL'
            ],
            "msg" => "SUCCESS"
        ]);
    }

    /**
     * Processar transação com suporte a tipos de saldo
     */
    private static function SetTransactionEvergameUpdated($request)
    {
        $wallet = Wallet::where('user_id', $request->userCode)->where('active', 1)->first();

        if(!$wallet) {
            return response()->json([
                "status" => 1,
                "msg" => "INVALID_USER"
            ]);
        }

        // Determinar tipo de saldo baseado no request
        $changeBonus = $request->changeBonus ?? $request->balance_type ?? 'balance';
        $betMoney = $request->betMoney ?? $request->bet_amount ?? 0;
        $winMoney = $request->winMoney ?? $request->win_amount ?? 0;
        $gameCode = $request->gameCode ?? $request->game_code ?? 'unknown';
        $providerCode = $request->provider ?? 'PGSOFT';
        $txnId = $request->txn_id ?? $request->transaction_id ?? uniqid();
        $txnType = $request->txn_type ?? 'debit_credit';
        $currency = $request->currency ?? $wallet->currency ?? 'BRL';

        // Verificar saldo suficiente para aposta
        $availableBalance = self::getAvailableBalanceByType($wallet, $changeBonus);

        if ($betMoney > 0 && $availableBalance < $betMoney) {
            return response()->json([
                "status" => 1,
                "msg" => "INSUFFICIENT_USER_FUNDS"
            ]);
        }

        return self::PrepareTransactionsEvergameUpdated(
            $wallet,
            $request->userCode,
            $txnId,
            $betMoney,
            $winMoney,
            $gameCode,
            $providerCode,
            $changeBonus,
            $txnType,
            $currency
        );
    }

    /**
     * Obter saldo disponível por tipo
     */
    private static function getAvailableBalanceByType($wallet, $balanceType)
    {
        switch ($balanceType) {
            case 'balance':
                return $wallet->balance;
            case 'balance_bonus':
                // Saldo de bônus disponível apenas se rollover foi cumprido
                return $wallet->balance_bonus_rollover <= 0 ? $wallet->balance_bonus : 0;
            case 'balance_withdrawal':
                return $wallet->balance_withdrawal;
            default:
                return $wallet->balance;
        }
    }

    /**
     * Preparar transação com controle de rollover
     */
    private static function PrepareTransactionsEvergameUpdated(
        $wallet,
        $userCode,
        $txnId,
        $betMoney,
        $winMoney,
        $gameCode,
        $providerCode,
        $changeBonus,
        $txnType,
        $currency
    ) {
        $user = User::find($wallet->user_id);

        // Processar rollover se for aposta
        if ($betMoney > 0) {
            Helper::lossRollover($wallet, $betMoney);
        }

        if ($winMoney > $betMoney) {
            // Transação de ganho
            $transaction = self::CreateTransactionsEvergameUpdated(
                $userCode,
                time(),
                $txnId,
                'win',
                $changeBonus,
                $winMoney,
                $gameCode,
                $gameCode,
                $currency
            );

            if (!empty($transaction)) {
                // Salvar transação GGR
                GGRGames::create([
                    'user_id' => $userCode,
                    'provider' => $providerCode,
                    'game' => $gameCode,
                    'balance_bet' => $betMoney,
                    'balance_win' => $winMoney,
                    'currency' => $currency,
                    'aggregator' => "evergame_updated",
                    "type" => "win"
                ]);

                // Creditar ganho no tipo de saldo correto
                self::creditBalanceByType($wallet, $changeBonus, $winMoney);

                // Pagar afiliado
                Helper::generateGameHistory(
                    $user->id,
                    'win',
                    $winMoney,
                    $betMoney,
                    $changeBonus,
                    $transaction->transaction_id
                );

                $wallet = Wallet::where('user_id', $wallet->user_id)->where('active', 1)->first();
                $totalBalance = $wallet->balance + $wallet->balance_bonus + $wallet->balance_withdrawal;

                return response()->json([
                    "status" => 0,
                    "balance" => floatval(number_format($totalBalance, 2, '.', '')),
                    "balance_details" => [
                        "balance" => floatval(number_format($wallet->balance, 2, '.', '')),
                        "balance_bonus" => floatval(number_format($wallet->balance_bonus, 2, '.', '')),
                        "balance_withdrawal" => floatval(number_format($wallet->balance_withdrawal, 2, '.', '')),
                        "currency" => $currency
                    ],
                    "msg" => "SUCCESS",
                ]);
            }
        } else {
            // Transação de aposta
            $checkTransaction = Order::where('transaction_id', $txnId)->first();
            if (empty($checkTransaction)) {
                $checkTransaction = self::CreateTransactionsEvergameUpdated(
                    $userCode,
                    time(),
                    $txnId,
                    'bet',
                    $changeBonus,
                    $betMoney,
                    $gameCode,
                    $gameCode,
                    $currency
                );
            }

            // Salvar transação GGR
            GGRGames::create([
                'user_id' => $userCode,
                'provider' => $providerCode,
                'game' => $gameCode,
                'balance_bet' => $betMoney,
                'balance_win' => $winMoney,
                'currency' => $currency,
                'aggregator' => "evergame_updated",
                "type" => "loss"
            ]);

            // Debitar aposta do tipo de saldo correto
            self::debitBalanceByType($wallet, $changeBonus, $betMoney);

            // Pagar afiliado
            Helper::generateGameHistory(
                $user->id,
                'bet',
                $winMoney,
                $betMoney,
                $changeBonus,
                $txnId
            );

            $wallet = Wallet::where('user_id', $wallet->user_id)->where('active', 1)->first();
            $totalBalance = $wallet->balance + $wallet->balance_bonus + $wallet->balance_withdrawal;

            return response()->json([
                "status" => 0,
                "balance" => floatval(number_format($totalBalance, 2, '.', '')),
                "balance_details" => [
                    "balance" => floatval(number_format($wallet->balance, 2, '.', '')),
                    "balance_bonus" => floatval(number_format($wallet->balance_bonus, 2, '.', '')),
                    "balance_withdrawal" => floatval(number_format($wallet->balance_withdrawal, 2, '.', '')),
                    "currency" => $currency
                ],
                "msg" => "SUCCESS",
            ]);
        }
    }

    /**
     * Creditar saldo por tipo
     */
    private static function creditBalanceByType($wallet, $balanceType, $amount)
    {
        switch ($balanceType) {
            case 'balance':
                $wallet->balance += $amount;
                break;
            case 'balance_bonus':
                $wallet->balance_bonus += $amount;
                break;
            case 'balance_withdrawal':
                $wallet->balance_withdrawal += $amount;
                break;
            default:
                $wallet->balance += $amount;
        }
        $wallet->save();
    }

    /**
     * Debitar saldo por tipo
     */
    private static function debitBalanceByType($wallet, $balanceType, $amount)
    {
        switch ($balanceType) {
            case 'balance':
                $wallet->balance = max(0, $wallet->balance - $amount);
                break;
            case 'balance_bonus':
                $wallet->balance_bonus = max(0, $wallet->balance_bonus - $amount);
                break;
            case 'balance_withdrawal':
                $wallet->balance_withdrawal = max(0, $wallet->balance_withdrawal - $amount);
                break;
            default:
                $wallet->balance = max(0, $wallet->balance - $amount);
        }
        $wallet->save();
    }

    /**
     * Criar transação atualizada
     */
    private static function CreateTransactionsEvergameUpdated(
        $playerId,
        $betReferenceNum,
        $transactionID,
        $type,
        $changeBonus,
        $amount,
        $game,
        $pn,
        $currency = 'BRL'
    ) {
        $order = Order::create([
            'user_id' => $playerId,
            'session_id' => $betReferenceNum,
            'transaction_id' => $transactionID,
            'type' => $type,
            'type_money' => $changeBonus,
            'amount' => $amount,
            'providers' => 'Evergame_Updated',
            'game' => $game,
            'game_uuid' => $pn,
            'round_id' => 1,
            'currency' => $currency,
            'created_at' => now(),
            'updated_at' => now()
        ]);

        return $order ?: false;
    }

    /**
     * Sincronizar RTP da API
     */
    public static function syncRTPFromAPI($userCode, $rtpData)
    {
        if (self::getCredentialsEvergame()) {
            $postArray = [
                "method" => "sync_rtp",
                "agentCode" => self::$agentCode,
                "token" => self::$agentToken,
                "userCode" => $userCode,
                "rtp_data" => $rtpData
            ];

            $response = Http::post(self::$apiEndpoint, $postArray);

            if ($response->successful()) {
                return $response->json();
            }
        }

        return false;
    }
}
