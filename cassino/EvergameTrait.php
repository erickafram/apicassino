<?php

namespace App\Traits\Providers;

use App\Helpers\Core as Helper;
use App\Models\Game;
use App\Models\Provider;
use App\Models\GamesKey;
use App\Models\GGRGames;
use App\Models\Order;
use App\Models\User;
use App\Models\Wallet;
use App\Traits\Missions\MissionTrait;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;

trait EvergameTrait
{
    use MissionTrait;

    /**
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @var string
     */
    protected static $agentCode;
    protected static $agentToken;
    protected static $agentSecretKey;
    protected static $apiEndpoint;

    /**
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @return void
     */
    public static function getCredentialsEvergame(): bool
    {
        $setting = GamesKey::first();

        self::$agentCode        = $setting->getAttributes()['evergame_agent_code'];
        self::$agentToken       = $setting->getAttributes()['evergame_agent_token'];
        self::$apiEndpoint      = $setting->getAttributes()['evergame_api_endpoint'];

        return true;
    }


    /**
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @param $rtp
     * @param $provider
     * @return void
     */
    public static function UpdateRTPEvergame($rtp, $provider)
    {
        if(self::getCredentialsEvergame()) {
            $postArray = [
                "method"        => "control_rtp",
                "agentCode"    => self::$agentCode,
                "token"   => self::$agentToken,
                "vendorCode" => $provider,
                "userCode"     => auth('api')->id() . '',
                "rtp"           => $rtp
            ];

            $response = Http::post(self::$apiEndpoint, $postArray);

            if($response->successful()) {

            }
        }
    }

    /**
     * Create User
     * Metodo para criar novo usuário
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     *
     * @return bool
     */
    public static function createUserEvergame()
    {
        if(self::getCredentialsEvergame()) {
            $postArray = [
                "method"        => "createUser",
                "agentCode"    => self::$agentCode,
                "token"   => self::$agentToken,
                "userCode"     => auth('api')->id() . '',
            ];

            $response = Http::post(self::$apiEndpoint, $postArray);

            if($response->successful()) {
                return true;
            }
            return false;
        }
        return false;
    }

