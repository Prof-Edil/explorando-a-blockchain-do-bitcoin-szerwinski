# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
tx=$(bitcoin-cli getrawtransaction e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 true)

witness_scriptSig=$(echo $tx | jq -r ".vin[0].txinwitness[2]")

public_key_hex=$(echo $witness_scriptSig | sed 's/^63//')

public_key_hex=${public_key_hex:0:66}

echo  $public_key_hex
