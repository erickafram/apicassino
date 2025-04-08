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
Object.defineProperty(exports, "__esModule", { value: true });
exports.default = {
    linhaperda() {
        return __awaiter(this, void 0, void 0, function* () {
            const numeroAleatorio = Math.floor(Math.random() * 20) + 1;
            console.log("LINHA DE PERDA " + numeroAleatorio);
            const jsons = {
                [1]: {
                    wp: null,
                    lw: null,
                    snww: null,
                    ssaw: 0.0,
                    orl: [9, 5, 11, 7, 2, 9, 4, 8, 8, 6, 4, 12, 13, 9, 3, 3, 13, 12, 10, 8, 5, 9, 10, 8, 6, 12, 12, 10, 2, 7],
                    gm: 1,
                    sc: 0,
                    sps: null,
                    rns: null,
                    fs: null,
                    gwt: -1,
                    fb: null,
                    ctw: 0.0,
                    pmt: null,
                    cwc: 0,
                    fstc: null,
                    pcwc: 0,
                    rwsp: null,
                    hashr: "0:9;2;8;13;13;5#5;9;6;9;12;9#11;4;4;3;10;10#7;8;12;3;8;8#MV#12.0#MT#1#MG#0#",
                    ml: 2,
                    cs: 0.3,
                    rl: [9, 5, 11, 7, 2, 9, 4, 8, 8, 6, 4, 12, 13, 9, 3, 3, 13, 12, 10, 8, 5, 9, 10, 8, 6, 12, 12, 10, 2, 7],
                    sid: "1820663932919938560",
                    psid: "1820663932919938560",
                    st: 1,
                    nst: 1,
                    pf: 1,
                    aw: 0.0,
                    wid: 0,
                    wt: "C",
                    wk: "0_C",
                    wbn: null,
                    wfg: null,
                    blb: 99988.0,
                    blab: 99976.0,
                    bl: 99976.0,
                    tb: 12.0,
                    tbb: 12.0,
                    tw: 0.0,
                    np: -12.0,
                    ocr: null,
                    mr: null,
                    ge: [1, 11],
                },
            };
            return jsons[1];
        });
    },
};
