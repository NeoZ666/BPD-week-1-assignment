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

# Create and load wallet

# Generate a new address

# Mine 103 blocks to the new address

# Send the transaction

# Output the transaction ID to a file
