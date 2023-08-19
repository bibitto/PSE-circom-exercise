const fs = require("fs");
const solidityRegex = /pragma solidity \^\d+\.\d+\.\d+/;

const verifierRegex = /contract (Groth16Verifier|PlonkVerifier)/;
const contracts = [
  "HelloWorldVerifier",
  "Multiplier3Verifier",
  "Multiplier3PlonkVerifier",
];

for (const contract of contracts) {
  try {
    let content = fs.readFileSync(`./contracts/${contract}.sol`, {
      encoding: "utf-8",
    });
    let bumped = content.replace(solidityRegex, "pragma solidity ^0.8.0");
    bumped = bumped.replace(verifierRegex, `contract ${contract}`);

    fs.writeFileSync(`./contracts/${contract}.sol`, bumped);
  } catch (e) {
    console.log(`${contract}.sol not found, skipping`);
  }
}
