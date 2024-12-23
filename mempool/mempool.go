package mempool

import (
	"paperexperiment/config"
	"paperexperiment/message"
)

type MemPool struct {
	*Backend
}

// NewTransactions creates a new memory pool for transactions.
func NewMemPool() *MemPool {
	mp := &MemPool{
		Backend: NewBackend(config.GetConfig().MemSize),
	}

	return mp
}

func (mp *MemPool) addNew(tx *message.Transaction) {
	mp.Backend.insertBack(tx)
	mp.Backend.addToBloom(tx.Hash)
}

func (mp *MemPool) addOld(tx *message.Transaction) {
	mp.Backend.insertFront(tx)
}
