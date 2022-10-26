# rei-mainnet Address
//version 1.0.0
0x0077c251e9fC74749016Dcf23A0dBD484896F6bD

//version 2.0.0
0x60Be96c55eFbf4B197F66057598964FE4331AFca
owner:0x443Ee467C95fC19C39D0B84cD20D9f5ced207581

# rei-testnet Address
//version 1.0.0
0x1616abD0FDEf48B58E2a44077a31E603f62d9F73

//version 2.0.0
0xD253697Efc1EFB34d602338DdE8cF564098CBC86


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