
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;



// This is class that describes you smart contract.
contract NFT_Tokkens {
    struct Token_Book {
        string name;
        string author;
        string edition;
        uint year_publikation;
        uint price;   
    }
    modifier greater_than_zero(uint value) {
        require(value <= 0,101,"Число должно быть больше нуля");
        _;
    }

    Token_Book[] tokensArr;
    mapping (uint=>uint) tokenToOwner;

    function createToken(string name,string author,string edition,uint year_publikation,uint price) public returns(string)  {
        tvm.accept();
        uint count=0;
        for (uint i = 0;i < tokensArr.length;i++){
            if (tokensArr[i].name != name){
                count+=1;
            }
            else{
                count=0;
                return "Такой токен уже есть";
            }  
        }
        if (count==0){
            tokensArr.push(Token_Book(name,author,edition,year_publikation,price));
            return "Токен создан";
            }
        uint keyAsLastNum = tokensArr.length-1;
        tokenToOwner[keyAsLastNum] = msg.pubkey();

    }
    function getTokenOwner(uint tokenId) public view returns (uint) {
        return tokenToOwner[tokenId];

    }
    function getTokenInfo(uint tokenId) public view returns(string tokenName,string tokenAuthor,string tokenEdition,uint tokenYearPublication,uint tokenPrice){
        tokenName = tokensArr[tokenId].name;
        tokenAuthor = tokensArr[tokenId].author;
        tokenEdition = tokensArr[tokenId].edition;
        tokenYearPublication = tokensArr[tokenId].year_publikation;
        tokenPrice = tokensArr[tokenId].price;
        
    }
    function changeOwner(uint tokenId,uint pubkeyOfNewOwner) public {
        require(msg.pubkey()==tokenToOwner[tokenId],101);
        tvm.accept();
        tokenToOwner[tokenId]=pubkeyOfNewOwner;
    }
    function doubleToken(uint tokenId,uint value) public view greater_than_zero(value){
        //увеличиваем стоимость токена в value раз
        require(msg.pubkey()==tokenToOwner[tokenId],101);
        tvm.accept();
        uint numPrice=tokensArr[tokenId].price;
        numPrice = value*tokensArr[tokenId].price;
        
    }
    function priceOfToken(uint tokenId,uint priceToken) public{
        require(msg.pubkey()==tokenToOwner[tokenId],101);
        tvm.accept();
        tokensArr[tokenId].price = priceToken;
    }
    
}