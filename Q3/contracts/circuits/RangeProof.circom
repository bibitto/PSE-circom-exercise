pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";

template RangeProof(n) {
    assert(n <= 252);
    signal input in; // this is the number to be proved inside the range
    signal input range[2]; // the two elements should be the range, i.e. [lower bound, upper bound]
    signal output out;

    component lt = LessEqThan(n);
    component gt = GreaterEqThan(n);

    // if true -> return 1
    lt.in[0] <== in;
    lt.in[1] <== range[1];

    // if true -> return 1
    gt.in[0] <== in;
    gt.in[1] <== range[0];

    // if true -> return 1
    out <== lt.out * gt.out;
}

component main { public [ range ] } = RangeProof(32);

/* INPUT = {
    "in": "5",
    "range": ["i", "10"]
} */