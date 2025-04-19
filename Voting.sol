// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.24;

contract Voting {

    struct Candidate {
        bytes32 nameHash;
        uint128 votes;
        bool exists;
    }

    mapping(uint128 => Candidate) candidates;
    mapping(address => bool) userVoted;
    uint128 candidatesId;

    event CandidateAdded(uint128 candidateId);
    event VotedFor(uint128 indexed candidateId, uint128 count);

    modifier onlyKnownCandidates (uint128 candidateId) {
        require(candidates[candidateId].exists, "Only Known candidates");
        _;
    }

    function addCandidate(string calldata name) external returns (uint128 candidateId) {
        candidateId = candidatesId++;

        candidates[candidateId] = Candidate(
            keccak256(bytes(name)), 
            0, 
            true
        );

        emit CandidateAdded(candidateId);
    }

    function vote(uint128 candidateId) external onlyKnownCandidates(candidateId) returns (uint128 count) {
        require(userVoted[msg.sender] == false, "User already Voted");
        userVoted[msg.sender] = true;
        
        Candidate storage candidate = candidates[candidateId];
        
        unchecked {
            count = ++candidate.votes;
        }

        emit VotedFor(candidateId, count);
    }

    function getWinner() external view returns (uint128 winner) {
        winner = 0;

        unchecked {
            for (uint128 i = 0; i < candidatesId; ++i) {
                uint128 candidatesVotes = candidates[i].votes;
                uint128 lastCandidateVotes = candidates[winner].votes;
                
                if (candidatesVotes > lastCandidateVotes) {
                    winner = i;
                }
            }
        }        
    }
}