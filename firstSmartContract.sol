//Construción de un contrato inteligente que gestione el desbloqueo desbloqueo
//de una cierta cantidad de ethereum cuando un niño alcanze la mayoría de edad
contract Trust{
    
    struct Kid{
        uint amount;
        uint maturity;
        bool paid;
    }
   
    mapping(address => Kid) public kids;
    //Definimos la dirección del administrador
    address public admin;
    
    constructor(){
        
        admin = msg.sender;
    }
    
    
    function addKid(address kid, uint timeToMaturity) external payable{
        
        //Requerimos que sólo pueda ejecutar esta transacción el administrador
        require(msg.sender == admin, 'only admin');
        require(kids[msg.sender].amount == 0, 'kid already exists');
        kids[kid] = Kid(msg.value, block.timestamp + timeToMaturity, false);
        
    }
    
    
    function withdraw() external{
        Kid storage kid = kids[msg.sender];
        require(kid.maturity <= block.timestamp, 'The money cant be withdrawed yet');
        require(kid.amount > 0, 'only kid can withdraw');
        //Evitamos con un niño sea pagado varias veces
        require(kid.paid == false, 'paid already');
        kid.paid = true;
        payable(msg.sender).transfer(kid.amount);
    }
}

