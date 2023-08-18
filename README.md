# SKALE NETWORK SOLIDITY ISSUE
## Setup

1. Clone repo `git clone https://github.com/PolyPup/skale`
2. Install Packages `npm install`
3. Copy .env-example to .env file
4. Add your private key in the .env file
5. Run a test using the hardhat network. `npx hardhat test test/SimpleIssueContract.js`
All tests should pass

<img width="784" alt="hardhatnetwork" src="https://github.com/Polypup/skale/assets/85349906/fd8af640-8dbd-4c2b-be55-5e4056064cfd">


7. Run a test using SKALE network `npx hardhat --network skale test test/SimpleIssueContract.js`
Last 2 tests will fail

<img width="803" alt="skalenetwork" src="https://github.com/Polypup/skale/assets/85349906/df0e36e7-0301-4138-98b7-f30abcd5ae2b">

9. Run a test using FUJI network `npx hardhat --network fuji test test/SimpleIssueContract.js`
All tests pass.


<img width="854" alt="fujinetwork" src="https://github.com/Polypup/skale/assets/85349906/46dadff9-d956-44d4-9862-8691f35f0c5f">
