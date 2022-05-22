// Forge Airdrop Contract
// https://airdrop.forgetoken.org
// Claim up to 100, 30 or 10 Forge in this new twist on airdrops! 
// The longer you wait the more your claim unlocks, but dont let the contract run dry without claiming!
// Allows contract to be recharged by anyone to restart the Airdrop!

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



contract ForgeGuess{
    function balanceOf(address account) public view returns (uint256) {}
    uint256 public unreleased;
    uint256 public totalSupply;
    function stakeFor(address forWhom, uint256 amount) public virtual {}
    function withdraw(uint256 amount, uint256 maxLoss) public virtual {}
    
    function withEstimator(uint256 amountOut) public view returns (uint256) {}
    }



contract AirdropToken {
    
    
    address public ForgeTokenAddressREAL = address(0xF44fB43066F7ECC91058E3A614Fb8A15A2735276);
    address public ForgeTokenAddress = address(0xbF4493415fD1E79DcDa8cD0cAd7E5Ed65DCe7074);
    address public ForgeGuessContractAddress = address(0xDe256EC57E864eC847c030e14c5b97AB233A521E);
    bytes32 [] public _merkleRootAll;
    bytes32 internal _merkleRootTop = 0xdd82af2bc4b721bfd5be08111d4f422fd07d1578a0072d6701f26ea4fff33845;
    bytes32 internal _merkleRootMid = 0x15893a9b8d3638149dd9461fde79f589e565a2fc76a861ec1aebb83736151566;
    bytes32 internal _merkleRootBot = 0x316b4323ca91ba63304a4e0ada24b09f8689ac1f80aca8e9d5c4213fc9ba7848;
                                         
    uint256 [] public amtClaim;
    uint256 internal nextTokenId = 0;
    mapping(address => bool) public hasClaimed;
    uint256 public decay = 24* 60 * 60 * 30;

    uint256 public starttime = block.timestamp;
    

    constructor()  {
        _merkleRootAll.push(_merkleRootTop);
        _merkleRootAll.push(_merkleRootMid);
        _merkleRootAll.push(_merkleRootBot);
        amtClaim.push(1000000000000);
        amtClaim.push(100000000);
        amtClaim.push(100000);
    }  

 

    function deposit(uint amt) public returns (bool success){


        require(amt > ForgeGuess(ForgeGuessContractAddress).withEstimator(ForgeGuess(ForgeGuessContractAddress).balanceOf(address(this))), "must be greater than previous total to reset");
        require(IERC20(ForgeTokenAddress).transferFrom(msg.sender, address(this), amt), "transfer fail");
        starttime = block.timestamp;
        IERC20(ForgeTokenAddress).approve(ForgeGuessContractAddress, 999999999999999999999999999999999999999999999999999);
        ForgeGuess(ForgeGuessContractAddress).stakeFor(address(this), amt);
        uint x = perfect();
        amtClaim[0] = x * 10;
        amtClaim[1] = x * 3;
        amtClaim[2] = x * 1;

        return true;
    }


    function Donation(uint amt) public returns (bool success){ 

        if(amt > ForgeGuess(ForgeGuessContractAddress).withEstimator(ForgeGuess(ForgeGuessContractAddress).balanceOf(address(this)))){

            deposit(amt);

        }else{

            require(IERC20(ForgeTokenAddress).transferFrom(msg.sender, address(this), amt), "transfer fail");
            IERC20(ForgeTokenAddress).approve(ForgeGuessContractAddress, 999999999999999999999999999999999999999999999999999);
            ForgeGuess(ForgeGuessContractAddress).stakeFor(address(this), amt);

        }

        return true;
    }


    function perfect() public view returns (uint256 amtz){
        
        uint256 test = (10 * 10 ** 18 * 1000) / ((975 * (IERC20(address(ForgeTokenAddress)).balanceOf(ForgeGuessContractAddress) - ForgeGuess(ForgeGuessContractAddress).unreleased() ) / ForgeGuess(ForgeGuessContractAddress).totalSupply()));


        return test;
    }

    function amtOutForChoiceInForge(uint choice) public view returns (uint256 out){

        return ForgeGuess(ForgeGuessContractAddress).withEstimator(amountOut(choice));
    }


   function amountOut(uint choice) public view returns (uint256 out){
        uint256 durdur = block.timestamp - starttime;
        if(durdur > decay){
            durdur = decay;
        }
        if(choice == 0){
           return (amtClaim[0] * durdur) / decay;
        }else if(choice ==1){
           return (amtClaim[1] * durdur) / decay;
        }else if(choice ==2){
           return (amtClaim[2] * durdur) / decay;
        }
        return 0;
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
    //0= 0%-10%, 1= 10%-40%, 2= 50%-90%
    function mintWithProofALL(bytes32[] memory merkleProof, uint claim, uint maxLoss ) public {
 
        require( verify(merkleProof, msg.sender, claim)  , 'proof failure');

        require(hasClaimed[msg.sender] == false, 'already claimed');

        hasClaimed[msg.sender]=true;
        
        ForgeGuess(ForgeGuessContractAddress).withdraw(amountOut(claim), maxLoss);
        require(IERC20(ForgeTokenAddress).transfer(msg.sender, IERC20(ForgeTokenAddress).balanceOf(address(this))), "contract may be out of funds");
    }

    //verify claim
    function verify(bytes32[] memory merkleProof, address claimer, uint claim)public view returns (bool ver){
    if(claim == 0){
    
        return MerkleProof.verify(merkleProof, _merkleRootAll[0], keccak256( abi.encodePacked(claimer)));
    }else if(claim ==1 ){

        return MerkleProof.verify(merkleProof, _merkleRootAll[1], keccak256( abi.encodePacked(claimer)));
    }else if(claim == 2){
    
        return MerkleProof.verify(merkleProof, _merkleRootAll[2], keccak256( abi.encodePacked(claimer)));
    }
    return false;
    }
    
    
    function getThree() public view returns (uint256) {

        return 3;
    }
    

}


/*
*
* MIT License
* ===========
*
* Copyright (c) 2022 Forge
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.   
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/
