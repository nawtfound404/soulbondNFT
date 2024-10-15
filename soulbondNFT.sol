// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract SoulBoundNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // Mapping to track the soul-bound tokens (non-transferable)
    mapping(uint256 => bool) private _soulBoundTokens;

    constructor() ERC721("SoulBound", "SBNFT") {
        // Additional initialization code if needed
    }

    // Function to mint a new soul-bound NFT
    function mintSoulBoundNFT(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _soulBoundTokens[tokenId] = true;  // Mark the token as soul-bound
        _tokenIdCounter.increment();
    }

    // Override transferFrom to prevent transferring soul-bound NFTs
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(!_soulBoundTokens[tokenId], "This token is soul-bound and cannot be transferred.");
        super.transferFrom(from, to, tokenId);  // Calls the ERC721 transfer function for non-soul-bound tokens
    }

    // Optional: function to check if a token is soul-bound
    function isSoulBound(uint256 tokenId) public view returns (bool) {
        return _soulBoundTokens[tokenId];
    }

    // Optional: Burn the token (only the owner can burn)
    function burnSoulBoundNFT(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "Only the owner can burn the token.");
        _burn(tokenId);
    }
}
