//SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
 interface IERC20{
     function totalSupply() external view returns (uint256);
     function transfer(address _to, uint256 _value) external returns (bool success);
     function balanceOf(address _owner) external view returns (uint256 balance);
    
 }
 contract KToken is IERC20{
     string public name;
     string public symbol;
     uint   decimals=18;
     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
     event Transfer(address indexed _from, address indexed _to, uint256 _value);
 mapping(address => uint) balances;
 mapping(address => mapping(address=>uint)) allowed;
 uint256 totalSupply_;
 address admin;
 constructor(string memory name_,string memory symbol_,uint decimal,uint256 Tsupply_){
     admin=msg.sender;
     balances[msg.sender]=totalSupply_;
     name=name_;
     symbol=symbol_;
     decimal=decimal;
     totalSupply_=Tsupply_;
 }
 modifier OnlyAdmin{
     
        require(msg.sender == admin,"Only Admin are alloweed to change tokens");
      _;  
 }
 function totalSupply() public override view returns (uint256){
     return totalSupply_;
 }
   function balanceOf(address tokenowner) public override view returns (uint256 balance){
     return balances[tokenowner];
 }
  function transfer(address reciever, uint256 numTokens) public override returns (bool){
      require(numTokens<=balances[msg.sender]);
      balances[msg.sender]-=numTokens;
      balances[reciever]+=numTokens;
     emit Transfer(msg.sender,reciever,numTokens);
     return true;
  }
  function mint(uint256 tokens_add)public OnlyAdmin view returns(uint256){
      require(tokens_add<=500);
         tokens_add+=totalSupply_;
         return totalSupply_;
  }
  function burn(uint256 tokens_sub)public OnlyAdmin view returns(uint256){
      require(tokens_sub<=balances[msg.sender]);
         tokens_sub-=totalSupply_;
         return totalSupply_;
  }
  function allowance(address _owner, address _spender) public view returns (uint256 remaining){
      return allowed[_owner][_spender];
  }
  function approve(address _spender, uint256 _value) public returns (bool success){
      allowed[msg.sender][_spender]=_value;
      emit Approval(msg.sender,_spender,_value);
      return true;
  }
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
      uint allowanced=allowed[_from][msg.sender];
      require(balances[_from]>=_value && allowanced>=_value);
      balances[_to]+=_value;
      balances[_from]-=_value;
      allowed[_from][msg.sender]-=_value;
       emit Transfer(_from,_to, _value);
      return true;
  }
 }