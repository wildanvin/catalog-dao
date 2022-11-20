# catalog-dao
## Deploy 
In order to deploy to the wallaby testnet you need to make a `.env` file with your private key
```
PRIVATE_KEY=_REPLACE_WITH_YOUR_PRIVATE_KEY_
```
Now to install the dependancies:
```
yarn install
```
And finally to deploy
```
hh deploy --network wallaby
```
Take into account that you can change the `01_deploy_data_log.js` file in order to change the members of the DAO and the number of confirmations required
## Long DEMO

A video demonstrating the project is available in [youtube](https://www.youtube.com/watch?v=sXZOGx0Af0A). The data in order to follow along with the video:
1. Submit a transaction to the dao 
 - CID: `0x000181E2039220206B86B273FF34FCE19D6B804EFF5A3F5747ADA4EAA22F1D49C01E52DDB7875B4B`
 - size: `2048`

2. Be the SP. The market calls with a cbor and the address of the client
 - cbor: `0x8240584c8bd82a5828000181e2039220206b86b273ff34fce19d6b804eff5a3f5747ada4eaa22f1d49c01e52ddb7875b4b190800f4420068420066656c6162656c0a1a0008ca0a42000a42000a42000a`
 - provider: `0x0066`
 - address of the client

3. Verify in DatalogDAO
 - CID: `0x000181E2039220206B86B273FF34FCE19D6B804EFF5A3F5747ADA4EAA22F1D49C01E52DDB7875B4B`
 - provider: `0x0066`

## Resources
This project is based on the FEVM-Hardhat-Kit repo available [here](https://github.com/filecoin-project/FEVM-Hardhat-Kit). We also followed the guide about DataDAOs from [here](https://github.com/lotus-web3/client-contract). Really good resources for understanding FEVM and DataDAOs.


