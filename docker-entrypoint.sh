#!/bin/bash

set -Eeuo pipefail

: ${ZCASH_ADDNODE:="mainnet.z.cash"}
: ${ZCASH_DATADIR:="/zcash/data"}
: ${ZCASH_RPCUSER:="$(head -c 32 /dev/urandom | base64)"}
: ${ZCASH_RPCPASSWORD:="$(head -c 32 /dev/urandom | base64)"}

# Create data directory if it doesn't exist
[ ! -d "${ZCASH_DATADIR}" ] && mkdir -p ${ZCASH_DATADIR}

# Insert config to default zcash-cli data directory
cat << EOF > /root/.zcash/zcash.conf
addnode=${ZCASH_ADDNODE}
rpcuser=${ZCASH_RPCUSER}
rpcpassword=${ZCASH_RPCPASSWORD}
EOF

# Use same config for 'zcashd', so we can exec 'zcash-cli'
# within the container
cp /root/.zcash/zcash.conf ${ZCASH_DATADIR}/zcash.conf

# Default exec is 'zcashd'
[ ${#} -eq 0 ] && set -- zcashd
exec $@ --datadir=${ZCASH_DATADIR}
