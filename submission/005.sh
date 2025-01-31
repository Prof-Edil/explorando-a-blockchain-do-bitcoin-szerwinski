# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
#!/bin/bash

# TXID da transação original
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Recuperar os inputs dessa transação
inputs=$(bitcoin-cli getrawtransaction $TXID true | jq '.vin')

pubkeys=()

for input in $(echo $inputs | jq -r '.[] | @base64'); do
    # Decode base64 input
    _jq() {
        echo ${input} | base64 --decode | jq -r ${1}
    }

    # Obter o witness do input
    witness=$(_jq '.txinwitness')

    # Extraindo a chave pública
    pubkey=$(echo $witness | jq -r '.[1]')
    
    # Adicionando a chave pública ao array
    pubkeys+=("\"$pubkey\"")
done

# Criar a string para o comando createmultisig
pubkeys_str=$(IFS=,; echo "[${pubkeys[*]}]")

result=$(bitcoin-cli createmultisig 1 "$pubkeys_str")

echo $result | jq ".address" | tr -d '"'


