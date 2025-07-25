import promisePool from "../../database";
import { RowDataPacket, ResultSetHeader } from "mysql2";

export default {
  async getuserbytoken(token: string) {
    const res = await promisePool.query<RowDataPacket[]>(`SELECT * FROM users WHERE token= ?`, [token]);
    return res[0];
  },

  async getuserbyatk(atk: string) {
    const res = await promisePool.query<RowDataPacket[]>(`SELECT * FROM users WHERE atk= ?`, [atk]);
    return res[0];
  },

  async attsaldobyatk(atk: string, novosaldo: number) {
    // SALDO É GERENCIADO PELO CASSINO - NÃO ATUALIZAR LOCALMENTE
    // Apenas validar se o valor não é NaN para evitar erros
    if (isNaN(novosaldo)) {
      console.error(`ERRO: Tentativa de atualizar saldo com valor NaN para ATK: ${atk}`)
      return null
    }

    console.log(`INFO: Saldo calculado para ATK ${atk}: ${novosaldo} (não atualizado localmente - gerenciado pelo cassino)`)
    return { affectedRows: 1 } // Simular sucesso sem fazer update
  },

  async atualizarapostado(atk: string, bet: number) {
    const user = await this.getuserbyatk(atk);
    const apostado = user[0].valorapostado;
    const novoapostado = apostado + bet;

    const res = await promisePool.query<ResultSetHeader>(`UPDATE users SET valorapostado = '${novoapostado}' WHERE atk='${atk}'`);
    return res[0];
  },

  async atualizardebitado(atk: string, bet: number) {
    const user = await this.getuserbyatk(atk);
    const valordebitado = user[0].valordebitado;
    const novordebitado = valordebitado + bet;

    const res = await promisePool.query<ResultSetHeader>(`UPDATE users SET valordebitado = '${novordebitado}' WHERE atk='${atk}'`);
    return res[0];
  },

  async atualizarganho(atk: string, ganho: number) {
    const user = await this.getuserbyatk(atk);
    const valorganho = user[0].valorganho;
    const novodeganho = valorganho + ganho;

    const res = await promisePool.query<ResultSetHeader>(`UPDATE users SET valorganho = '${novodeganho}' WHERE atk='${atk}'`);
    return res[0];
  },

  async getcall(id: number) {
    const res = await promisePool.query<RowDataPacket[]>("SELECT * FROM calls WHERE iduser = ?", [id]);
    return res[0];
  },

  async completarcallid(id: number) {
    const newstatus = "completed";
    const res = await promisePool.query<ResultSetHeader>("UPDATE calls SET status = ? WHERE id = ?", [newstatus, id]);
    return res[0];
  },

  async savejsonspin(id: number, json: any) {
    const res = await promisePool.query<ResultSetHeader>("UPDATE wildbanditojson SET JSON = ? WHERE id = ?", [json, id]);
    return res[0];
  },

  async getjsonwildbandito(id: number) {
    const res = await promisePool.query<RowDataPacket[]>("SELECT * FROM wildbanditojson WHERE id=?", [id]);
    return res[0];
  },

  async createjsonwildbandito(id: number) {
    const res = await promisePool.query<ResultSetHeader>("INSERT INTO wildbanditojson (id) VALUES (?)", [id]);
    return res[0];
  },

  async getcallbyid(id: number) {
    const res = await promisePool.query<RowDataPacket[]>("SELECT * FROM calls WHERE id = ?", [id]);
    return res[0];
  },

  async attawcall(id: number, valor: number) {
    const call = await this.getcallbyid(id);
    const aw = call[0].aw;
    const newaw = aw + valor;

    const res = await promisePool.query<ResultSetHeader>(`UPDATE calls SET aw = '${newaw}' WHERE id='${id}'`);
    return res[0];
  },

  async atualizarLinhaGanho(userId: any, linhaGanho: null) {
    const res = await promisePool.query<ResultSetHeader>("UPDATE users SET linha_ganho = ? WHERE id = ?", [linhaGanho, userId]);
    return res[0];
  },

  async obterLinhaGanho(userId: number) {
    const res = await promisePool.query<RowDataPacket[]>("SELECT linha_ganho FROM users WHERE id = ?", [userId]);
    return res[0] && res[0][0] ? res[0][0].linha_ganho : null;
  },
};
