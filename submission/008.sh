# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
tx=$(bitcoin-cli getrawtransaction e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163 true)

# Extrai o terceiro item da witness (redeemScript)
witness_scriptSig=$(echo "$tx" | jq -r ".vin[0].txinwitness[2]")

# Remove o prefixo "63" (OP_IF) do início
redeem_script_no_opif=$(echo "$witness_scriptSig" | sed 's/^63//')

# Remove em seguida "21" (push de 33 bytes) 
redeem_script_no_length=$(echo "$redeem_script_no_opif" | sed 's/^21//')

# Agora os PRIMEIROS 66 caracteres hex são a pubkey (33 bytes)
public_key_hex=${redeem_script_no_length:0:66}

echo $public_key_hex

