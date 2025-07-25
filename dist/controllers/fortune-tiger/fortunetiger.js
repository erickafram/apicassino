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
const fortunetigerfunctions_1 = __importDefault(require("../../functions/fortune-tiger/fortunetigerfunctions"));
const allfunctions_1 = __importDefault(require("../../functions/allfunctions"));
const apicontroller_1 = __importDefault(require("../apicontroller"));
const serverEvents_1 = require("../../serverEvents");
const linhaganhotiger_1 = __importDefault(require("../../jsons/fortune-tiger/linhaganhotiger"));
const linhaperdatiger_1 = __importDefault(require("../../jsons/fortune-tiger/linhaperdatiger"));
const linhabonustiger_1 = __importDefault(require("../../jsons/fortune-tiger/linhabonustiger"));
const notcashtiger_1 = __importDefault(require("../../jsons/fortune-tiger/notcashtiger"));
require("dotenv/config");
exports.default = {
    getiger(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            try {
                const token = req.body.atk;
                const gamename = "fortune-tiger";
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
                        fb: null,
                        wt: { mw: 5.0, bw: 20.0, mgw: 35.0, smgw: 50.0 },
                        maxwm: null,
                        cs: [0.08, 0.8, 3.0, 10.0],
                        ml: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                        mxl: 5,
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
            function lwchange(json1, json2, cs, ml) {
                return __awaiter(this, void 0, void 0, function* () {
                    for (let chave in json1) {
                        if (json1.hasOwnProperty(chave)) {
                            const valor = json1[chave];
                            const ganho = cs * ml * parseFloat(valor);
                            // Verifica se a chave existe no segundo JSON
                            for (let chave2 in json2) {
                                if (json2.hasOwnProperty(chave2)) {
                                    // Altera o valor correspondente no segundo JSON
                                    json2[chave] = ganho;
                                }
                            }
                        }
                    }
                });
            }
            function countrwsp(json) {
                return __awaiter(this, void 0, void 0, function* () {
                    let multplicador = 0;
                    for (let i = 1; i <= 9; i++) {
                        const chave = i.toString();
                        if (json.hasOwnProperty(chave)) {
                            multplicador = multplicador + parseFloat(json[chave]);
                        }
                    }
                    return multplicador;
                });
            }
            function gerarNumeroUnico() {
                return __awaiter(this, void 0, void 0, function* () {
                    return crypto.randomBytes(8).toString("hex");
                });
            }
            try {
                const user = yield fortunetigerfunctions_1.default.getuserbyatk(token);
                let bet = cs * ml * 5;
                console.log(bet);
                let saldoatual = user[0].saldo;
                const gamename = "fortune-tiger";
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
                if (checkuserbalance.data.msg === "INVALID_USER") {
                    res.send(yield notcashtiger_1.default.notcash(saldoatual, cs, ml));
                    return false;
                }
                else if (checkuserbalance.data.msg === "INSUFFICIENT_USER_FUNDS") {
                    res.send(yield notcashtiger_1.default.notcash(saldoatual, cs, ml));
                    return false;
                }
                const retornado = user[0].valorganho;
                const valorapostado = user[0].valorapostado;
                // Calcular RTP de forma segura
                let rtp = 0;
                if (valorapostado > 0) {
                    rtp = Math.round((retornado / valorapostado) * 100);
                    // Limitar RTP a valores razoáveis (0-500%)
                    if (rtp > 500) rtp = 500;
                    if (rtp < 0) rtp = 0;
                }
                console.log("RTP ATUAL " + rtp);
                console.log("BET ATUAL " + bet);
                if (saldoatual < bet) {
                    const semsaldo = yield notcashtiger_1.default.notcash(saldoatual, cs, ml);
                    res.send(semsaldo);
                    return false;
                }
                const resultadospin = yield allfunctions_1.default.calcularganho(bet, saldoatual, token, gamename);
                if (resultadospin.result === "perda") {
                    let newbalance = saldoatual - bet;
                    yield fortunetigerfunctions_1.default.attsaldobyatk(token, newbalance);
                    yield fortunetigerfunctions_1.default.atualizardebitado(token, bet);
                    yield fortunetigerfunctions_1.default.atualizarapostado(token, bet);
                    const perdajson = yield linhaperdatiger_1.default.linhaperda();
                    let json = {
                        dt: {
                            si: {
                                wc: 31,
                                ist: perdajson.ist,
                                itw: true,
                                fws: 0,
                                wp: null,
                                orl: perdajson.orl,
                                lw: null,
                                irs: false,
                                gwt: -1,
                                fb: null,
                                ctw: 0.0,
                                pmt: null,
                                cwc: 0,
                                fstc: null,
                                pcwc: 0,
                                rwsp: null,
                                hashr: "0:2;5;4#3;3;6#7;3;6#MV#3.0#MT#1#MG#0#",
                                ml: ml,
                                cs: cs,
                                rl: perdajson.orl,
                                sid: "1758600495495052800",
                                psid: "1758600495495052800",
                                st: 1,
                                nst: 1,
                                pf: 1,
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
                                tw: 0.0,
                                np: -bet,
                                ocr: null,
                                mr: null,
                                ge: [1, 11],
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
                }
                if (resultadospin.result === "ganho") {
                    const ganhojson = yield linhaganhotiger_1.default.linhaganho(bet);
                    const multplicador = yield countrwsp(ganhojson.rwsp);
                    yield lwchange(ganhojson.rwsp, ganhojson.lw, cs, ml);
                    const valorganho = cs * ml * multplicador;
                    const newbalance = saldoatual + valorganho - bet;
                    yield fortunetigerfunctions_1.default.attsaldobyatk(token, newbalance);
                    yield fortunetigerfunctions_1.default.atualizardebitado(token, bet);
                    yield fortunetigerfunctions_1.default.atualizarapostado(token, bet);
                    yield fortunetigerfunctions_1.default.atualizarganho(token, valorganho);
                    let json = {
                        dt: {
                            si: {
                                wc: 17,
                                ist: ganhojson.ist,
                                itw: false,
                                fws: 0,
                                wp: ganhojson.wp,
                                orl: ganhojson.orl,
                                lw: ganhojson.lw,
                                irs: false,
                                gwt: bet,
                                fb: null,
                                ctw: valorganho,
                                pmt: null,
                                cwc: bet,
                                fstc: null,
                                pcwc: bet,
                                rwsp: ganhojson.rwsp,
                                hashr: "0:6;4;6#6;4;6#6;4;4#MV#3.0#MT#1#MG#0#",
                                ml: ml,
                                cs: cs,
                                rl: ganhojson.orl,
                                sid: "1757973319175306752",
                                psid: "1757973319175306752",
                                st: 1,
                                nst: 1,
                                pf: 1,
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
                                np: bet,
                                ocr: null,
                                mr: null,
                                ge: [1, 11],
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
                }
                if (resultadospin.result === "bonus" && resultadospin.gamecode === "fortune-tiger") {
                    const cartajson = yield linhabonustiger_1.default.linhacarta(resultadospin.json);
                    let call = yield allfunctions_1.default.getcallbyid(resultadospin.idcall);
                    if (call[0].steps === null && call[0].status === "pending") {
                        const steps = Object.keys(cartajson).length - 1;
                        yield allfunctions_1.default.updatestepscall(resultadospin.idcall, steps);
                    }
                    let calltwo = yield allfunctions_1.default.getcallbyid(resultadospin.idcall);
                    if (calltwo[0].steps === 0) {
                        const multplicador = yield countrwsp(cartajson[calltwo[0].steps].rwsp);
                        yield lwchange(cartajson[calltwo[0].steps].rwsp, cartajson[calltwo[0].steps].lw, cs, ml);
                        let valorganho = cs * ml * multplicador;
                        if (cartajson[calltwo[0].steps].completed === true) {
                            valorganho = cs * ml * multplicador * 10;
                        }
                        const newbalance = saldoatual + valorganho - bet;
                        yield fortunetigerfunctions_1.default.attsaldobyatk(token, newbalance);
                        yield fortunetigerfunctions_1.default.atualizardebitado(token, bet);
                        yield fortunetigerfunctions_1.default.atualizarapostado(token, bet);
                        yield fortunetigerfunctions_1.default.atualizarganho(token, valorganho);
                        let json = {
                            dt: {
                                si: {
                                    wc: 0,
                                    ist: cartajson[calltwo[0].steps].ist,
                                    itw: cartajson[calltwo[0].steps].itw,
                                    fws: cartajson[calltwo[0].steps].fws,
                                    wp: cartajson[calltwo[0].steps].wp,
                                    orl: cartajson[calltwo[0].steps].orl,
                                    lw: cartajson[calltwo[0].steps].lw,
                                    irs: cartajson[calltwo[0].steps].irs,
                                    gwt: 3,
                                    fb: null,
                                    ctw: valorganho,
                                    pmt: null,
                                    cwc: 1,
                                    fstc: { "4": 2 },
                                    pcwc: 0,
                                    rwsp: cartajson[calltwo[0].steps].rwsp,
                                    hashr: "2:7;7;7#7;7;7#7;7;7#R#7#011121#MV#0#MT#1#R#7#001020#MV#0#MT#1#R#7#021222#MV#0#MT#1#R#7#001122#MV#0#MT#1#R#7#021120#MV#0#MT#1#MG#90.0#",
                                    ml: cs,
                                    cs: ml,
                                    rl: cartajson[calltwo[0].steps].rl,
                                    sid: "1761174298456686080",
                                    psid: "1761174260091387392",
                                    st: 4,
                                    nst: 1,
                                    pf: 1,
                                    aw: valorganho,
                                    wid: 0,
                                    wt: "C",
                                    wk: "0_C",
                                    wbn: null,
                                    wfg: null,
                                    blb: saldoatual,
                                    blab: newbalance,
                                    bl: newbalance,
                                    tb: 0.0,
                                    tbb: bet,
                                    tw: valorganho,
                                    np: valorganho,
                                    ocr: null,
                                    mr: null,
                                    ge: [1, 11],
                                },
                            },
                            err: null,
                        };
                        yield allfunctions_1.default.savejsonspin(user[0].id, JSON.stringify(json), gamename);
                        yield allfunctions_1.default.completecall(calltwo[0].id);
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
                                win: valorganho,
                                txn_id: `${txnid}`,
                                txn_type: "debit_credit",
                                is_buy: false,
                                is_call: true,
                                user_before_balance: user[0].saldo,
                                user_after_balance: newbalance,
                                agent_before_balance: 100,
                                agent_after_balance: 100,
                                created_at: dataFormatada,
                            },
                        });
                        res.send(json);
                        return false;
                    }
                    yield allfunctions_1.default.subtrairstepscall(resultadospin.idcall);
                    let json = {
                        dt: {
                            si: {
                                wc: 103,
                                ist: cartajson[calltwo[0].steps].ist,
                                itw: cartajson[calltwo[0].steps].itw,
                                fws: cartajson[calltwo[0].steps].fws,
                                wp: cartajson[calltwo[0].steps].wp,
                                orl: cartajson[calltwo[0].steps].orl,
                                lw: cartajson[calltwo[0].steps].lw,
                                irs: cartajson[calltwo[0].steps].irs,
                                gwt: -1,
                                fb: null,
                                ctw: 0.0,
                                pmt: null,
                                cwc: 0,
                                fstc: null,
                                pcwc: 0,
                                rwsp: cartajson[calltwo[0].steps].rwsp,
                                hashr: "0:6;3;7#4;7;7#7;4;7#R#7#021120#MV#3.0#MT#1#MG#0#",
                                ml: cs,
                                cs: ml,
                                rl: cartajson[calltwo[0].steps].rl,
                                sid: "1761174260091387392",
                                psid: "1761174260091387392",
                                st: 1,
                                nst: 4,
                                pf: 1,
                                aw: 0.0,
                                wid: 0,
                                wt: "C",
                                wk: "0_C",
                                wbn: null,
                                wfg: null,
                                blb: saldoatual,
                                blab: saldoatual,
                                bl: saldoatual,
                                tb: bet,
                                tbb: bet,
                                tw: 0.0,
                                np: -bet,
                                ocr: null,
                                mr: null,
                                ge: [4, 11],
                            },
                        },
                        err: null,
                    };
                    res.send(json);
                }
            }
            catch (error) {
                logger_1.default.error(error);
            }
        });
    },
};
