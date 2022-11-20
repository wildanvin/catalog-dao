  
[![catalog-log.png](https://i.postimg.cc/L8yYx2s3/catalog-log.png)](https://postimg.cc/Wdk13Rgd)
# Catalog - *FEVM Hackathon*

**Catalog** is a dMRV Data DAO. Catalog is an incentivized network of regeneration advocates, storage providers, and researchers, working to support local carbon projects.

## Pitch Video (4min)

Watch our pitch - https://www.youtube.com/watch?v=knBCA6jphoY

## Demo Video (10min)
If you have the patience to wait for transaction to complete watch our demo video -  https://www.youtube.com/watch?v=sXZOGx0Af0A
  
## Problem are solving

Nature-based carbon projects lack efficiency, transparency, and integrity.

dMRV platforms (Digital measurement, reporting and verification)can help with these issues. However, data sources, data storage, and computing over data in dMRV platforms is mostly centralized, expensive and hard to access.
  
## What does it do?

With **catalog**, we aim to enable carbon project developers to procure, store, analyze, and self-govern their data with an incentivized dMRV platform (Digital measurement, reporting, and verification). 

With **catalog**: 

- DAO members are enabled to procure high-quality data, research resources, and open computing over data to support carbon projects.

- Geo-referenced data providers are incentivized to supply carbon project developers with high-quality data. 

- Researchers are incentivized to provide computing jobs to analyze project data and validate carbon storage

- Storage providers are incentivized to store project data and results from computing analysis in the long term

## How would it work?

[![Howdoesitwork.jpg](https://i.postimg.cc/mD3T6ywW/Howdoesitwork.jpg)](https://postimg.cc/vgBR49k0)

At the core of **Catalog**, there is a geo-referenced ERC-721 smart contract that represents a reforestation project. An NFT with coordinates and an ecological state variable. This is a fractionalized ownership NFT as well. Fractions of the NFT can be offered to fund the DAO or as a reward for DAO activities. 

A DAO Avatar contract owns the geo-referenced NFT. 

We use a Superfluid Super token to stream a CO2 equivalent token to the DAO treasury at the same rate as carbon is stored by a reforestation initiative, once a project is verified. The CO2e token is an ERC20 token controlled by the NFT contract and is the Loot of the DAO. It can be used to fund DAO activities as well. 

We deployed an Operator Chainlink contract to call off-chain data using an External Adapter and our own Chainlink node running on Google Cloud. 

For this iteration, we are calling a Satellite Data API called Agromonitoring but in the future, External Adapters can be used for other types of geo-referenced sensor data. 

We then, store data from the off-chain source on IPFS NFTStorage. We use the FEVM to let the DAO and its members complete storage deals, verify deals and distribute Storage Provider rewards in the form of CO2e tokens. 

We then use the data stored in NFTStorage to run a visual computing job using Project Bacalhau and OpenCV. The computing job returns an image that gets stored in NFTStorage as well as a score that updated the Ecological State variable in the NFT smart contract. 

The DAO can decide upon voting on how to distribute rewards for activities like providing data, storing it, running computing jobs, and updating the ecological state of a project. 


 