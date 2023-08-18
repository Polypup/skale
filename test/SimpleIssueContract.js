const { expect } = require("chai");
const { ethers, network } = require("hardhat");
const crypto = require("crypto");

describe("SimpleIssueContract", function () {
  let IssueContract, Issue, owner;

  beforeEach(async function () {
    IssueContract = await ethers.getContractFactory("SimpleIssueContract");

    [owner] = await ethers.getSigners();

    Issue = await IssueContract.deploy(owner.address);
  });

  describe("Successful Functions", function () {
    it("Should successfully compare the signer and recovery address", async function () {
       
      const chainIdHex = await network.provider.send('eth_chainId');
      const chainId = parseInt(chainIdHex, 16);

      const domain = buildDomain(Issue.address, chainId);
      const types = buildType();
      const value = buildValues(owner.address);

      const signature = await owner._signTypedData(domain, types, value);

      const matchSignerVerification = await Issue.connect(owner).matchSignerVerification(signature);
      expect(matchSignerVerification).to.equal(true);

      const comparingAddressesSuccess = await Issue.connect(owner).comparingAddressesSuccess(signature);
      const result = await comparingAddressesSuccess.wait();

      const signer = result.events[0].args.signerAddress;
      const recovery = result.events[0].args.recoveredSigner;

      expect(signer).to.equal(recovery);
    });

    it("Should successfully show that matchAddressSigner returns true", async function () {
       
        const chainIdHex = await network.provider.send('eth_chainId');
        const chainId = parseInt(chainIdHex, 16);
  
        const domain = buildDomain(Issue.address, chainId);
        const types = buildType();
        const value = buildValues(owner.address);
  
        const signature = await owner._signTypedData(domain, types, value);
  
        const matchSignerVerification = await Issue.connect(owner).matchSignerVerification(signature);
        expect(matchSignerVerification).to.equal(true);
  
        const comparingBooleanSuccess = await Issue.connect(owner).comparingBooleanSuccess(signature);
        const result = await comparingBooleanSuccess.wait();

        const booleanResult = result.events[0].args.result;
        
        expect(booleanResult).to.equal(true);
      });
  });

  describe("Failure Functions", function () {
    it("Should work by comparing the signer and recovery but fails on SKALE", async function () {
       
      const chainIdHex = await network.provider.send('eth_chainId');
      const chainId = parseInt(chainIdHex, 16);

      const domain = buildDomain(Issue.address, chainId);
      const types = buildType();
      const value = buildValues(owner.address);

      const signature = await owner._signTypedData(domain, types, value);

      const matchSignerVerification = await Issue.connect(owner).matchSignerVerification(signature);
      expect(matchSignerVerification).to.equal(true);

      const comparingAddressesFailure = await Issue.connect(owner).comparingAddressesFailure(signature);
      const result = await comparingAddressesFailure.wait();

      const signer = result.events[0].args.signerAddress;
      const recovery = result.events[0].args.recoveredSigner;

      expect(signer).to.equal(recovery);
    });

    it("Should successfully show that matchAddressSigner returns true but will fail on SKALE", async function () {
       
        const chainIdHex = await network.provider.send('eth_chainId');
        const chainId = parseInt(chainIdHex, 16);
  
        const domain = buildDomain(Issue.address, chainId);
        const types = buildType();
        const value = buildValues(owner.address);
  
        const signature = await owner._signTypedData(domain, types, value);
  
        const matchSignerVerification = await Issue.connect(owner).matchSignerVerification(signature);
        expect(matchSignerVerification).to.equal(true);
  
        const comparingBooleanFailure = await Issue.connect(owner).comparingBooleanFailure(signature);
        const result = await comparingBooleanFailure.wait();

        const booleanResult = result.events[0].args.result;
        
        expect(booleanResult).to.equal(true);
      });
  });
});

function buildDomain(address, chainId) {
  return {
    name: "DCR",
    version: "1",
    chainId: chainId,
    verifyingContract: address,
  };
}

function buildType() {
  return {
    Resources: [
      { name: "sender", type: "address" }
    ],
  };
}

function buildValues(sender) {
  return {
    sender: sender
  };
}
