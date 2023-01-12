import { expect } from "chai";
import { ethers } from "hardhat";

describe("BokNFTV1", function () {
  it("safeMint", async function () {
    const BokNFTV1 = await ethers.getContractFactory("BokDAONFTV1");

    const hardhatBokNFTV1 = await BokNFTV1.deploy();

    await expect(
      await hardhatBokNFTV1.mintNFT({
        value: ethers.utils.parseEther("1.2"),
      })
    ).to.emit(hardhatBokNFTV1, "NewNFTMinted");
  });
});
