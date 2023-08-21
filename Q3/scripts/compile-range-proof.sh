#!/bin/bash

cd contracts/circuits

mkdir RangeProof_plonk

if [ -f ./powersOfTau28_hez_final_10.ptau ]; then
    echo "powersOfTau28_hez_final_10.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_10.ptau'
    curl -OL https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_10.ptau
fi

echo "Compiling RangeProof.circom..."

# compile circuit

circom RangeProof.circom --r1cs --wasm --sym -o RangeProof_plonk
snarkjs r1cs info RangeProof_plonk/RangeProof.r1cs

# Start a new zkey and make a contribution

snarkjs plonk setup RangeProof_plonk/RangeProof.r1cs powersOfTau28_hez_final_10.ptau RangeProof_plonk/circuit_0000.zkey
snarkjs zkey export verificationkey RangeProof_plonk/circuit_0000.zkey RangeProof_plonk/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier RangeProof_plonk/circuit_0000.zkey ../RangeProofPlonkVerifier.sol

cd ../..