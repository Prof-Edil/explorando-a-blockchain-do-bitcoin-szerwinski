# Only one single output remains unspent from block 123,321. What address was it sent to?
blockhash=$(bitcoin-cli getblockhash 123321)
block=$(bitcoin-cli getblock $blockhash)

# Obter todas as transações no bloco
block_tx=$(echo $block | jq -r '.tx[]')

for tx in $block_tx; do
    	# Obter a transação em formato bruto
    	raw_tx=$(bitcoin-cli getrawtransaction $tx true)

	# Loop para iterar sobre as saídas de cada transação
	for output in $(echo $raw_tx | jq -r '.vout[] | @base64'); do

		# Decodificar o objeto base64 para acessar os dados da saída
    		output_data=$(echo $output | base64 --decode)

    		# Verificar se o campo "address" existe em "scriptPubKey"
    		address=$(echo $output_data | jq -r '.scriptPubKey.address // empty')

   		# Se o "address" existir, verifica a existencia de utxo's
    		if [[ -n "$address" ]]; then
        	
			utxos=$(curl -s https://blockchain.info/unspent?active=$address)	
	
			# Verificar se há UTXOs e iterar sobre eles
            		for utxo in $(echo $utxos | jq -r '.unspent_outputs[] | @base64'); do

				utxo_data=$(echo $utxo | base64 --decode)
					
                		utxo_tx_hash=$(echo $utxo_data | jq -r '.tx_hash_big_endian')
				utxo_tx_output_index=$(echo $utxo_data | jq -r '.tx_output_n')

				echo $address

				## Para conferir na mempool: https://mempool.space/pt/tx/097e521fee933133729cfc34424c4277b36240b13ae4b01fda17756da1848c1e#flow=&vout=0
            		done
    		fi
	done
done
