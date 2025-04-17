// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Voting {

    struct Candidate {
        string name; // 1 slot
        uint256 votes; // 1 slot
        bool exists; // 1 slot
    }

    mapping(uint256 => Candidate) candidates;
    mapping(address => bool) userVoted;
    uint256 candidatesId;
    
    uint256 nonce;

    modifier onlyKnownCandidates (uint256 candidateId) {
        require(candidates[candidateId].exists, "Only Knonw candidates");
        _;
    }

    function addCandidate(string calldata name) external {
        candidates[candidatesId] = Candidate(name, 0, true);
        ++nonce;
        ++candidatesId;
    }

    function vote(uint256 candidateId) external onlyKnownCandidates(candidateId) {
        require(userVoted[msg.sender] == false, "User already Voted");
        Candidate storage candidate = candidates[candidateId];
        ++candidate.votes;
        userVoted[msg.sender] = true;
    }

    function getWinner() external view returns (uint256 winner) {
        winner = 0;

        for (uint256 i = 0; i < candidatesId; ++i) {
            uint256 candidatesVotes = candidates[i].votes;
            uint256 lastCandidateVotes = candidates[winner].votes;
            
            if (candidatesVotes > lastCandidateVotes) {
                winner = i;
            }
        }
    }
}