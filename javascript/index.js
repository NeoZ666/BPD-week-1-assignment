const fs = require('fs');
const Client = require('bitcoin-core');

const client = new Client({
  network: 'regtest',
  port: 18443,
  host: 'localhost',
  username: 'alice',
  password: 'password'
});

async function checkNodeReady() {
  let ready = false;
  while (!ready) {
    try {
      await client.getBlockchainInfo();
      ready = true;
    } catch (error) {
      if (error.code === -28) {
        console.log('Waiting for the node to be ready...');
        await new Promise(resolve => setTimeout(resolve, 5000));
      } else {
        throw error;

      }
    }
  }

  async function main() {
    await checkNodeReady();
    try {
      await client.createWallet('test5wallet', false, false, '', false, true);
    } catch (error) {
      console.log(error);
    }
    // Create and load a wallet named “testwallet.”
    await client.loadWallet('test5wallet');

    // Generate an address from the wallet.
    const { result: { address } } = await client.getNewAddress();



    // Mine blocks to that address.
    await client.generateToAddress(101, address);

    // Create a transaction with the specified outputs.
    const recipientAddress = 'bcrt1qq2yshcmzdlznnpxx258xswqlmqcxjs4dssfxt2'; // Replace with the actual recipient address
    const sendAmount = 100;
    const message = Buffer.from('We are all Satoshi!!').toString('hex');
    const rawTransaction = await client.createRawTransaction([], [{ [recipientAddress]: sendAmount, data: message }]);

    // Set the fee rate to 21 sats/vB.
    const options = { conf_target: 21, replaceable: true };
    const fundedTransaction = await client.fundRawTransaction(rawTransaction, options);

    // Broadcast the transaction.
    const txid = await client.sendRawTransaction(fundedTransaction.hex);

    // Output the transaction ID (txid) to an out.txt file.
    fs.writeFileSync('out.txt', txid);
  }
}
main().catch(console.error);