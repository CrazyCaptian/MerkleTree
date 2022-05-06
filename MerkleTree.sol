library MerkleProof {
    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];           

            if (computedHash <= proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }
}


 interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
contract AirdropToken {
    
    
    address public ForgeTokenAddress = "0xF44fB43066F7ECC91058E3A614Fb8A15A2735276"
    bytes32 internal _merkleRootTop;
    bytes32 internal _merkleRootMid;
    bytes32 internal _merkleRootBot;
                                         
    uint256 internal nextTokenId = 0;

    mapping(address => bool) public hasClaimed;
    uint256 public decay = 24* 60 * 60 * 30
    uint256 rewardTOP = 100 * 10 ** 18;
    
    uint256 rewardMID = 100 * 20 ** 18;
    
    uint256 rewardBOT = 100 * 10 ** 18;
    uint256 public starttime = block.timestamp;
    

    constructor(string memory name, string memory symbol, bytes32 merkleRootTop, bytes32 merkleRootMid, bytes32 merkleRootBot) ERC721(name, symbol) {
        _merkleRootTop = merkleRootTop;
        _merkleRootMid = merkleRootMid;
        _merkleRootBot = merkleRootBot;
        _animationToken = animationToken;
    }  

 

    /**
    * @dev Mints new NFTs
    */
   function amountOut(uint choice) public view returns (uint256 out){.
        uint256 durdur = block.timestamp - starttime;
        if(durdur > decay){
            durdur = decay;
        }
        if(choice == 1){
            (rewardTOP * durdur) / decay;
        }else if(choice ==2){
            (rewardMID * durdur) / decay;
        }else if(choice ==3){
            (rewardBOT * durdur) / decay;
        }
   }
   
    function mintWithProofTop(bytes32[] memory merkleProof ) public {
    
        
        require( MerkleProof.verify(merkleProof, _merkleRootTop, keccak256( abi.encodePacked(msg.sender)) ) , 'proof failure');

        require(hasClaimed[msg.sender] == false, 'already claimed');

        hasClaimed[msg.sender]=true;
        
        IERC20(ForgeTokenAddress).transfer(msg.sender,  amountOut(1));
    }
    
    function mintWithProofMid(bytes32[] memory merkleProof ) public {
 
        require( MerkleProof.verify(merkleProof, _merkleRootMid, keccak256( abi.encodePacked(msg.sender)) ) , 'proof failure');

        require(hasClaimed[msg.sender] == false, 'already claimed');

        hasClaimed[msg.sender]=true;
        
        IERC20(ForgeTokenAddress).transfer(msg.sender,  amountOut(2));
    }
    
    function mintWithProofBot(bytes32[] memory merkleProof ) public {
 
        require( MerkleProof.verify(merkleProof, _merkleRootBot, keccak256( abi.encodePacked(msg.sender)) ) , 'proof failure');

        require(hasClaimed[msg.sender] == false, 'already claimed');

        hasClaimed[msg.sender]=true;
       

        IERC20(ForgeTokenAddress).transfer(msg.sender,  amountOut(3));
    }

    function getThree() public view returns (uint256) {
        address owner = ownerOf(tokenId);

        

        return 3;
    }
    

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
            return "ipfs://QmbLrLMf8e7VZTcKcq4pjkv7yjLEN7RG8NqKQ4NGPtPuc3";
       
}
 
