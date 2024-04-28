from bitcoinrpc.authproxy import AuthServiceProxy, JSONRPCException
import json

# Node access params
RPC_URL = "http://alice:password@127.0.0.1:18443"

def send(rpc, addr, data):
    args = [
        {addr: 100},    # recipient address
        None,           # conf target
        None,
        21,             # fee rate in sats/vb
        None            # Empty option object
    ]
    send_result = rpc.send('send', args)
    assert send_result['complete']
    return send_result['txid']

def list_wallet_dir(rpc):
    result = rpc.listwalletdir()
    return [wallet['name'] for wallet in result['wallets']]

def main():
    rpc = AuthServiceProxy(RPC_URL)

    # Check connection
    info = rpc.getblockchaininfo()
    print(info)

    # Create or load the wallet

    # Generate a new address

    # Mine 101 blocks to the new address to activate the wallet with mined coins

    # Prepare a transaction to send 100 BTC

    # Send the transaction

    # Write the txid to out.txt

if __name__ == "__main__":
    main()