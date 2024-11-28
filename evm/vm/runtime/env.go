// Copyright 2015 The go-ethereum Authors
// This file is part of the go-ethereum library.
//
// The go-ethereum library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// The go-ethereum library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the go-ethereum library. If not, see <http://www.gnu.org/licenses/>.

package runtime

import (
	"paperexperiment/evm/core"
	"paperexperiment/evm/state"
	"paperexperiment/evm/vm"
)

// Change Point
// NewEnv(cfg *Config) -> NewEnv(cfg *Config, statedb *state.StateDB)
func NewEnv(cfg *Config, statedb *state.StateDB) *vm.EVM {
	txContext := vm.TxContext{
		Origin:     cfg.Origin,
		GasPrice:   cfg.GasPrice,
		BlobHashes: cfg.BlobHashes,
		BlobFeeCap: cfg.BlobFeeCap,
	}
	blockContext := vm.BlockContext{
		CanTransfer: core.CanTransfer,
		Transfer:    core.Transfer,
		GetHash:     cfg.GetHashFn,
		Coinbase:    cfg.Coinbase,
		BlockNumber: cfg.BlockNumber,
		Time:        cfg.Time,
		Difficulty:  cfg.Difficulty,
		GasLimit:    cfg.GasLimit,
		BaseFee:     cfg.BaseFee,
		BlobBaseFee: cfg.BlobBaseFee,
		Random:      cfg.Random,
	}

	evm := vm.NewEVM(blockContext, statedb, cfg.ChainConfig, cfg.EVMConfig)
	evm.SetTxContext(txContext)
	return evm
}
