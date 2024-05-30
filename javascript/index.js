const axios = require('axios');
const fs = require('fs');

const RPC_USER = "alice";
const RPC_PASSWORD = "password";
const RPC_HOST = "http://127.0.0.1:18443";
const WALLET = process.argv[2] || "testwallet";
const out = `Output_${WALLET}.txt`;

const rpc_call = async (method, params = []) => {
  const response = await axios.post(RPC_HOST, {
    jsonrpc: "1.0",
    id: "curltest",
    method: method,
    params: params
  }, {
    auth: {
      username: RPC_USER,
      password: RPC_PASSWORD
    },
    headers: {
      'Content-Type': 'text/plain'
    }
  });
  return response.data;
};

const rpc_call2 = async (wallet, method, params = []) => {
  const response = await axios.post(`${RPC_HOST}/wallet/${wallet}`, {
    jsonrpc: "1.0",
    id: "curltest",
    method: method,
    params: params
  }, {
    auth: {
      username: RPC_USER,
      password: RPC_PASSWORD
    },
    headers: {
      'Content-Type': 'text/plain'
    }
  });
  return response.data;
};

const main = async () => {
  let output = {};

  output.WalletInUse = WALLET;

  const info = await rpc_call("getblockchaininfo");
  output.GetBlockChainInfo = info;

  const wallet = await rpc_call("createwallet", [WALLET]);
  output.WalletInfo = wallet;

  const address = await rpc_call2(WALLET, "getnewaddress");
  const newaddress = address.result;
  output.NewAddressInfo = address;

  const mine = await rpc_call2(WALLET, "generatetoaddress", [103, newaddress]);
  output.MinedTo = mine;

  await rpc_call2(WALLET, "settxfee", [0.00021]);

  const txid = await rpc_call2(WALLET, "sendtoaddress", ["bcrt1qq2yshcmzdlznnpxx258xswqlmqcxjs4dssfxt2", 100]);
  output.SendBitcoinTo = txid;

  fs.writeFileSync(out, JSON.stringify(output, null, 2));

  console.log(`Check the ${out} file for the output`);
};

main().catch(console.error);