# RPC settings
RPC_USER="alice"
RPC_PASSWORD="password"
RPC_HOST="127.0.0.1:18443"
WALLET="${1:-testwallet}"
out="Output_$WALLET"

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
echo "Running the script with $WALLET"
echo Wallet in use : "$WALLET" > $out.json

# Check Connection
info=$(rpc_call "getblockchaininfo")
echo '"GetBlockChainInfo":'$info >> $out.json

# Create and load wallet
wallet=$(rpc_call "createwallet" \"$WALLET\")
echo '"WalletInfo":'$wallet >> $out.json

# Generate a new address
address=$(rpc_call2 "$WALLET" "getnewaddress")
newaddress=$(echo $address | jq -r '.result')
echo '"NewAddressInfo":'$address >> $out.json

# Mine 103 blocks to the new address
# mine=$(rpc_call2 "$WALLET" "generatetoaddress" "103, \"bcrt1qxzc9u38jswg2f3crnzx32te2e9c0h5mcvm4ne9\"")
mine=$(rpc_call2 "$WALLET" "generatetoaddress" "103, \"$newaddress\"")
echo '"MinedTo":'$mine >> $out.json

# # Send the transaction
# Set the transaction fee
echo '"SetTXNFee":' >> $out.json
rpc_call2 "$WALLET" "settxfee" "0.00021" >> $out.json

# Send bitcoins
txid=$(rpc_call2 "$WALLET" "sendtoaddress" "\"bcrt1qq2yshcmzdlznnpxx258xswqlmqcxjs4dssfxt2\", 100")
echo '"SendBitcoinTo":'$txid >> $out.json

echo "Check the $out.json file for the output"