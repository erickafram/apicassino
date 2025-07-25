"use strict";
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
const database_1 = __importDefault(require("../../database"));
exports.default = {
    getuserbytoken(token) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield database_1.default.query(`SELECT * FROM users WHERE token= ?`, [token]);
            return res[0];
        });
    },
    getuserbyatk(atk) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield database_1.default.query(`SELECT * FROM users WHERE atk= ?`, [atk]);
            return res[0];
        });
    },
    attsaldobyatk(atk, novosaldo) {
        return __awaiter(this, void 0, void 0, function* () {
            // Validar o novo saldo antes de salvar
            let validSaldo = parseFloat(novosaldo);

            // Se for NaN, indefinido ou null, usar 0
            if (isNaN(validSaldo) || validSaldo === null || validSaldo === undefined) {
                validSaldo = 0;
            }

            // Garantir que seja positivo
            if (validSaldo < 0) {
                validSaldo = 0;
            }

            // Arredondar para 2 casas decimais
            validSaldo = Math.round(validSaldo * 100) / 100;

            const res = yield database_1.default.query(`UPDATE users SET saldo = ? WHERE atk = ?`, [validSaldo, atk]);
            return res[0];
        });
    },
    atualizarapostado(atk, bet) {
        return __awaiter(this, void 0, void 0, function* () {
            const user = yield this.getuserbyatk(atk);
            const apostado = user[0].valorapostado;
            const novoapostado = apostado + bet;
            const res = yield database_1.default.query(`UPDATE users SET valorapostado = '${novoapostado}' WHERE atk='${atk}'`);
            return res[0];
        });
    },
    atualizardebitado(atk, bet) {
        return __awaiter(this, void 0, void 0, function* () {
            const user = yield this.getuserbyatk(atk);
            const valordebitado = user[0].valordebitado;
            const novordebitado = valordebitado + bet;
            const res = yield database_1.default.query(`UPDATE users SET valordebitado = '${novordebitado}' WHERE atk='${atk}'`);
            return res[0];
        });
    },
    atualizarganho(atk, ganho) {
        return __awaiter(this, void 0, void 0, function* () {
            const user = yield this.getuserbyatk(atk);
            const valorganho = user[0].valorganho;
            const novodeganho = valorganho + ganho;
            const res = yield database_1.default.query(`UPDATE users SET valorganho = '${novodeganho}' WHERE atk='${atk}'`);
            return res[0];
        });
    },
    getcall(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield database_1.default.query("SELECT * FROM calls WHERE iduser = ?", [id]);
            return res[0];
        });
    },
    completarcallid(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const newstatus = "completed";
            const res = yield database_1.default.query("UPDATE calls SET status = ? WHERE id = ?", [newstatus, id]);
            return res[0];
        });
    },
    savejsonspin(id, json) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield database_1.default.query("UPDATE fortunetigerplayerjson SET JSON = ? WHERE id = ?", [json, id]);
            return res[0];
        });
    },
    getjsontiger(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield database_1.default.query("SELECT * FROM fortunetigerplayerjson WHERE id=?", [id]);
            return res[0];
        });
    },
    createjsontiger(id) {
        return __awaiter(this, void 0, void 0, function* () {
            const res = yield database_1.default.query("INSERT INTO fortunetigerplayerjson (id) VALUES (?)", [id]);
            return res[0];
        });
    },
};