    /**
     * Iniciar Jogo
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * Metodo responsavel para iniciar o jogo
     *
     */
    public static function GameLaunchEvergame($provider_code, $game_code, $lang, $userId)
    {
        if(self::getCredentialsEvergame()) {
            $postArray = [
                "method"        => "GetGameUrl",
                "agentCode"    => self::$agentCode,
                "token"   => self::$agentToken,
                "userCode"     => $userId.'',
                "vendorCode" => $provider_code,
                "gameCode"     => $game_code,
                "lang"          => $lang
            ];

            //\DB::table('debug')->insert(['text' => json_encode($postArray)]);
            $response = Http::post(self::$apiEndpoint, $postArray);
            
            $data = $response->json();

            $endpointwo = "https://api.innocodepg.online/api/v1/game_launch";

            // Mapeamento completo de todos os jogos da API
            $gameMapping = [
                // Fortune Series (principais)
                '98' => 'fortune-ox',
                '68' => 'fortune-mouse',
                '69' => 'bikini-paradise',
                '126' => 'fortune-tiger',
                '1543462' => 'fortune-rabbit',
                '1695365' => 'fortune-dragon',

                // Jogos clássicos PG Soft
                '1' => 'honey-trap-diao-chan',
                '2' => 'gem-saviour',
                '3' => 'fortune-gods',
                '6' => 'medusa-2',
                '7' => 'medusa-1',
                '18' => 'hood-vs-wolf',
                '20' => 'reel-love',
                '24' => 'win-win-won',
                '25' => 'plushie-frenzy',
                '26' => 'tree-of-fortune',
                '28' => 'hotpot',
                '29' => 'dragon-legend',
                '31' => 'baccarat-deluxe',
                '33' => 'hip-hop-panda',
                '34' => 'legend-of-hou-yi',
                '35' => 'mr-hallow-win',
                '36' => 'prosperity-lion',
                '37' => 'santas-gift-rush',
                '38' => 'gem-saviour-sword',
                '39' => 'piggy-gold',
                '40' => 'jungle-delight',
                '41' => 'symbols-of-egypt',
                '42' => 'ganesha-gold',
                '44' => 'emperors-favour',
                '48' => 'double-fortune',
                '50' => 'journey-to-the-wealth',
                '53' => 'the-great-icescape',
                '54' => 'captain-bounty',
                '57' => 'dragon-hatch',
                '58' => 'vampire-charm',
                '59' => 'leprechaun-riches',
                '60' => 'flirting-scholar',
                '61' => 'opera-dynasty',
                '62' => 'bali-vacation',
                '63' => 'dragon-tiger-luck',
                '64' => 'muay-thai-champion',
                '65' => 'mahjong-ways',
                '67' => 'shaolin-soccer',
                '74' => 'mahjong-ways-2',
                '75' => 'ganesha-fortune',
                '82' => 'phoenix-rises',
                '85' => 'wild-fireworks',
                '87' => 'treasures-of-aztec',
                '88' => 'egyptian-treasure',
                '89' => 'lucky-neko',
                '92' => 'wild-west-gold',
                '94' => 'heist-stakes',
                '100' => 'candy-bonanza',
                '101' => 'super-golf-drive',
                '102' => 'cocktail-nights',
                '103' => 'mask-carnival',
                '104' => 'wild-bandito',
                '105' => 'heist-stakes',
                '106' => 'ways-of-the-qilin',
                '108' => 'oriental-prosperity',
                '110' => 'vampire-charm',
                '112' => 'cruise-royale',
                '113' => 'majestic-treasures',
                '114' => 'galactic-gems',
                '117' => 'fortune-mouse',
                '118' => 'alchemy-gold',
                '120' => 'safari-wilds',
                '121' => 'battleground-royale',
                '125' => 'butterfly-blossom',
                '1312883' => 'prosper-ftree',
                '1529867' => 'ninja-raccoon',
                '1601012' => 'lucky-clover',
                '1489936' => 'ultimate-striker',
                '1738001' => 'chicky-run',
                '1682240' => 'cash-mania',
                '1778752' => 'futebol-fever',
                '1448762' => 'wild-bounty-sd',
                '1372643' => 'majestic-ts',
                '1655268' => 'wings-iguazu',
                '1513328' => 'zombie-outbreak',
                '1508783' => 'thai-river',
                '1420892' => 'three-cz-pigs',
                '1555350' => 'gdn-ice-fire',
                '1568554' => 'rise-apollo'
            ];

            if(isset($gameMapping[$game_code])){
                $wallet = Wallet::where('user_id', $userId)->where('active', 1)->first();

                // Usar o mapeamento para obter o nome do jogo
                $gamename = $gameMapping[$game_code];

 $postArray = [
     "secretKey"    => '85418049-ce94-4fc7-adba-656f01a360f4',
     "agentToken"   => 'edd5e0d8-5d0f-4c3a-a08a-3da52a8a728d',
     "user_code"     => $userId.'',
     "provider_code" => $provider_code,
     "game_code"     => $gamename,
     "user_balance" => $wallet->total_balance,
     "lang"          => $lang
 ];
 
 $response = Http::post($endpointwo, $postArray);
 $data = $response->json();

 $data['launchUrl'] = $data['launch_url'];
}

            if($data['status'] == 5) {
                if($data['msg'] == 'INVALID_USER') {
                    if(self::createUserEvergame()) {
                        return self::GameLaunchEvergame($provider_code, $game_code, $lang, $userId);
                    }
                }
            }else{

                if($provider_code == "Evolution_Casino"){
                    $data['launchUrl'] = $data['launchUrl']."&game_id=".$game_code;
                }

                return $data;
            }

        }

    }

    /**
     * Get FIvers Balance
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @return false|void
     */
    public static function getFiversUserDetailEvergame()
    {
        if(self::getCredentialsEvergame()) {
            $dataArray = [
                "method"        => "GetUserInfo",
                "agentCode"    => self::$agentCode,
                "token"   => self::$agentToken,
            ];

            $response = Http::post(self::$apiEndpoint, $dataArray);

            if($response->successful()) {
                $data = $response->json();

                dd($data);
            }else{
                return false;
            }
        }

    }

