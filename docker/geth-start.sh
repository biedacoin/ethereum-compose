#!/usr/bin/env sh

: ${VERBOSITY:=3}
: ${NETWORKID:=696969}

set -euo pipefail

which cat paste geth

[ -n "${VERBOSITY}" ]
[ -n "${NETWORKID}" ]

readonly BOOTNODES="`cat /shared/*.enode | paste -sd,`"

[ -n "${BOOTNODES}" ]

geth \
    --verbosity="${VERBOSITY}" \
    --datadir='/root/.ethereum' \
    init /genesis.json

exec geth \
    --verbosity="${VERBOSITY}" \
    --datadir='/root/.ethereum' \
    --networkid="${NETWORKID}" \
    --ws \
    --wsapi='db,personal,eth,net,web3' \
    --wsaddr='0.0.0.0' \
    --wsorigins='*' \
    --ipcpath="/root/.ethereum/geth.ipc" \
    --bootnodes="${BOOTNODES}"

# vim:ts=4:sw=4:et:syn=sh:
