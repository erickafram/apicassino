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
const uuid_1 = require("uuid");
const moment_1 = __importDefault(require("moment"));
require("dotenv/config");
// IMPORT FUNCTIONS
const serverEvents_1 = require("../../serverEvents");
const allfunctions_1 = __importDefault(require("../../functions/allfunctions"));
const apicontroller_1 = __importDefault(require("../apicontroller"));
const shaolinfunctions_1 = __importDefault(require("../../functions/shaolin-soccer/shaolinfunctions"));
// IMPORT LINHAS
const linhaperdashaolin_1 = __importDefault(require("../../jsons/shaolin-soccer/linhaperdashaolin"));
const notcashshaolin_1 = __importDefault(require("../../jsons/shaolin-soccer/notcashshaolin"));
const linhaganhoshaolin_1 = __importDefault(require("../../jsons/shaolin-soccer/linhaganhoshaolin"));
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
    getshaolin(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const token = req.body.atk;
                const gamename = "shaolin-soccer";
                const user = yield allfunctions_1.default.getuserbyatk(token);
                logger_1.default.info("[+] Usuario logado: " + user[0].username);
                const jsonprimay = yield allfunctions_1.default.getSpinByPlayerId(user[0].id);
                const jsoninicial = yield allfunctions_1.default.getjsonprimary(gamename);
                if (jsonprimay.length === 0) {
                    yield allfunctions_1.default.createOrUpdateSpin(user[0].id, gamename, jsoninicial[0].json);
                }
                if (jsonprimay[0].game_code === gamename) {
                    logger_1.default.info("[+] Json Recuperado Do Ultimo Spin.");
                }
                else {
                    yield allfunctions_1.default.createOrUpdateSpin(user[0].id, gamename, jsoninicial[0].json);
                }
                const json = yield allfunctions_1.default.getSpinByPlayerId(user[0].id);
                const jsonformatado = JSON.parse(json[0].json);
                res.send({
                    dt: {
                        fb: {
                            is: true,
                            bm: 50,
                            t: 20.0,
                        },
                        wt: {
                            mw: 5.0,
                            bw: 20.0,
                            mgw: 35.0,
                            smgw: 50.0,
                        },
                        maxwm: null,
                        cs: [0.02, 0.1, 0.2],
                        ml: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                        mxl: 20,
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
            let cs = parseFloat(req.body.cs);
            let ml = parseFloat(req.body.ml);
            const token = req.body.atk;
            try {
                const user = yield shaolinfunctions_1.default.getuserbyatk(token);
                let bet = cs * ml * 20;
                let saldoatual = user[0].saldo;
                const gamename = "shaolin-soccer";
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
                    res.send(yield notcashshaolin_1.default.notcash(saldoatual, cs, ml));
                    return;
                }
                const retornado = user[0].valorganho;
                const valorapostado = user[0].valorapostado;
                const rtp = (retornado / valorapostado) * 100;
                if (saldoatual < bet) {
                    res.send(yield notcashshaolin_1.default.notcash(saldoatual, cs, ml));
                    return;
                }
                let steps = getSteps(token, gamename);
                const resultadospin = yield allfunctions_1.default.calcularganho(bet, saldoatual, token, gamename);
                if (steps > 0) {
                    resultadospin.result = "ganho";
                }
                if (resultadospin.result === "bonus") {
                    resultadospin.result = "ganho";
                }
                if (resultadospin.result === "perda") {
                    resultadospin.result = "ganho";
                }
                if (resultadospin.result === "perda") {
                    let newbalance = saldoatual - bet;
                    yield shaolinfunctions_1.default.attsaldobyatk(token, newbalance);
                    yield shaolinfunctions_1.default.atualizardebitado(token, bet);
                    yield shaolinfunctions_1.default.atualizarapostado(token, bet);
                    const perdajson = yield linhaperdashaolin_1.default.linhaperda();
                    let json = {
                        dt: {
                            si: {
                                wp: null,
                                twp: null,
                                lw: null,
                                trl: perdajson.trl,
                                torl: perdajson.torl,
                                orl: perdajson.orl,
                                bwp: null,
                                now: perdajson.now,
                                nowpr: perdajson.nowpr,
                                snww: null,
                                esb: perdajson.esb,
                                ebb: perdajson.ebb,
                                es: perdajson.es,
                                eb: perdajson.eb,
                                ssaw: 0.0,
                                tptbr: null,
                                ptbr: null,
                                ptbrp: null,
                                gml: 1,
                                ngml: 1,
                                sc: 0,
                                rs: null,
                                fs: null,
                                gwt: 0,
                                fb: null,
                                ctw: 0.0,
                                pmt: null,
                                cwc: 0,
                                fstc: null,
                                pcwc: 0,
                                rwsp: null,
                                hashr: null,
                                ml: ml,
                                cs: cs,
                                rl: perdajson.rl,
                                sid: "0",
                                psid: "0",
                                st: 1,
                                nst: 1,
                                pf: 0,
                                aw: 0.0,
                                wid: 0,
                                wt: "C",
                                wk: "0_C",
                                wbn: null,
                                wfg: null,
                                blb: saldoatual,
                                blab: newbalance,
                                bl: newbalance,
                                tb: bet,
                                tbb: bet,
                                tw: bet,
                                np: -bet,
                                ocr: null,
                                mr: null,
                                ge: null,
                            },
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
                        let linhaGanhoAnterior = yield shaolinfunctions_1.default.obterLinhaGanho(userId);
                        // Se houver um ganho anterior, use a linha armazenada, caso contrário, gere uma nova
                        let numeroAleatorio;
                        if (linhaGanhoAnterior !== null && linhaGanhoAnterior !== undefined) {
                            numeroAleatorio = linhaGanhoAnterior;
                        }
                        else {
                            //numeroAleatorio = 3;
                            numeroAleatorio = Math.floor(Math.random() * 33) + 1; // Supondo que maxLinhas seja o número máximo de linhas disponíveis
                            linhaGanhoAnterior = numeroAleatorio; // Armazenar a nova linha de ganho
                        }
                        console.log("Linha de ganho escolhida: " + numeroAleatorio);
                        const ganhojson = yield linhaganhoshaolin_1.default.linhaganho(numeroAleatorio);
                        // Verificar se ganhojson não é nulo ou indefinido
                        if (!ganhojson) {
                            throw new Error("Dados de ganho inválidos");
                        }
                        const multplicador = yield countrwsp(ganhojson[steps].rwsp || 0);
                        yield lwchange(ganhojson[steps].rwsp, ganhojson[steps].lw, cs, ml);
                        let valorganho = cs * ml * multplicador * 20;
                        let wmvalue = 0;
                        console.log("VALOR GANHO " + valorganho);
                        // Verificar se saldoatual e bet são válidos
                        if (typeof saldoatual !== "number" || typeof bet !== "number") {
                            throw new Error("Saldo ou aposta inválidos");
                        }
                        let newbalance;
                        // Verifica se o steps já começou a contar, se sim, não subtrai o bet
                        if (getSteps(token, gamename) > 0) {
                            newbalance = saldoatual + valorganho; // Não desconta o bet quando os steps estão contando
                            logger_1.default.info("Steps em andamento, não desconta o bet");
                        }
                        else {
                            newbalance = saldoatual + valorganho - bet; // Subtrai o bet apenas se os steps não estão contando
                        }
                        // Atualizar saldo, debitar aposta e atualizar ganho
                        yield shaolinfunctions_1.default.attsaldobyatk(token, newbalance);
                        yield shaolinfunctions_1.default.atualizardebitado(token, bet);
                        yield shaolinfunctions_1.default.atualizarapostado(token, bet);
                        yield shaolinfunctions_1.default.atualizarganho(token, valorganho);
                        let json = {
                            dt: {
                                si: {
                                    wp: ganhojson[steps].wp,
                                    twp: ganhojson[steps].twp,
                                    lw: lwchange,
                                    trl: ganhojson[steps].trl,
                                    torl: ganhojson[steps].torl,
                                    orl: ganhojson[steps].orl,
                                    bwp: ganhojson[steps].bwp,
                                    now: ganhojson[steps].now,
                                    nowpr: ganhojson[steps].nowpr,
                                    snww: ganhojson[steps].snww,
                                    esb: ganhojson[steps].esb,
                                    ebb: ganhojson[steps].ebb,
                                    es: ganhojson[steps].es,
                                    eb: ganhojson[steps].eb,
                                    ssaw: ganhojson[steps].ssaw,
                                    tptbr: ganhojson[steps].tptbr,
                                    ptbr: ganhojson[steps].ptbr,
                                    ptbrp: ganhojson[steps].ptbrp,
                                    gml: ganhojson[steps].gml,
                                    ngml: ganhojson[steps].ngml,
                                    sc: ganhojson[steps].sc,
                                    rs: ganhojson[steps].rs,
                                    fs: ganhojson[steps].fs,
                                    gwt: -1,
                                    ctw: valorganho,
                                    pmt: ganhojson[steps].pmt,
                                    cwc: ganhojson[steps].cwc,
                                    fstc: ganhojson[steps].fstc,
                                    pcwc: ganhojson[steps].pcwc,
                                    rwsp: ganhojson[steps].rwsp,
                                    hashr: "0:5;8;11;11;9;12#5;8;12;11;9;6#5;12;12;9;9;12#12;12;12;8;9;6#4;6;9;8;7;9#R#5#000102#MV#12.0#MT#1#R#12#031213212223#MV#12.0#MT#1#MG#15.0#",
                                    fb: ganhojson[steps].fb,
                                    ml: ml,
                                    cs: cs,
                                    rl: ganhojson[steps].rl,
                                    sid: "1838862619965849088",
                                    psid: "1838862619965849088",
                                    st: ganhojson[steps].st,
                                    nst: ganhojson[steps].nst,
                                    pf: ganhojson[steps].pf,
                                    aw: valorganho,
                                    wid: 0,
                                    wt: "C",
                                    wk: "0_C",
                                    wbn: null,
                                    wfg: null,
                                    blb: saldoatual,
                                    blab: newbalance,
                                    bl: newbalance,
                                    tb: bet,
                                    tbb: bet,
                                    tw: valorganho,
                                    np: -bet,
                                    ocr: null,
                                    mr: null,
                                    ge: [1, 11],
                                },
                            },
                            err: null,
                        };
                        // Salvar os dados do spin
                        yield allfunctions_1.default.savejsonspin(user[0].id, JSON.stringify(json), gamename);
                        const txnid = (0, uuid_1.v4)();
                        const dataFormatada = (0, moment_1.default)().toISOString();
                        // Salvar a linha de ganho atual no banco de dados
                        yield shaolinfunctions_1.default.atualizarLinhaGanho(userId, numeroAleatorio);
                        logger_1.default.info("LINHA DE GANHO SALVA NO BD: " + numeroAleatorio);
                        console.log("linha de ganho " + numeroAleatorio);
                        // Incrementar e verificar steps
                        incrementSteps(token, gamename);
                        if (getSteps(token, gamename) >= Object.keys(ganhojson).length) {
                            resetSteps(token, gamename);
                            yield shaolinfunctions_1.default.atualizarLinhaGanho(userId, null); // Resetar a linha de ganho quando os steps são resetados
                        }
                        // Callback para o jogo
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
