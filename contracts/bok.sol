// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BokDAONFTV1 is ERC721, ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    uint256 public constant maxSupply = 111;
    uint256 public constant mintPrice = 0.001 ether;
    // uint256 public constant mintPrice = 1.3 ether;

    event NewNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("BokDaoNFTv1", "BokDaoNFTv1") {}

    function mintNFT() public payable {
        // TODO: 운영지갑으로 변경
        address devFund = address(0x619D27fd73359e689E3f08dAE7080cf04A7AC84c);

        require(msg.value == mintPrice, "WRONG_PRICE");
        (bool sent, ) = payable(devFund).call{value: msg.value}("");
        require(sent, "Failed to send Ether");

        safeMint(msg.sender, "version1/metadata.json");
    }

    function safeMint(address to, string memory uri) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        emit NewNFTMinted(msg.sender, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://storage.googleapis.com/bok-dao/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }
}
