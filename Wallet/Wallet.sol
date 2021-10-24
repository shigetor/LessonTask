
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Wallet {
   
    constructor() public {
        // check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }


    
    modifier checkOwnerAndAccept {
       
        require(msg.pubkey() == tvm.pubkey(), 100);

		tvm.accept();
		_;
	}


    //во всех методах идет проверка на то, что кошелек существует 
    //в противном случаем транзакция отменяется
    function sendAllMoneyAndDelete(address dest, uint128 value) public pure checkOwnerAndAccept {
        // Перечисляем все средства на другой кошелек
        dest.transfer(value, true, 160);
    }
    function sendTransactionWithComissions(address dest,uint128 value) public pure  checkOwnerAndAccept{
        //перевод средств с комиссией
        dest.transfer(value,true,0);
    }
    function sendTransactionWithoutComissions(address dest,uint128 value) public pure  checkOwnerAndAccept{
        //перевод средств без комисии
        dest.transfer(value,true,1);

    }

}