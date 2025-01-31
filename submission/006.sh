# Which tx in block 257,343 spends the coinbase output of block 256,128?
block_A_hash=$(bitcoin-cli getblockhash 256128)
block_A_data=$(bitcoin-cli getblock $block_A_hash)

block_A_coinbase_txid=$(echo $block_A_data | jq -r '.tx[0]')

block_B_hash=$(bitcoin-cli getblockhash 257343)
block_B_data=$(bitcoin-cli getblock $block_B_hash)
block_B_tx=$(echo $block_B_data | jq -r '.tx[]')

for tx in $block_B_tx; do
    # Obter os detalhes da transação
    raw_tx=$(bitcoin-cli getrawtransaction $tx true)

    # Loop sobre as entradas da transação para verificar se algum gasto é da coinbase transaction
    for input in $(echo $raw_tx | jq -r '.vin[] | @base64'); do
        
        tx_input=$(echo $input | base64 --decode)
        prev_txid=$(echo $tx_input | jq -r '.txid')
        prev_vout=$(echo $tx_input | jq -r '.vout')

        # Verificar se o txid da entrada é o mesmo da coinbase transaction
        if [[ "$prev_txid" == "$block_A_coinbase_txid" ]]; then
            echo $tx
        fi
    done
done
