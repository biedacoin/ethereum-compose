#!/usr/bin/env sh

: ${N_ACCOUNTS:=8}

set -euo pipefail

which seq xargs geth /bin/rm jq cut tr tee

[ -n "${N_ACCOUNTS}" ]

readonly TEMPLATE="
{
  \"config\": {
    \"chainId\": 696969,
    \"homesteadBlock\": 0,
    \"eip155Block\": 0,
    \"eip158Block\": 0
  },
  \"nonce\": \"0x0000000000000069\",
  \"mixhash\": \"0x0000000000000000000000000000000000000000000000000000000000000000\",
  \"difficulty\": \"0x369\",
  \"coinbase\": \"0x3333333333333333333333333333333333333333\",
  \"timestamp\": \"0x0\",
  \"parentHash\": \"0x0000000000000000000000000000000000000000000000000000000000000000\",
  \"extraData\": \"0x\",
  \"gasLimit\": \"0x6900000\",
  \"alloc\": {}
}
"

create_accounts() {
    echo -n 'pass' >/tmp/pass \
    && seq "${N_ACCOUNTS}" \
    | xargs -n1 geth --password=/tmp/pass account new \
    && /bin/rm -f /tmp/pass
}

render_genesis_json() {
    echo "${TEMPLATE}" \
    | jq --argjson alloc \
    "`geth account list \
    | cut -d ' ' -f3 \
    | tr -d '{}' \
    | jq --raw-input . \
    | jq --slurp '[. | to_entries[] | {"key":("0x" + .value), "value":{"balance": "69000000000000000000"}}] | from_entries'`" \
    '.alloc = $alloc' \
    | tee /genesis.json
}

create_accounts && render_genesis_json

# vim:ts=4:sw=4:et:syn=sh:
