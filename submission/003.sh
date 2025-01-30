# How many new outputs were created by block 123,456?
hash=$(bitcoin-cli getblockhash 123456)
block=$(bitcoin-cli getblock $hash)
tx=$(echo $block | jq -r '.tx[]')
utxo_counter=0
for transaction in $tx ; do
	internal=$(echo $(bitcoin-cli getrawtransaction $transaction true))
	vout_count=$(echo "$internal" | jq '.vout | length')
	((utxo_counter+=vout_count))
done
echo $utxo_counter
