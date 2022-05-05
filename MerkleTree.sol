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


contract AirdropToken {
    
    
   
    bytes32 internal _merkleRoot;
                                         
    uint256 internal nextTokenId = 0;

    mapping(address => bool) public hasClaimed;


    constructor(string memory name, string memory symbol, bytes32 merkleRoot) ERC721(name, symbol) {
        _merkleRoot = merkleRoot;
        _animationToken = animationToken;
    }  

 

    /**
    * @dev Mints new NFTs
    */
    function mintWithProof(bytes32[] memory merkleProof ) public {
 
        require( MerkleProof.verify(merkleProof, _merkleRoot, keccak256( abi.encodePacked(msg.sender)) ) , 'proof failure');

        require(hasClaimed[msg.sender] == false, 'already claimed');

        hasClaimed[msg.sender]=true;
        
        _mint(msg.sender, nextTokenId++); 
    }

    function getThree() public view returns (uint256) {
        address owner = ownerOf(tokenId);

        

        return 3;
    }
    

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
            return "ipfs://QmbLrLMf8e7VZTcKcq4pjkv7yjLEN7RG8NqKQ4NGPtPuc3";
       
}
 
