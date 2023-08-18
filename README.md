# SKALE NETWORK SOLIDITY ISSUE
## Setup

1. Clone repo `git clone https://github.com/PolyPup/skale`
2. Install Packages `npm install`
3. Copy .env-example to .env file
4. Add your private key in the .env file
5. Run a test using the hardhat network. `npx hardhat test test/SimpleIssueContract.js`
All tests should pass
6. Run a test using SKALE network `npx hardhat --network skale test test/SimpleIssueContract.js`
Last 2 tests will fail
7. Run a test using FUJI network `npx hardhat --network fuji test test/SimpleIssueContract.js`
All tests pass. 

