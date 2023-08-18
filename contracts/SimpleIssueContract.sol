// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

pragma solidity ^0.8.14;

contract SimpleIssueContract is ReentrancyGuard, EIP712 {
    using ECDSA for bytes32;

    event CompareAddresses(address indexed recipient, address signerAddress, address recoveredSigner, bool result);
    event CompareBoolean(address indexed recipient, address signerAddress, bool result);

    address public signerAddress;

    constructor(address _signerAddress)
        EIP712("DCR", "1")
    {
        require(_signerAddress != address(0), "INVALID_SIGNER_ADDRESS");
        signerAddress = _signerAddress;
    }

    /*
    * @dev hashTransaction
    * This function takes the address of a sender as a parameter and generates
    * a unique hash using Ethereum's EIP-712 Typed Data Hashing and Signing.
    * The resulting hash can be used to uniquely identify the transaction,
    * enabling various transaction-related operations such as verification or
    * auditing.
    * 
    * @param sender The address of the sender involved in the transaction.
    * This is encoded along with a pre-defined string "Resources(address sender)"
    * and hashed using the _hashTypedDataV4 method.
    *
    * @return bytes32 Returns a 32-byte hash that represents the transaction.
    */
    function hashTransaction(address sender) private view returns (bytes32) {
        bytes32 hash = _hashTypedDataV4(
            keccak256(
                abi.encode(
                    keccak256("Resources(address sender)"),
                    sender
                )
            )
        );

        return hash;
    }

    /*
    * @dev matchAddresSigner
    * This function is used to verify the authenticity of a signature by
    * comparing the signer's address with a recovered address from a given hash
    * and signature. It plays a crucial role in ensuring the integrity and
    * authenticity of transactions within a decentralized system.
    *
    * @param hash A 32-byte hash that represents the data to be verified. This
    * could be a hash of a transaction or any other data that needs to be signed.
    *
    * @param signature A signature in bytes, provided by the signer. It is
    * used along with the hash to recover the signer's address, which is then
    * compared with the known signer's address.
    *
    * @return bool Returns true if the recovered address matches the known
    * signer's address, indicating that the signature is valid. Otherwise, it
    * returns false, indicating an invalid or unauthorized signature.
    */
    function matchAddresSigner(bytes32 hash, bytes memory signature) private view returns (bool) {
        require(signerAddress != address(0), "must be a valid address");
        return signerAddress == hash.recover(signature);
    }

    /*
    * @dev comparingAddressesSuccess
    * This function is expected to succeed because it does not contain the
    * `require` statement that checks if the recovered signer's address matches
    *
    * The function performs the following steps:
    * 1. Creates a hash using the sender's address with the `hashTransaction`
    *    function.
    * 2. Recovers the signer's address from the hash and provided signature.
    * 3. Compares the known signer address with the recovered signer address,
    *    and reverts with an error message if they don't match.
    * 4. Emits an event with the details of the comparison, including the result.
    *
    * @param signature The provided signature in bytes, to be used in the
    * recovery of the signer's address.
    *
    * @notice Emits a CompareAddresses event with details of the comparison.
    * 
    * @require The function reverts with "DIRECT_CLAIM_DISALLOWED" if the
    * recovered signer's address does not match the known signer's address.
    */
    function comparingAddressesSuccess(bytes calldata signature) external {
        bytes32 hash = hashTransaction(msg.sender);
        address recoveredSigner = hash.recover(signature);

        bool result = signerAddress == recoveredSigner;
        
        emit CompareAddresses(msg.sender, signerAddress, recoveredSigner, result);
    }

    /*
    * @dev comparingAddressesFailure
    * This function is expected to fail and demonstrates the issue at hand where
    * the `require` statement checks if the recovered signer's address matches but
    * fails.
    *
    * @param signature The provided signature in bytes, to be used in the
    * recovery of the signer's address.
    *
    * @notice Emits a CompareAddresses event with details of the comparison.
    * 
    * @require The function reverts with "DIRECT_CLAIM_DISALLOWED" if the
    * recovered signer's address does not match the known signer's address.
    */
    function comparingAddressesFailure(bytes calldata signature) external {
        bytes32 hash = hashTransaction(msg.sender);
        address recoveredSigner = hash.recover(signature);

        require(signerAddress == recoveredSigner, "DIRECT_CLAIM_DISALLOWED");

        bool result = signerAddress == recoveredSigner;
        
        emit CompareAddresses(msg.sender, signerAddress, recoveredSigner, result);
    }

    /*
    * @dev comparingBooleanFailure
    * This function is expected to succeed because it does not contain the
    * `require` statement that checks if the recovered signer's address matches
    *
    * This function checks the authenticity of a given signature by utilizing the
    * `matchAddresSigner` function, which compares the known signer's address with
    * the recovered signer's address obtained from a given hash and signature.
    *
    * @param signature The provided signature in bytes to be verified.
    *
    * @notice Emits a CompareBoolean event with details of the comparison.
    */
    function comparingBooleanSuccess(bytes calldata signature) external {
        bool matchAddress = matchAddresSigner(hashTransaction(msg.sender), signature);
        
        emit CompareBoolean(msg.sender, signerAddress, matchAddress);
    }

    /*
    * @dev comparingBooleanFailure
    * This function is expected to fail and demonstrates the issue at hand where
    * the `require` statement checks if the recovered signer's address matches but
    * fails.
    *
    * @param signature The provided signature in bytes to be verified.
    *
    * @notice Emits a CompareBoolean event with details of the comparison.
    *
    * @require The function reverts with "DIRECT_CLAIM_DISALLOWED" if the
    * recovered signer's address does not match the known signer's address.
    */
    function comparingBooleanFailure(bytes calldata signature) external {
        bool matchAddress = matchAddresSigner(hashTransaction(msg.sender), signature);

        require(matchAddress, "DIRECT_CLAIM_DISALLOWED");
        
        emit CompareBoolean(msg.sender, signerAddress, matchAddress);
    }

    /*
    * @dev matchSignerVerification
    * This function acts as an external interface to verify a signature for a given
    * transaction involving the sender's address. It uses the private function
    * `matchAddresSigner` in conjunction with `hashTransaction` to carry out this verification.
    *
    * Use this function to compare the signer's address with the recovered address
    *
    * This combination of hashing and signature verification ensures that the
    * signature is valid and corresponds to the correct sender, enhancing the
    * security and integrity of the transaction.
    *
    * @param signature The provided signature in bytes, to be verified against
    * the hash of the sender's transaction.
    *
    * @return bool Returns true if the signature is valid and corresponds to the
    * sender's address; otherwise, returns false.
    */
    function matchSignerVerification(bytes calldata signature) external view returns (bool) {
        return matchAddresSigner(hashTransaction(msg.sender), signature);
    }

}
