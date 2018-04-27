var TestToken = artifacts.require("./TestToken.sol");

module.exports = function(deployer) {
  deployer.deploy(TestToken,
    "0x49aabbbe9141fe7a80804bdf01473e250a3414cb",
    "0x49aabbbe9141fe7a80804bdf01473e250a3414cb",
    20000,
    1000
  );
};
