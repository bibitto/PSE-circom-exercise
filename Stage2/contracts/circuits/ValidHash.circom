pragma circom 2.0.0;

// include "../../node_modules/circomlib/circuits/poseidon.circom";

// template ValidHash() {
//     signal input in;
//     signal output out;

//     component hash = Poseidon(1);

//     hash.inputs[0] <== in;
//     out <== hash.out;
// }

// component main = ValidHash();

include "../../node_modules/circomlib/circuits/sha256/sha256.circom";
include "../../node_modules/circomlib/circuits/bitify.circom";

template ValidHash(n) {
    signal input in;
    signal output out[256];

    component n2b = Num2Bits(n+1);
    component sha256 = Sha256(n);

    n2b.in <== in;
    for (var i; i < n; i++) {
        sha256.in[i] <== n2b.out[i];
    }

    for (var i; i < 256; i++) {
        out[i] <== sha256.out[i];
    }
}

component main = ValidHash(32);