# rei-mainnet Address
0x0077c251e9fC74749016Dcf23A0dBD484896F6bD

# rei-testnet Address
0x1616abD0FDEf48B58E2a44077a31E603f62d9F73


This project is deployed to calculate the number of rei corresponding to the shares voted by the user for the first 21 nodes, which is used for snapshot statistics

# How to use

1. Install the dependencies

```bash
npm install
```

2. Compile the contract

```bash
npm run compile
```


3. Deploy the contract

```bash
npm run deploy -- --network rei-testnet
npm run deploy -- --network rei-mainnet
```

4. Run the task example

```bash
npx hardhat snapvote --address 0x38486e3669a13a8E049C39F271E9318B2Eb18B3b --network rei-testnet
```