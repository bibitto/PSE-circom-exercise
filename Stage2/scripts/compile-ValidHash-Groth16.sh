#!/bin/bash

cd contracts/circuits

mkdir ValidHash_groth16

if [ -f ./powersOfTau28_hez_final_18.ptau ]; then
    echo "powersOfTau28_hez_final_18.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_18.ptau'
    curl -OL https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_18.ptau
fi

echo "Compiling ValidHash.circom..."

# compile circuit

circom ValidHash.circom --r1cs --wasm --sym -o ValidHash_groth16
snarkjs r1cs info ValidHash_groth16/ValidHash.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup ValidHash_groth16/ValidHash.r1cs powersOfTau28_hez_final_18.ptau ValidHash_groth16/circuit_0000.zkey
snarkjs zkey contribute ValidHash_groth16/circuit_0000.zkey ValidHash_groth16/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey ValidHash_groth16/circuit_final.zkey ValidHash_groth16/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier ValidHash_groth16/circuit_0000.zkey ../ValidHashGroth16Verifier.sol

cd ../..

node scripts/bonus-bump-solidity.js