pragma solidity ^0.5.0;

// ----------------------------------------------------------------------------
// 'FIXED' 'Example Fixed Supply Token' token contract
//
// Symbol      : FIXED
// Name        : Example Fixed Supply Token
// Total supply: 1,000,000.000000000000000000
// Decimals    : 18
//
// Enjoy.
//
// (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}


// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// ----------------------------------------------------------------------------
contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


// ----------------------------------------------------------------------------
// Contract function to receive approval and execute function in one call
//
// Borrowed from MiniMeToken
// ----------------------------------------------------------------------------
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
}


// ----------------------------------------------------------------------------
// Owned contract
// ----------------------------------------------------------------------------
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}


// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and a
// fixed supply
// ----------------------------------------------------------------------------
contract FixedSupplyToken is ERC20Interface, Owned {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------
    constructor() public {
        symbol = "FIXED";
        name = "Example Fixed Supply Token";
        decimals = 18;
        _totalSupply = 1000000 * 10**uint(decimals);
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }


    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------
    function totalSupply() public view returns (uint) {
        return _totalSupply.sub(balances[address(0)]);
    }


    // ------------------------------------------------------------------------
    // Get the token balance for account `tokenOwner`
    // ------------------------------------------------------------------------
    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }


    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces
    // ------------------------------------------------------------------------
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    //
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }


    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------
    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account. The `spender` contract function
    // `receiveApproval(...)` is then executed
    // ------------------------------------------------------------------------
    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }


    // ------------------------------------------------------------------------
    // Don't accept ETH
    // ------------------------------------------------------------------------
    function () external payable {
        revert();
    }


    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------
    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
        return ERC20Interface(tokenAddress).transfer(owner, tokens);
    }
    
    function getOwner() public view returns (address){
        return owner;
    }
}

contract Apmt is Owned{
    using SafeMath for uint;
    
    struct apmtStruct{
        address apmtOwner;
        string apmtName;
        uint apmtId;
        uint timestamp;
        bool isValid;
    }
    
    FixedSupplyToken tokenContract = new FixedSupplyToken();
    
    uint numberOfApmts;
    uint initTokenValue = 100;
    
    mapping(address=>bool) initToken;
    
    mapping(uint=>uint) requiredDeposit;
    mapping(uint=>uint) allDeposit;
    
    mapping(uint=>uint) numberOfMember;
    mapping(uint=>address[]) addressOfMember;
    mapping(uint=>uint) numberOfAttend;
    mapping(uint=>mapping(address=>bool)) stateOfAttend;
    
    event apmtAdded();
    
    constructor() public{
        
    }
    
    apmtStruct[] apmts;
    
    function addApmt(string memory _name, uint _id, uint _deposit) public {
        require(tokenContract.balanceOf(msg.sender) >= _deposit);
        tokenContract.transfer(tokenContract.getOwner(), _deposit);
        
        apmts.push(apmtStruct(msg.sender, _name, _id, now, true));
        requiredDeposit[_id] = _deposit;
        
        allDeposit[_id] = allDeposit[_id].add(_deposit);
        numberOfMember[_id] = numberOfMember[_id].add(1);
        addressOfMember[_id].push(msg.sender);
        
        numberOfApmts = numberOfApmts.add(1);
        emit apmtAdded();
    }
    
    function joinApmt(uint _id) public {
        require(apmts[_id].isValid);
        require(tokenContract.balanceOf(msg.sender) >= requiredDeposit[_id]);
        tokenContract.transfer(tokenContract.getOwner(), requiredDeposit[_id]);
        allDeposit[_id] = allDeposit[_id].add(requiredDeposit[_id]);
        addressOfMember[_id].push(msg.sender);
        numberOfMember[_id] = numberOfMember[_id].add(1);
    }
    
    function attendApmt(uint _id) public {
        require(!stateOfAttend[_id][msg.sender]);
        stateOfAttend[_id][msg.sender] = true;
        numberOfAttend[_id] = numberOfAttend[_id].add(1);
    }
    
    function endApmt(uint _id) public {
        uint depositForAttend = allDeposit[_id] / numberOfAttend[_id];
        for(uint i=0; i<numberOfMember[_id]; i++){
            if(stateOfAttend[_id][addressOfMember[_id][i]]){
                require(tokenContract.balanceOf(tokenContract.getOwner()) >= requiredDeposit[_id]);
                tokenContract.transfer(addressOfMember[_id][i], requiredDeposit[_id] + depositForAttend);
            }
        }
        allDeposit[_id] = 0;
        requiredDeposit[_id] = 0;
    }
    
    function getInitToken() public {
        bool initTokenValid = initToken[msg.sender];
        require(!initTokenValid);
        require(tokenContract.balanceOf(tokenContract.getOwner()) >= initTokenValue);
        tokenContract.transfer(msg.sender, initTokenValue);
        initToken[msg.sender] = false;
    }
    
    function getTokenOwner() public view returns (address){
        return tokenContract.getOwner();
    }
    
    function getBalance(address _address) public view returns (uint){
        return tokenContract.balanceOf(_address);
    }
    
    function getNumberOfApmts() public view returns (uint){
        return numberOfApmts;
    }
    
    function getNumberOfMember(uint _id) public view returns (uint){
        return numberOfMember[_id];
    }
    
    function getNumberOfAttend(uint _id) public view returns (uint){
        return numberOfAttend[_id];
    }
}