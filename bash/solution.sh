# RPC settings
RPC_USER="alice"
RPC_PASSWORD="password"
RPC_HOST="127.0.0.1:18443"

# Helper function to make RPC calls
rpc_call() {
  local method=$1
  shift
  local params=$@

  curl -s --user $RPC_USER:$RPC_PASSWORD --data-binary "{\"jsonrpc\": \"1.0\", \"id\":\"curltest\", \"method\": \"$method\", \"params\": $params }" -H 'content-type: text/plain;' http://$RPC_HOST/
}

# Check Connection
info=$(rpc_call "getblockchaininfo" "[\"\"]")
echo $info

# # Create and load wallet
# wallet=($rpc_call "createwallet" "[\"testwallet\"]")
# echo $wallet

# # Generate a new address
# address=$(rpc_call "getnewaddress" "[\"\"]") 
# echo $address

# # Mine 103 blocks to the new address
# mine=$(rpc_call "generatetoaddress" "[103, \"$address\"]")
# echo $mine

# # Send the transaction
# txid=$(rpc_call "sendtoaddress" "[\"recipient_address\", amount]")
# echo $txid

# # Output the transaction ID to a file
# echo $txid > out.txt