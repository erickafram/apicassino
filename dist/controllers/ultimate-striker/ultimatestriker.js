"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const axios_1 = __importDefault(require("axios"));
const logger_1 = __importDefault(require("../../logger"));
const crypto = __importStar(require("crypto"));
const uuid_1 = require("uuid"); // Renomear a importação
const moment_1 = __importDefault(require("moment"));
require("dotenv/config");
// IMPORT FUNCTIONS
const serverEvents_1 = require("../../serverEvents");
const allfunctions_1 = __importDefault(require("../../functions/allfunctions"));
const apicontroller_1 = __importDefault(require("../apicontroller"));
const ultimatestrikerfunctions_1 = __importDefault(require("../../functions/ultimate-striker/ultimatestrikerfunctions"));
// IMPORT LINHAS
const linhaperdastriker_1 = __importDefault(require("../../jsons/ultimate-striker/linhaperdastriker"));
const linhaganhostriker_1 = __importDefault(require("../../jsons/ultimate-striker/linhaganhostriker"));
const notcashstriker_1 = __importDefault(require("../../jsons/ultimate-striker/notcashstriker"));
const stepsStorage = {};
function lwchange(json1, json2, cs, ml) {
    return __awaiter(this, void 0, void 0, function* () {
        for (let chave in json1) {
            if (json1.hasOwnProperty(chave)) {
                const valor = json1[chave];
                const ganho = cs * ml * parseFloat(valor);
                for (let chave2 in json2) {
                    if (json2.hasOwnProperty(chave2)) {
                        json2[chave] = ganho;
                    }
                }
            }
        }
    });
}
function countrwsp(json) {
    return __awaiter(this, void 0, void 0, function* () {
        let multiplicador = 0;
        for (let i = 1; i <= 25; i++) {
            const chave = i.toString();
            if (json.hasOwnProperty(chave)) {
                multiplicador += parseFloat(json[chave]);
            }
        }
        return multiplicador;
    });
}
function gerarNumeroUnico() {
    return __awaiter(this, void 0, void 0, function* () {
        return crypto.randomBytes(8).toString("hex");
    });
}
function returnrwm(json) {
    return __awaiter(this, void 0, void 0, function* () {
        let value = 0;
        for (let chave in json) {
            if (json.hasOwnProperty(chave)) {
                value += parseFloat(json[chave]);
            }
        }
        return value;
    });
}
function getSteps(token, gamename) {
    const key = `${token}:${gamename}`;
    return stepsStorage[key] || 0;
}
function setSteps(token, gamename, steps) {
    const key = `${token}:${gamename}`;
    stepsStorage[key] = steps;
}
function incrementSteps(token, gamename) {
    const key = `${token}:${gamename}`;
    stepsStorage[key] = (stepsStorage[key] || 0) + 1;
}
function resetSteps(token, gamename) {
    const key = `${token}:${gamename}`;
    delete stepsStorage[key];
}
exports.default = {
    getstriker(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const token = req.body.atk;
                const gamename = "ultimate-striker";
                const user = yield allfunctions_1.default.getuserbyatk(token);
                logger_1.default.info('[+] Usuario logado: ' + user[0].username);
                const jsonprimay = yield allfunctions_1.default.getSpinByPlayerId(user[0].id);
                const jsoninicial = yield allfunctions_1.default.getjsonprimary(gamename);
                if (jsonprimay.length === 0) {
                    yield allfunctions_1.default.createOrUpdateSpin(user[0].id, gamename, jsoninicial[0].json);
                }
                if (jsonprimay[0].game_code === gamename) {
                    logger_1.default.info('[+] Json Recuperado Do Ultimo Spin.');
                }
                else {
                    yield allfunctions_1.default.createOrUpdateSpin(user[0].id, gamename, jsoninicial[0].json);
                }
                const json = yield allfunctions_1.default.getSpinByPlayerId(user[0].id);
                const jsonformatado = JSON.parse(json[0].json);
                res.send({
                    dt: {
                        fb: { is: true, bm: 100, t: 0.75 },
                        wt: { mw: 5, bw: 20, mgw: 35, smgw: 50 },
                        maxwm: null,
                        cs: [0.02, 0.12, 0.8],
                        ml: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                        mxl: 25,
                        bl: user[0].saldo,
                        inwe: false,
                        iuwe: false,
                        ls: jsonformatado.dt,
                        cc: "BRL",
                    },
                    err: null,
                });
            }
            catch (error) {
                logger_1.default.error(error);
            }
        });
    },
    spin(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            let cs = req.body.cs;
            let ml = req.body.ml;
            const token = req.body.atk;
            try {
                const user = yield ultimatestrikerfunctions_1.default.getuserbyatk(token);
                let bet = cs * ml * 20;
                let saldoatual = user[0].saldo;
                const gamename = "ultimate-striker";
                (0, serverEvents_1.emitirEventoInterno)("att", {
                    token: token,
                    username: user[0].username,
                    bet: bet,
                    saldo: saldoatual,
                    rtp: user[0].rtp,
                    agentid: user[0].agentid,
                    gamecode: gamename,
                });
                const agent = yield allfunctions_1.default.getagentbyid(user[0].agentid);
                const checkuserbalance = yield (0, axios_1.default)({
                    maxBodyLength: Infinity,
                    method: "POST",
                    url: `${agent[0].callbackurl}gold_api/user_balance`,
                    headers: {
                        "Content-Type": "application/json",
                    },
                    data: {
                        user_code: user[0].username,
                    },
                });
                if (checkuserbalance.data.msg === "INVALID_USER" || checkuserbalance.data.msg === "INSUFFICIENT_USER_FUNDS") {
                    res.send(yield notcashstriker_1.default.notcash(saldoatual, cs, ml));
                    return;
                }
                const retornado = user[0].valorganho;
                const valorapostado = user[0].valorapostado;
                const rtp = (retornado / valorapostado) * 100;
                if (saldoatual < bet) {
                    res.send(yield notcashstriker_1.default.notcash(saldoatual, cs, ml));
                    return;
                }
                let steps = getSteps(token, gamename);
                const resultadospin = yield allfunctions_1.default.calcularganho(bet, saldoatual, token, gamename);
                if (steps > 0) {
                    resultadospin.result = "ganho";
                }
                if (req.body.fb === "2") {
                    let valorcompra = 40;
                    const saldocompra = saldoatual - valorcompra;
                    logger_1.default.info(`[!] Saldo Atual: ${saldoatual}`);
                    logger_1.default.info(`[!] Novo Saldo após compra: ${saldocompra}`);
                    logger_1.default.info(`[!] Token Enviado: ${token}`);
                    try {
                        yield ultimatestrikerfunctions_1.default.attsaldobyatk(token, saldocompra);
                        logger_1.default.info('[!] COMPRA BONUS ACIONADO COM SUCESSO!');
                        resultadospin.result = "ganho";
                    }
                    catch (error) {
                        logger_1.default.error('[!] ERRO AO ATUALIZAR SALDO:', error);
                    }
                }
                if (resultadospin.result === "perda") {
                    let newbalance = saldoatual - bet;
                    yield ultimatestrikerfunctions_1.default.attsaldobyatk(token, newbalance);
                    yield ultimatestrikerfunctions_1.default.atualizardebitado(token, bet);
                    yield ultimatestrikerfunctions_1.default.atualizarapostado(token, bet);
                    const perdajson = yield linhaperdastriker_1.default.linhaperda();
                    const possibilidades = Math.floor(Math.random() * 8193);
                    let json = {
                        "dt": {
                            "si": {
                                "wp": null,
                                "lw": null,
                                "bwp": null,
                                "snww": null,
                                "now": possibilidades,
                                "nowpr": perdajson.nowpr || [],
                                "es": perdajson.es || {},
                                "eb": perdajson.eb || {},
                                "esb": perdajson.esb || {},
                                "ebb": perdajson.ebb || {},
                                "ptbr": null,
                                "orl": perdajson.orl || [],
                                "ssaw": perdajson.ssaw || null,
                                "sc": perdajson.sc || 0,
                                "gm": perdajson.gm || null,
                                "omf": perdajson.omf || [],
                                "mf": perdajson.mf || [],
                                "mi": perdajson.mi || 0,
                                "twbm": perdajson.twbm || 0,
                                "crtw": perdajson.crtw || 0,
                                "imw": perdajson.imw || false,
                                "rs": perdajson.rs || null,
                                "fs": perdajson.fs || null,
                                "gwt": perdajson.gwt || -1,
                                "fb": perdajson.fb || null,
                                "ctw": perdajson.ctw || 0,
                                "pmt": perdajson.pmt || null,
                                "cwc": perdajson.cwc || 0,
                                "fstc": perdajson.fstc || {},
                                "pcwc": perdajson.pcwc || 0,
                                "rwsp": perdajson.rwsp || null,
                                "hashr": perdajson.hashr || "",
                                "ml": ml,
                                "cs": cs,
                                "rl": perdajson.rl || [],
                                "sid": "1819129987980000768",
                                "psid": "1819129971504774656",
                                "st": perdajson.st || 0,
                                "nst": perdajson.nst || 0,
                                "pf": perdajson.pf || 0,
                                "aw": 0.0,
                                "wid": perdajson.wid || 0,
                                "wt": "C",
                                "wk": "0_C",
                                "wbn": null,
                                "wfg": null,
                                "blb": saldoatual,
                                "blab": newbalance,
                                "bl": newbalance,
                                "tb": bet,
                                "tbb": bet,
                                "tw": 0.00,
                                "np": -bet,
                                "ocr": null,
                                "mr": null,
                                "ge": [1, 11]
                            }
                        },
                        err: null,
                    };
                    yield allfunctions_1.default.savejsonspin(user[0].id, JSON.stringify(json), gamename);
                    const txnid = (0, uuid_1.v4)();
                    const dataFormatada = (0, moment_1.default)().toISOString();
                    yield apicontroller_1.default.callbackgame({
                        agent_code: agent[0].agentcode,
                        agent_secret: agent[0].secretKey,
                        user_code: user[0].username,
                        user_balance: user[0].saldo,
                        user_total_credit: user[0].valorganho,
                        user_total_debit: user[0].valorapostado,
                        game_type: "slot",
                        slot: {
                            provider_code: "PGSOFT",
                            game_code: gamename,
                            round_id: yield gerarNumeroUnico(),
                            type: "BASE",
                            bet: bet,
                            win: 0,
                            txn_id: `${txnid}`,
                            txn_type: "debit_credit",
                            is_buy: false,
                            is_call: false,
                            user_before_balance: user[0].saldo,
                            user_after_balance: newbalance,
                            agent_before_balance: 100,
                            agent_after_balance: 100,
                            created_at: dataFormatada,
                        },
                    });
                    res.send(json);
                    return;
                }
                if (resultadospin.result === "ganho") {
                    try {
                        const userId = user[0].id;
                        // Recuperar a linha de ganho do banco de dados
                        let linhaGanhoAnterior = yield ultimatestrikerfunctions_1.default.obterLinhaGanho(userId);
                        // Se houver um ganho anterior, use a linha armazenada, caso contrário, gere uma nova
                        let numeroAleatorio;
                        if (linhaGanhoAnterior !== null && linhaGanhoAnterior !== undefined) {
                            numeroAleatorio = linhaGanhoAnterior;
                        }
                        else {
                            //numeroAleatorio = 3;
                            numeroAleatorio = Math.floor(Math.random() * 13) + 1; // Supondo que maxLinhas seja o número máximo de linhas disponíveis
                            linhaGanhoAnterior = numeroAleatorio; // Armazenar a nova linha de ganho
                        }
                        console.log("Linha de ganho escolhida: " + numeroAleatorio);
                        const ganhojson = yield linhaganhostriker_1.default.linhaganho(numeroAleatorio);
                        // Verificar se ganhojson não é nulo ou indefinido
                        if (!ganhojson) {
                            throw new Error("Dados de ganho inválidos");
                        }
                        let valorganho = cs * ml * 100;
                        let wmvalue = 0;
                        console.log("VALOR GANHO " + valorganho);
                        // Verificar se saldoatual e bet são válidos
                        if (typeof saldoatual !== 'number' || typeof bet !== 'number') {
                            throw new Error("Saldo ou aposta inválidos");
                        }
                        const newbalance = saldoatual + valorganho - bet;
                        yield ultimatestrikerfunctions_1.default.attsaldobyatk(token, newbalance);
                        yield ultimatestrikerfunctions_1.default.atualizardebitado(token, bet);
                        yield ultimatestrikerfunctions_1.default.atualizarapostado(token, bet);
                        yield ultimatestrikerfunctions_1.default.atualizarganho(token, valorganho);
                        const possibilidades = Math.floor(Math.random() * 8193);
                        let json = {
                            "dt": {
                                "si": {
                                    "wp": ganhojson[steps].wp,
                                    "lw": ganhojson[steps].lw,
                                    "bwp": ganhojson[steps].bwp,
                                    "snww": ganhojson[steps].snww,
                                    "now": ganhojson[steps].now,
                                    "nowpr": ganhojson[steps].nowpr,
                                    "es": ganhojson[steps].es,
                                    "eb": ganhojson[steps].eb,
                                    "esb": ganhojson[steps].esb,
                                    "ebb": ganhojson[steps].ebb,
                                    "ptbr": ganhojson[steps].ptbr,
                                    "orl": ganhojson[steps].orl,
                                    "ssaw": ganhojson[steps].ssaw,
                                    "sc": ganhojson[steps].sc,
                                    "gm": ganhojson[steps].gm,
                                    "omf": ganhojson[steps].omf,
                                    "mf": ganhojson[steps].mf,
                                    "mi": ganhojson[steps].mi,
                                    "twbm": ganhojson[steps].twbm,
                                    "crtw": ganhojson[steps].crtw,
                                    "imw": ganhojson[steps].imw,
                                    "rs": ganhojson[steps].rs,
                                    "fs": ganhojson[steps].fs,
                                    "gwt": ganhojson[steps].gwt,
                                    "fb": ganhojson[steps].fb,
                                    "ctw": ganhojson[steps].ctw,
                                    "pmt": ganhojson[steps].pmt,
                                    "cwc": ganhojson[steps].cwc,
                                    "fstc": ganhojson[steps].fstc,
                                    "pcwc": ganhojson[steps].pcwc,
                                    "rwsp": ganhojson[steps].rwsp,
                                    "hashr": ganhojson[steps].hashr,
                                    "ml": ml,
                                    "cs": cs,
                                    "rl": ganhojson[steps].rl,
                                    "sid": ganhojson[steps].sid,
                                    "psid": ganhojson[steps].psid,
                                    "st": ganhojson[steps].st,
                                    "nst": ganhojson[steps].nst,
                                    "pf": ganhojson[steps].pf,
                                    "aw": ganhojson[steps].aw,
                                    "wid": ganhojson[steps].wid,
                                    "wt": "C",
                                    "wk": "0_C",
                                    "wbn": null,
                                    "wfg": null,
                                    "blb": saldoatual,
                                    "blab": newbalance,
                                    "bl": newbalance,
                                    "tb": 0,
                                    "tbb": bet,
                                    "tw": ganhojson[steps].tw,
                                    "np": ganhojson[steps].np,
                                    "ocr": null,
                                    "mr": null,
                                    "ge": [1, 11]
                                }
                            },
                            err: null,
                        };
                        yield allfunctions_1.default.savejsonspin(user[0].id, JSON.stringify(json), gamename);
                        const txnid = (0, uuid_1.v4)();
                        const dataFormatada = (0, moment_1.default)().toISOString();
                        // Salvar a linha de ganho atual no banco de dados
                        yield ultimatestrikerfunctions_1.default.atualizarLinhaGanho(userId, numeroAleatorio);
                        logger_1.default.info('LINHA DE GANHO SALVA NO BD: ' + numeroAleatorio);
                        // Incrementar e verificar steps
                        incrementSteps(token, gamename);
                        if (getSteps(token, gamename) >= Object.keys(ganhojson).length) {
                            resetSteps(token, gamename);
                            yield ultimatestrikerfunctions_1.default.atualizarLinhaGanho(userId, null); // Resetar a linha de ganho quando os steps são resetados
                        }
                        yield apicontroller_1.default.callbackgame({
                            agent_code: agent[0].agentcode,
                            agent_secret: agent[0].secretKey,
                            user_code: user[0].username,
                            user_balance: user[0].saldo,
                            user_total_credit: user[0].valorganho,
                            user_total_debit: user[0].valorapostado,
                            game_type: "slot",
                            slot: {
                                provider_code: "PGSOFT",
                                game_code: gamename,
                                round_id: yield gerarNumeroUnico(),
                                type: "BASE",
                                bet: bet,
                                win: Number(valorganho),
                                txn_id: `${txnid}`,
                                txn_type: "debit_credit",
                                is_buy: false,
                                is_call: false,
                                user_before_balance: user[0].saldo,
                                user_after_balance: newbalance,
                                agent_before_balance: 100,
                                agent_after_balance: 100,
                                created_at: dataFormatada,
                            },
                        });
                        res.send(json);
                        return;
                    }
                    catch (error) {
                        if (error instanceof Error) {
                            logger_1.default.error(error.message);
                        }
                        else {
                            logger_1.default.error("Ocorreu um erro desconhecido");
                        }
                        res.status(500).send({
                            err: {
                                type: "InternalError",
                                message: "Ocorreu um erro desconhecido, tente novamente. (codigo de erro:G1008)",
                            },
                        });
                    }
                }
            }
            catch (error) {
                logger_1.default.error(error);
            }
        });
    },
};
