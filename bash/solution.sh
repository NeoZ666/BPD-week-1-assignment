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

# Helper function to make RPC calls
rpc_call2() {
  local wallet=$1
  local method=$2
  shift 2
  local params=$@

  curl -s --user $RPC_USER:$RPC_PASSWORD --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"$method\", \"params\": [$params] }" -H 'content-type: text/plain;' http://$RPC_HOST/wallet/$wallet
}

# Check Connection
info=$(rpc_call "getblockchaininfo")
echo $info

# Create and load wallet
wallet=$(rpc_call "createwallet" \"walletName2\")
echo $wallet

unloaded=$(rpc_call "unloadwallet" "$wallet")
echo $unloaded

# Generate a new address
address=$(rpc_call2 "walletName2" "getnewaddress") 
echo $address

# Mine 103 blocks to the new address
mine=$(rpc_call "generatetoaddress" "[103, \"$address\"]")
echo $mine

# # Send the transaction
# txid=$(rpc_call "sendtoaddress" "[\"recipient_address\", amount]")
# echo $txid

# # Output the transaction ID to a file
# echo $txid > out.txt