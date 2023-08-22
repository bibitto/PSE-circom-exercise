pragma circom 2.0.0;

template ValidPrivateKey() {
    signal input privKey;
    signal input generator;
    signal output pubKey;

    pubKey <== privKey * generator;
}

component main { public [ generator ] } = ValidPrivateKey();