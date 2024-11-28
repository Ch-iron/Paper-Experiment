package quorum

import (
	"fmt"
	"sync"

	"paperexperiment/crypto"
	"paperexperiment/identity"
	"paperexperiment/log"
	"paperexperiment/types"

	"github.com/ethereum/go-ethereum/common"
)

type CommitTransactionCommitQuorum struct {
	total   int
	commits map[common.Hash]map[int]map[identity.NodeID]*CommitTransactionCommit

	mu sync.Mutex
}

func NewCommitTransactionCommitQuorum(n int) *CommitTransactionCommitQuorum {
	return &CommitTransactionCommitQuorum{
		total:   n,
		commits: make(map[common.Hash]map[int]map[identity.NodeID]*CommitTransactionCommit),
	}
}

type CommitTransactionCommit struct {
	types.Epoch
	types.View
	Voter           identity.NodeID
	TransactionHash common.Hash
	crypto.Signature
	IsCommit   bool
	Nonce      int
	OrderCount int
}

func MakeCommitTransactionCommit(epoch types.Epoch, view types.View, voter identity.NodeID, hash common.Hash, iscommit bool, nonce int, ordercount int) *CommitTransactionCommit {
	sig, err := crypto.PrivSign(crypto.IDToByte(hash), nil)
	if err != nil {
		log.Fatalf("[%v] 커밋을 위한 사인에 에러가 있음", voter)
		return nil
	}
	return &CommitTransactionCommit{
		Epoch:           epoch,
		View:            view,
		Voter:           voter,
		TransactionHash: hash,
		Signature:       sig,
		IsCommit:        iscommit,
		Nonce:           nonce,
		OrderCount:      ordercount,
	}
}

func (q *CommitTransactionCommitQuorum) Add(message interface{}) (bool, *CommitTransactionQC) {
	q.mu.Lock()
	defer q.mu.Unlock()
	commit, ok := message.(*CommitTransactionCommit)
	if !ok {
		return false, nil
	}
	if q.superMajority(commit.TransactionHash, commit.Nonce) {
		// delete(q.commits, commit.TransactionHash)
		return false, nil
	}
	if _, exist := q.commits[commit.TransactionHash]; !exist {
		q.commits[commit.TransactionHash] = make(map[int]map[identity.NodeID]*CommitTransactionCommit)
	}
	if _, exist := q.commits[commit.TransactionHash][commit.Nonce]; !exist {
		q.commits[commit.TransactionHash][commit.Nonce] = make(map[identity.NodeID]*CommitTransactionCommit)
	}
	q.commits[commit.TransactionHash][commit.Nonce][commit.Voter] = commit

	if q.superMajority(commit.TransactionHash, commit.Nonce) {
		aggSig, signers, err := q.getSigs(commit.TransactionHash, commit.Nonce)
		if err != nil {
			log.Warningf("(Commit-Add) cannot generate a valid qc view %v epoch %v block id %x: %v", commit.View, commit.Epoch, commit.TransactionHash, err)
		}
		qc := &CommitTransactionQC{
			Epoch:           commit.Epoch,
			View:            commit.View,
			TransactionHash: commit.TransactionHash,
			AggSig:          aggSig,
			Signers:         signers,
			IsCommit:        commit.IsCommit,
			Nonce:           commit.Nonce,
			OrderCount:      commit.OrderCount,
		}
		return true, qc
	}
	return false, nil
}

func (q *CommitTransactionCommitQuorum) superMajority(blockID common.Hash, nonce int) bool {
	return q.size(blockID, nonce) > q.total*2/3
}

func (q *CommitTransactionCommitQuorum) AddMajority(message interface{}) (bool, *CommitTransactionQC) {
	q.mu.Lock()
	defer q.mu.Unlock()
	commit, ok := message.(*CommitTransactionCommit)
	if !ok {
		return false, nil
	}
	if q.Majority(commit.TransactionHash, commit.Nonce) {
		return false, nil
	}
	if _, exist := q.commits[commit.TransactionHash]; !exist {
		//	first time of receiving the vote for this block
		if _, exist := q.commits[commit.TransactionHash][commit.Nonce]; !exist {
			q.commits[commit.TransactionHash][commit.Nonce] = make(map[identity.NodeID]*CommitTransactionCommit)
		}
	}
	q.commits[commit.TransactionHash][commit.Nonce][commit.Voter] = commit

	if q.Majority(commit.TransactionHash, commit.Nonce) {
		aggSig, signers, err := q.getSigs(commit.TransactionHash, commit.Nonce)
		if err != nil {
			log.Warningf("(Commit-Add) cannot generate a valid qc view %v epoch %v block id %x: %v", commit.View, commit.Epoch, commit.TransactionHash, err)
		}
		qc := &CommitTransactionQC{
			Epoch:           commit.Epoch,
			View:            commit.View,
			TransactionHash: commit.TransactionHash,
			AggSig:          aggSig,
			Signers:         signers,
		}
		return true, qc
	}
	return false, nil
}

func (q *CommitTransactionCommitQuorum) Majority(transactionhash common.Hash, nonce int) bool {
	return q.size(transactionhash, nonce) > q.total*1/2
}

func (q *CommitTransactionCommitQuorum) size(transactionhash common.Hash, nonce int) int {
	return len(q.commits[transactionhash][nonce])
}

func (q *CommitTransactionCommitQuorum) getSigs(transactionhash common.Hash, nonce int) (crypto.AggSig, []identity.NodeID, error) {
	var sigs crypto.AggSig
	var signers []identity.NodeID
	_, exists := q.commits[transactionhash]
	if !exists {
		return nil, nil, fmt.Errorf("sigs does not exist, id: %x", transactionhash)
	}
	for _, commit := range q.commits[transactionhash][nonce] {
		sigs = append(sigs, commit.Signature)
		signers = append(signers, commit.Voter)
	}

	return sigs, signers, nil
}

func (q *CommitTransactionCommitQuorum) Delete(transactionhash common.Hash) {
	q.mu.Lock()
	defer q.mu.Unlock()
	_, ok := q.commits[transactionhash]
	if ok {
		delete(q.commits, transactionhash)
	}
}
