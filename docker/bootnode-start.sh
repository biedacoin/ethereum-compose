#!/usr/bin/env sh

: ${VERBOSITY:=1}

set -euo pipefail

which getent awk bootnode pwd xargs printf

[ -n "${VERBOSITY}" ]

readonly IPV4="`getent ahostsv4 "${HOSTNAME}" | awk 'NR==1{print$1}'`"

[ -n "${IPV4}" ]

cd /root/.ethereum/

bootnode --verbosity="${VERBOSITY}" --genkey="`pwd`/${IPV4}.key"

bootnode --verbosity="${VERBOSITY}" --nodekey="`pwd`/${IPV4}.key" --writeaddress \
| xargs -r -n1 printf "enode://%s@${IPV4}:30301\n" >"/shared/${IPV4}.enode"

exec bootnode --verbosity="${VERBOSITY}" --nodekey="`pwd`/${IPV4}.key" --addr="0.0.0.0:30301"

# vim:ts=4:sw=4:et:syn=sh:
