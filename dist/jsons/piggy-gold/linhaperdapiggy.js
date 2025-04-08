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
            const numeroAleatorio = Math.floor(Math.random() * 501) + 1;
            const jsons = {
                [0]: {
                    wp: null,
                    lw: null,
                    frl: [3, 6, 2, 3, 7, 4, 5, 3, 5],
                    pc: null,
                    wm: null,
                    tnbwm: null,
                    gwt: -1,
                    ctw: 0.0,
                    pmt: null,
                    cwc: 0,
                    fstc: null,
                    pcwc: 0,
                    rwsp: null,
                    hashr: "0:6;7;3#MV#0.6#MT#1#MG#0#",
                    fb: null,
                    ml: 2,
                    cs: 0.3,
                    rl: [6, 7, 3],
                    sid: "1836962956945849856",
                    psid: "1836962956945849856",
                    st: 1,
                    nst: 1,
                    pf: 1,
                    aw: 0.0,
                    wid: 0,
                    wt: "C",
                    wk: "0_C",
                    wbn: null,
                    wfg: null,
                    blb: 100000.0,
                    blab: 99999.4,
                    bl: 99999.4,
                    tb: 0.6,
                    tbb: 0.6,
                    tw: 0.0,
                    np: -0.6,
                    ocr: null,
                    mr: null,
                    ge: [1, 11],
                },
            };
            return jsons[0];
        });
    },
};