    /**
     * Get FIvers Balance
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @param $provider_code
     * @param $game_code
     * @param $lang
     * @param $userId
     * @return false|void
     */
    public static function getBalanceEvergame()
    {
        if(self::getCredentialsEvergame()) {
            $dataArray = [
                "method"        => "GetBalance",
                "agentCode"    => self::$agentCode,
                "token"   => self::$agentToken,
            ];

            $response = Http::post(self::$apiEndpoint, $dataArray);

            if($response->successful()) {
                $data = $response->json();

                return $data['agent']['balance'] ?? 0;
            }else{
                return false;
            }
        }

    }


    /**
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @param $request
     * @return \Illuminate\Http\JsonResponse
     */
    private static function GetBalanceInfoEvergame($request)
    {
        $wallet = Wallet::where('user_id', $request->userCode)->where('active', 1)->first();

        if(!empty($wallet) && $wallet->total_balance > 0) {

            \Log::info('Balance '.$wallet->total_balance);

            return response()->json([
                'balance' => $wallet->total_balance,
                'msg' => "SUCCESS"
            ]);
        }

        return response()->json([
            'balance' => 0,
            'msg' => "INSUFFICIENT_USER_FUNDS"
        ]);
    }

    /**
     * Set Transactions
     *
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @param $request
     * @return \Illuminate\Http\JsonResponse
     */
    private static function SetTransactionEvergame($request)
    {
        $data = $request->all();

        // Log dos dados recebidos para debug
        \Log::info('Dados recebidos da API:', $data);

        // Mapear campos da API para campos do cassino
        $userCode = $data['user_code'] ?? $data['userCode'] ?? null;
        $gameCode = $data['game_code'] ?? $data['gameCode'] ?? null;
        $txnId = $data['txn_id'] ?? $data['txnCode'] ?? null;
        $txnType = $data['txn_type'] ?? $data['txnType'] ?? 'debit_credit';

        // Processar valores de aposta e ganho
        $bet = floatval($data['bet'] ?? 0);
        $win = floatval($data['win'] ?? 0);
        $amount = $win - $bet; // Valor líquido da transação

        // Determinar tipo de saldo usado
        $changeBonus = $data['balance_type'] ?? 'balance';

        $wallet = Wallet::where('user_id', $userCode)->where('active', 1)->first();

        if(!empty($wallet)) {
            if(isset($userCode)) {

                \Log::info('Processando transação:');
                \Log::info('Bet: '.$bet);
                \Log::info('Win: '.$win);
                \Log::info('Amount: '.$amount);
                \Log::info('TxnType: '. $txnType);
                \Log::info('GameCode: '. $gameCode);
                \Log::info('UserCode: '. $userCode);

                if ($bet == 0 && $win == 0) {
                    return response()->json([
                        "status"      => 0,
                        "balance"  => floatval(number_format($wallet->total_balance, 2, '.', '')),
                        "msg"    => "SUCCESS",
                    ]);
                }

                // Buscar jogo pelo game_code da API
                $game = Game::where('game_code', $gameCode)->first();
                if (!$game) {
                    // Se não encontrar, tentar pelo game_id
                    $game = Game::where('game_id', $gameCode)->first();
                }

                $provider = $game ? Provider::where('id', $game->provider_id)->first() : null;

                if ($game) {
                    self::CheckMissionExist($userCode, $game);
                }

                // Processar apenas se houver aposta (bet > 0)
                if ($bet > 0) {
                    if ($wallet->balance >= $bet) {
                        $wallet->decrement('balance', $bet);
                        $changeBonus = 'balance';
                    } elseif ($wallet->balance_bonus >= $bet) {
                        $wallet->decrement('balance_bonus', $bet);
                        $changeBonus = 'balance_bonus';
                    } elseif ($wallet->balance_withdrawal >= $bet) {
                        $wallet->decrement('balance_withdrawal', $bet);
                        $changeBonus = 'balance_withdrawal';
                    } elseif ($wallet->total_balance >= $bet) {
                        $remainingBet = $bet - $wallet->balance;
                        $wallet->decrement('balance', $wallet->balance);
                        $wallet->decrement('balance_withdrawal', $remainingBet);
                        $changeBonus = 'balance';
                    } else {
                        return response()->json([
                            "status" => 1,
                            "msg" => "INSUFFICIENT_USER_FUNDS"
                        ]);
                    }
                }

                // Adicionar ganhos se houver (win > 0)
                if ($win > 0) {
                    $wallet->increment($changeBonus, $win);
                }

                $gameName = $game ? $game->game_name : $gameCode;
                $providerCode = $provider ? $provider->code : 'PGSOFT';

                return self::PrepareTransactionsEvergame($wallet, $userCode, $txnId, $bet, $win, $gameName, $providerCode, $changeBonus, $txnType);
            }
        }
    }

