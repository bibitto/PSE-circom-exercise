#!/bin/bash

cd contracts/circuits

mkdir ValidHash_plonk

if [ -f ./powersOfTau28_hez_final_18.ptau ]; then
    echo "powersOfTau28_hez_final_18.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_18.ptau'
    curl -OL https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_18.ptau
fi

echo "Compiling ValidHash.circom..."

# compile circuit

circom ValidHash.circom --r1cs --wasm --sym -o ValidHash_plonk
snarkjs r1cs info ValidHash_plonk/ValidHash.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup ValidHash_plonk/ValidHash.r1cs powersOfTau28_hez_final_18.ptau ValidHash_plonk/circuit_0000.zkey
snarkjs zkey export verificationkey ValidHash_plonk/circuit_0000.zkey ValidHash_plonk/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier ValidHash_plonk/circuit_0000.zkey ../ValidHashPlonkVerifier.sol

cd ../..

node scripts/bonus-bump-solidity.js