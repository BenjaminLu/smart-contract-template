pragma solidity ^0.4.23;

import "./StandardToken.sol";

contract TestToken is StandardToken {

    // metadata
    string public constant name = "TEST Token";
    string public constant symbol = "TEST";
    uint256 public constant decimals = 18;
    string public version = "1.0";

    // contracts
    address public ethFundDeposit;      // beneficiary address.
    address public testFundDeposit;      // initial token owner

    // crowdsale parameters
    bool public isFinalized;              // switched to true in operational state
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public crowdsaleSupply = 0;         // crowdsale supply
    uint256 public tokenExchangeRate = 20000;   // how many tokens per 1 ETH
    uint256 public constant tokenCreationCap =  10 * (10 ** 9) * 10 ** decimals;
    uint256 public tokenCrowdsaleCap =  4 * (10 ** 8) * 10 ** decimals;

    // events
    event CreateTestToken(address indexed _to, uint256 _value);

    // constructor
    constructor(
        address _ethFundDeposit,
        address _testFundDeposit,
        uint256 _tokenExchangeRate,
        uint256 _blockPeriod)
        public
    {
        isFinalized = false;                   //controls pre through crowdsale state
        ethFundDeposit = _ethFundDeposit;
        testFundDeposit = _testFundDeposit;
        tokenExchangeRate = _tokenExchangeRate;
        fundingStartBlock = block.number;
        fundingEndBlock = fundingStartBlock + _blockPeriod;
        totalSupply = tokenCreationCap;
        balances[testFundDeposit] = tokenCreationCap;    // deposit all TEST to the initial address.
        emit CreateTestToken(testFundDeposit, tokenCreationCap);
    }

    function () payable public {
        assert(!isFinalized);
        require(block.number >= fundingStartBlock);
        require(block.number < fundingEndBlock);
        require(msg.value > 0);

        uint256 tokens = safeMult(msg.value, tokenExchangeRate);    // check that we does not oversell
        crowdsaleSupply = safeAdd(crowdsaleSupply, tokens);

        // return money if something goes wrong
        require(tokenCrowdsaleCap >= crowdsaleSupply);

        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);     // add amount of TEST to sender
        balances[testFundDeposit] = safeSub(balances[testFundDeposit], tokens); // subtracts amount from initial balance
        emit CreateTestToken(msg.sender, tokens);
    }
    /// @dev Accepts ether and creates new XPA tokens.
    function createTokens() payable external {
        require(!isFinalized);
        require(block.number >= fundingStartBlock);
        require(block.number < fundingEndBlock);
        require(msg.value > 0);

        uint256 tokens = safeMult(msg.value, tokenExchangeRate);    // check that we does not oversell
        crowdsaleSupply = safeAdd(crowdsaleSupply, tokens);

        // return money if something goes wrong
        require(tokenCrowdsaleCap >= crowdsaleSupply);

        balances[msg.sender] = safeAdd(balances[msg.sender], tokens);     // add amount of TEST to sender
        balances[testFundDeposit] = safeSub(balances[testFundDeposit], tokens); // subtracts amount from initial balance
        emit CreateTestToken(msg.sender, tokens);      // logs token creation
    }

    /// @dev Update crowdsale parameter
    function updateParams(
        uint256 _tokenExchangeRate,
        uint256 _tokenCrowdsaleCap,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock) onlyOwner external 
    {
        assert(block.number < fundingStartBlock);
        assert(!isFinalized);
      
        // update system parameters
        tokenExchangeRate = _tokenExchangeRate;
        tokenCrowdsaleCap = _tokenCrowdsaleCap;
        fundingStartBlock = _fundingStartBlock;
        fundingEndBlock = _fundingEndBlock;
    }
    /// @dev Ends the funding period and sends the ETH home
    function finalize() onlyOwner external {
        assert(!isFinalized);
      
        // move to operational
        isFinalized = true;
        ethFundDeposit.transfer(address(this).balance);
    }
}
