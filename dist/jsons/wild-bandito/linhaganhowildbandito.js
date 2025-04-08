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
    linhaganho(bet) {
        return __awaiter(this, void 0, void 0, function* () {
            const numeroAleatorio = Math.floor(Math.random() * 5) + 1;
            console.log("linha de ganho " + bet);
            const jsons = {
                [1]: {
                    [0]: {
                        wp: {
                            "8": [2, 7, 11, 13],
                        },
                        lw: {
                            "8": 2.4,
                        },
                        sc: 0,
                        orl: [10, 5, 8, 3, 10, 6, 9, 8, 2, 9, 5, 8, 5, 8, 3, 4, 10, 7, 2, 10, 4, 9, 10, 8, 6],
                        gm: 1,
                        ssb: {
                            "1": 5,
                            "2": 7,
                            "3": 8,
                            "4": 12,
                            "5": 19,
                        },
                        ss: {
                            "1": 5,
                            "3": 8,
                            "4": 12,
                            "5": 19,
                        },
                        ptbr: [2, 11, 13],
                        snww: {
                            "8": 2,
                        },
                        ssaw: 2.4,
                        rs: null,
                        fs: null,
                        gwt: -1,
                        ctw: 2.4,
                        pmt: null,
                        cwc: 1,
                        fstc: null,
                        pcwc: 1,
                        rwsp: {
                            "8": 2.0,
                        },
                        hashr: "0:5;9;8;10;9#8;8;5;7;10#3;2;8;2;8#10;9;3;10;6#R#8#01112022#MV#12.0#MT#1#MG#2.4#",
                        fb: null,
                        ml: 2,
                        cs: 0.3,
                        rl: [10, 5, 8, 3, 10, 6, 9, 0, 2, 9, 5, 8, 5, 8, 3, 4, 10, 7, 2, 10, 4, 9, 10, 8, 6],
                        sid: "1838408651687001600",
                        psid: "1838408651687001600",
                        st: 1,
                        nst: 4,
                        pf: 1,
                        aw: 2.4,
                        wid: 0,
                        wt: "C",
                        wk: "0_C",
                        wbn: null,
                        wfg: null,
                        blb: 99982.0,
                        blab: 99970.0,
                        bl: 99972.4,
                        tb: 12.0,
                        tbb: 12.0,
                        tw: 2.4,
                        np: -9.6,
                        ocr: null,
                        mr: null,
                        ge: [1, 11],
                    },
                    [1]: {
                        wp: {
                            "3": [3, 7, 14],
                            "5": [2, 7, 11, 12, 13],
                        },
                        lw: {
                            "3": 4.8,
                            "5": 9.0,
                        },
                        sc: 0,
                        orl: [10, 10, 5, 3, 10, 6, 9, 0, 2, 9, 4, 5, 5, 5, 3, 4, 10, 7, 2, 10, 4, 9, 10, 8, 6],
                        gm: 2,
                        ssb: {
                            "1": 5,
                            "3": 8,
                            "4": 13,
                            "5": 19,
                        },
                        ss: {
                            "1": 5,
                            "3": 8,
                            "5": 19,
                        },
                        ptbr: [3, 7, 14, 2, 11, 12],
                        snww: {
                            "3": 1,
                            "5": 3,
                        },
                        ssaw: 30.0,
                        rs: {
                            sspt: {
                                "4": {
                                    op: 12,
                                    np: 13,
                                },
                            },
                            rns: [[10], [], [4, 5], [], []],
                            rnss: [[], [], [], [], []],
                            bsb: [2],
                        },
                        fs: null,
                        gwt: -1,
                        ctw: 27.6,
                        pmt: null,
                        cwc: 2,
                        fstc: {
                            "4": 1,
                        },
                        pcwc: 0,
                        rwsp: {
                            "3": 8.0,
                            "5": 5.0,
                        },
                        hashr: "1:10;9;5;10;9#5;0;5;7;10#3;2;5;2;8#10;9;3;10;6#R#3#021123#MV#0#MT#2#R#5#0111202122#MV#0#MT#2#MG#27.6#",
                        fb: null,
                        ml: 2,
                        cs: 0.3,
                        rl: [10, 10, 5, 3, 10, 6, 9, 0, 2, 9, 4, 5, 5, 0, 3, 4, 10, 7, 2, 10, 4, 9, 10, 8, 6],
                        sid: "1838408657475141120",
                        psid: "1838408651687001600",
                        st: 4,
                        nst: 4,
                        pf: 1,
                        aw: 30.0,
                        wid: 0,
                        wt: "C",
                        wk: "0_C",
                        wbn: null,
                        wfg: null,
                        blb: 99972.4,
                        blab: 99972.4,
                        bl: 100000.0,
                        tb: 0.0,
                        tbb: 12.0,
                        tw: 27.6,
                        np: 27.6,
                        ocr: null,
                        mr: null,
                        ge: [1, 11],
                    },
                    [2]: {
                        wp: null,
                        lw: null,
                        sc: 0,
                        orl: [10, 8, 10, 10, 10, 8, 6, 9, 2, 9, 5, 10, 3, 4, 0, 4, 10, 7, 2, 10, 4, 9, 10, 8, 6],
                        gm: 3,
                        ssb: {
                            "1": 6,
                            "3": 8,
                            "5": 19,
                        },
                        ss: {
                            "1": 6,
                            "3": 8,
                            "5": 19,
                        },
                        ptbr: null,
                        snww: null,
                        ssaw: 30.0,
                        rs: {
                            sspt: {
                                "1": {
                                    op: 5,
                                    np: 6,
                                },
                            },
                            rns: [[10, 8], [8], [5, 10, 3], [], []],
                            rnss: [[], [], [], [], []],
                            bsb: [4],
                        },
                        fs: null,
                        gwt: -1,
                        ctw: 0.0,
                        pmt: null,
                        cwc: 0,
                        fstc: {
                            "4": 2,
                        },
                        pcwc: 0,
                        rwsp: null,
                        hashr: "2:8;6;10;10;9#10;9;3;7;10#10;2;4;2;8#10;9;0;10;6#MV#0#MT#3#MG#0#",
                        fb: null,
                        ml: 2,
                        cs: 0.3,
                        rl: [10, 8, 10, 10, 10, 8, 6, 9, 2, 9, 5, 10, 3, 4, 0, 4, 10, 7, 2, 10, 4, 9, 10, 8, 6],
                        sid: "1838408664613846528",
                        psid: "1838408651687001600",
                        st: 4,
                        nst: 1,
                        pf: 1,
                        aw: 30.0,
                        wid: 0,
                        wt: "C",
                        wk: "0_C",
                        wbn: null,
                        wfg: null,
                        blb: 100000.0,
                        blab: 100000.0,
                        bl: 100000.0,
                        tb: 0.0,
                        tbb: 12.0,
                        tw: 0.0,
                        np: 0.0,
                        ocr: null,
                        mr: null,
                        ge: [1, 11],
                    },
                },
            };
            return jsons[bet];
        });
    },
};