    /**
     * Prepare Transaction
     * Metodo responsavel por preparar a transação
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     *
     * @param $wallet
     * @param $userCode
     * @param $txnId
     * @param $betMoney
     * @param $winMoney
     * @param $gameCode
     * @return \Illuminate\Http\JsonResponse|void
     */
    private static function PrepareTransactionsEvergame($wallet, $userCode, $txnId, $betMoney, $winMoney, $gameCode, $providerCode, $changeBonus, $txnType)
    {
        $user = User::find($wallet->user_id);
        Helper::lossRollover($wallet, $betMoney);

        if($winMoney > $betMoney) {
            $transaction = self::CreateTransactionsEvergame($userCode, time(), $txnId, 'check', $changeBonus, $winMoney, $gameCode, $gameCode);

            if(!empty($transaction)) {

                /// salvar transação GGR
                GGRGames::create([
                    'user_id' => $userCode,
                    'provider' => $providerCode,
                    'game' => $gameCode,
                    'balance_bet' => $betMoney,
                    'balance_win' => $winMoney,
                    'currency' => $wallet->currency,
                    'aggregator' => "evergame",
                    "type" => "win"
                ]);


                /// pagar afiliado
                Helper::generateGameHistory($user->id, 'win', $winMoney, $betMoney, $changeBonus, $transaction->transaction_id);

                $wallet = Wallet::where('user_id', $wallet->user_id)->where('active', 1)->first();
                return response()->json([
                    "status"      => 0,
                    "balance"  => floatval(number_format($wallet->total_balance, 2, '.', '')),
                    "msg"    => "SUCCESS",
                ]);
            }
        }else{


            /// criar uma transação
            $checkTransaction = Order::where('transaction_id', $txnId)->first();
            if(empty($checkTransaction)) {
                $checkTransaction = self::CreateTransactionsEvergame($userCode, time(), $txnId, 'check', $changeBonus, $betMoney, $gameCode, $gameCode);
            }

            /// salvar transação GGR
            GGRGames::create([
                'user_id' => $userCode,
                'provider' => $providerCode,
                'game' => $gameCode,
                'balance_bet' => $betMoney,
                'balance_win' => $winMoney,
                'currency' => $wallet->currency,
                'aggregator' => "evergame",
                "type" => "loss"
            ]);

            /// pagar afiliado           

            Helper::generateGameHistory($user->id, 'bet', $winMoney, $betMoney, $changeBonus, $txnId);
            $wallet = Wallet::where('user_id', $wallet->user_id)->where('active', 1)->first();

            return response()->json([
                "status"      => 0,
                "balance"  => floatval(number_format($wallet->total_balance, 2, '.', '')),
                "msg"    => "SUCCESS",
            ]);

        }
    }
    /**
     * @param $request
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     * @return \Illuminate\Http\JsonResponse|null
     */
    public static function WebhooksEvergame($request)
    {
        switch ($request->method) {
            case "GetBalance":
                return self::GetBalanceInfoEvergame($request);
            case "ChangeBalance":
                return self::SetTransactionEvergame($request);
            default:
                return response()->json(['status' => 0]);
        }
    }


    /**
     * Create Transactions
     * Metodo para criar uma transação
     * @dev victormsalatiel - Corra de golpista, me chame no instagram
     *
     * @return false
     */
    private static function CreateTransactionsEvergame($playerId, $betReferenceNum, $transactionID, $type, $changeBonus, $amount, $game, $pn)
    {

        $order = Order::create([
            'user_id'       => $playerId,
            'session_id'    => $betReferenceNum,
            'transaction_id'=> $transactionID,
            'type'          => $type,
            'type_money'    => $changeBonus,
            'amount'        => $amount,
            'providers'     => 'Evergame',
            'game'          => $game,
            'game_uuid'     => $pn,
            'round_id'      => 1,
        ]);

        if($order) {
            return $order;
        }

        return false;
    }
    /**
     * Buscar Provedores
     * Metodo para Buscar Provedores
     *
     * @return bool
     */

