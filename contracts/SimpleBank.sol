/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    /* State variables
     */
    mapping (address => uint) internal balances;
    mapping (address => bool) public enrolled;
    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */
    event LogEnrolled(address accountAddress);
    event LogDepositMade(address accountAddress, uint amount);
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /* Functions
     */
    function () external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public returns (uint) {
      return address(this).balance;
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    function enroll() public returns (bool){
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);
      return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      require(enrolled[msg.sender] == true, "Please enroll first");
      emit LogDepositMade(msg.sender, msg.value);
      return balances[msg.sender] += msg.value;
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      require(balances[msg.sender] >= withdrawAmount);
      balances[msg.sender] -= withdrawAmount;
      msg.sender.transfer(withdrawAmount);
      emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
      return balances[msg.sender];
    }
}
