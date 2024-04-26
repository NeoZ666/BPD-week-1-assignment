import { readFileSync } from "fs";

describe('Evaluate submission', () => {
    let txid: string;
    let tx: any;

    it('should check if txid is defined', () => {
        // read txid from out.txt
        const data = readFileSync('out.txt', 'utf8');
        txid = data.trim();
        expect(txid).toBeDefined();
        expect(txid.length).toBe(64);
    });

    it('should get transaction details from node', async () => {
        const RPC_USER="alice";
        const RPC_PASSWORD="password";
        const RPC_HOST="http://127.0.0.1:18443";

        const response = await fetch(RPC_HOST, {
            method: 'post',
            body: JSON.stringify({
                jsonrpc: '1.0',
                id: 'curltest',
                method: 'gettransaction',
                params: [txid, null, true]
            }),
            headers: {
                'Content-Type': 'text/plain',
                'Authorization': 'Basic ' + Buffer.from(`${RPC_USER}:${RPC_PASSWORD}`).toString('base64'),
            }
        });

        const result = (await response.json()).result as any;
        expect(result).not.toBeNull();
        expect(result.txid).toBe(txid);

        tx = result;
    });

    it('should check if fee is exactly 21 sats/vByte', () => {
        const fee = tx.fee * -1 * 1e8;
        expect(tx.decoded.vsize * 21).toBe(fee);
    })

    it('should validate 100 BTC output', () => {
        const output = tx.decoded.vout.filter((vout: any) => vout.value === 100)[0];
        expect(output).toBeDefined();
        expect(output.value).toBe(100);
        expect(output.scriptPubKey.address).toBe('bcrt1qq2yshcmzdlznnpxx258xswqlmqcxjs4dssfxt2');
    });

    it('should validate OP_RETURN outpout', () => {
        const output = tx.decoded.vout.filter((vout: any) => vout.value === 0)[0];
        expect(output).toBeDefined();
        expect(output.value).toBe(0);
        expect(output.scriptPubKey.hex.slice(0, 4)).toBe('6a14');
        expect(Buffer.from(output.scriptPubKey.hex.slice(4), 'hex').toString('utf8')).toBe('We are all Satoshi!!');
    });
});