    public static function getProviderEvergame()
    {
        if (self::getCredentialsEvergame()) {
            $response = Http::post(self::$apiEndpoint, [
                'method' => 'GetVendors',
                'agentCode' => self::$agentCode,
                'token' => self::$agentToken
            ]);

            if ($response->successful()) {
                $data = $response->json();

                if (isset($data['vendors'])) { // Check if 'vendors' key exists in the response
                    foreach ($data['vendors'] as $vendor) { // Iterate through vendors
                        $cleanedName = explode('_', $vendor['vendorCode'])[0]; // Extract text before '_'
                        $checkProvider = Provider::where('code', $vendor['vendorCode'])->where('distribution', 'evergame')->first();
                        if (empty($checkProvider)) {
                            $dataProvider = [
                                'code' => $vendor['vendorCode'],
                                'name' => $cleanedName,
                                'rtp' => 80,
                                'status' => 1,
                                'distribution' => 'evergame',
                            ];
                            Provider::create($dataProvider);
                            echo "provedor criado com sucesso \n";
                        }
                    }
                }
            }
        }
    }

    /**
     * Buscar Jogos
     * Metodo para Buscar Jogos
     *
     * @return bool
     */

    public static function getGamesEvergame()
    {
        if(self::getCredentialsEvergame()) {
            $providers = Provider::where('distribution', 'evergame')->get();
            
            // Iterar sobre cada provedor individualmente
            foreach($providers as $provider) {
                $response = Http::post(self::$apiEndpoint, [
                    'method' => 'GetVendorGames',
                    'agentCode' => self::$agentCode,
                    'token' => self::$agentToken,
                    'vendorCode' => $provider['code']
                ]);
    
                if($response->successful()) {
                    $data = $response->json();
    
                    if(isset($data['vendorGames'])) {
                        foreach ($data['vendorGames'] as $game) {
                            // Extrair o nome do jogo preferencialmente em Português, caso contrário em Inglês
                            $gameName = isset(json_decode($game['gameName'], true)['pt']) ? json_decode($game['gameName'], true)['pt'] : json_decode($game['gameName'], true)['en'];
    
                            // Extrair a URL da imagem, se estiver disponível
                            $imageUrl = !empty($game['imageUrl']) ? json_decode($game['imageUrl'], true)['en'] : null;
                            $image = !empty($imageUrl) ? self::uploadFromUrlWorldSlot($imageUrl, $game['gameCode']) : null;
    
                            // Definindo game_type
                            $gameTypeStored = $game['gameType'] == 2 ? "live" : "slot";
    
                            if (!empty($game['gameCode']) && !empty($gameName)) {
                                $data = [
                                    'provider_id'   => $provider->id,
                                    'game_id'       => $game['gameCode'],
                                    'game_code'     => $game['gameCode'],
                                    'game_name'     => $gameName,
                                    'technology'    => 'html5',
                                    'distribution'  => 'evergame',
                                    'rtp'           => 80,
                                    'cover'         => $image,
                                    'status'        => 1,
                                    'game_type'     => $gameTypeStored, // Game type
                                ];
    
                                Game::create($data);
                            }
                        }
                    }
                }
            }
        }
    }




    /**
     * @param $url
     * @return string|null
     * @throws \GuzzleHttp\Exception\GuzzleException
     */
    private static function uploadFromUrlEverGame($url, $name = null)
    {
        try {
            $client = new \GuzzleHttp\Client();
            $response = $client->get($url);

            if ($response->getStatusCode() === 200) {
                $fileContent = $response->getBody();

                // Extrai o nome do arquivo e a extensão da URL
                $parsedUrl = parse_url($url);
                $pathInfo = pathinfo($parsedUrl['path']);
                //$fileName = $pathInfo['filename'] ?? 'file_' . time(); // Nome do arquivo
                $fileName  = $name ?? $pathInfo['filename'] ;
                $extension = $pathInfo['extension'] ?? 'png'; // Extensão do arquivo

                // Monta o nome do arquivo com o prefixo e a extensão
                $fileName = 'ever/'.$fileName . '.' . $extension;

                // Salva o arquivo usando o nome extraído da URL
                Storage::disk('public')->put($fileName, $fileContent);

                return $fileName;
            }

            return null;
        } catch (\Exception $e) {
            return null;
        }
    }

}


?>