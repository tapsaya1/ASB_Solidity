// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "hardhat/console.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract Carscount is ERC20{

    constructor() ERC20("carToken","CTK"){
        _mint(msg.sender,1000);
    }
    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }

    struct userinfo{
        uint256[] userIndex;
        address userAdd;
        uint256[] amountPaid;
    }
    mapping(address=>userinfo) public map;
    userinfo user;
    uint256 public cars;
    uint256[] public emptyIndex;

    function AddCars(uint256 amount) public {
    
     require(balanceOf(msg.sender) > 1 ,"INVALID AMOUNT");
        burn(msg.sender, amount);
        if(emptyIndex.length!=0)
        {
            uint256 carIndex;
            carIndex=emptyIndex[emptyIndex.length-1];
            user.userAdd=msg.sender;
            user.userIndex.push(carIndex);
            emptyIndex.pop();
        }
        else
        {
            cars++;
            user.userAdd=msg.sender;
            user.userIndex.push(cars);
        }
        
        uint256 a = (amount * 1/ 100);
        mint(amount * 1/100);
        user.amountPaid.push(amount-a);
        map[msg.sender]=user;
    }
    function LessCar() public{
        user=map[msg.sender];
        require(user.userAdd !=address(0),"INVALID USER");
            emptyIndex.push(user.userIndex[user.userIndex.length-1]);
            user.userIndex.pop();
            if(user.userIndex.length==0)
            {
                user.userAdd=address(0);
            }
            mint(user.amountPaid[user.amountPaid.length-1]);
            user.amountPaid.pop();
            if(user.userAdd==address(0))
            {
                delete map[msg.sender];
            }
            
        // cars--;
        
    }
    function getCounter() public view returns (uint256) {
        return cars;
    }
}