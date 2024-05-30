# RPC settings
RPC_USER="alice"
RPC_PASSWORD="password"
RPC_HOST="127.0.0.1:18443"

# Helper function to make RPC calls
rpc_call() {
  local method=$1
  shift
  local params=$@

  curl -s --user $RPC_USER:$RPC_PASSWORD --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"$method\", \"params\": [$params] }" -H 'content-type: text/plain;' http://$RPC_HOST/
}

rpc_call2() {
  local wallet=$1
  local method=$2
  shift 2
  local params="$*"

  curl -s --user $RPC_USER:$RPC_PASSWORD --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"$method\", \"params\": [$params] }" -H 'content-type: text/plain;' http://$RPC_HOST/wallet/$wallet
}

# Helper function to make RPC calls

# Check Connection
info=$(rpc_call "getblockchaininfo")
echo $info

# Create and load wallet
wallet=$(rpc_call "createwallet" \"walletName6\")
echo $wallet

# Generate a new address
newaddress=$(rpc_call2 "walletName6" "getnewaddress" | jq -r '.result')
echo $newaddress

# Mine 103 blocks to the new address
# mine=$(rpc_call2 "walletName6" "generatetoaddress" "103, \"bcrt1qxzc9u38jswg2f3crnzx32te2e9c0h5mcvm4ne9\"")
mine=$(rpc_call2 "walletName6" "generatetoaddress" "103, \"$newaddress\"")
echo $mine

# minewallet6=$(curl -s --user $RPC_USER:$RPC_PASSWORD --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "generatetoaddress", "params": [103, "bcrt1q3dfmp23rz59xzd5sp7yfjv5hy2p87lmw2qmfnp"]}' -H 'content-type: text/plain;' http://127.0.0.1:18443/wallet/walletName6)
# echo $minewallet6

# # Send the transaction
# Set the transaction fee
rpc_call2 "walletName6" "settxfee" "0.00021"

# Send bitcoins
txid=$(rpc_call2 "walletName6" "sendtoaddress" "\"bcrt1qq2yshcmzdlznnpxx258xswqlmqcxjs4dssfxt2\", 100")
echo $txid

# Output the transaction ID to a file
echo $txid > out.txt