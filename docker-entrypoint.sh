#!/bin/bash

set -Eeuo pipefail

: ${ZCASH_ADDNODE:="mainnet.z.cash"}
: ${ZCASH_DATADIR:="/home/zcash/data"}
: ${ZCASH_RPCUSER?"'rpcuser' parameter required"}
: ${ZCASH_RPCPASSWORD?"'rpcpassword' parameter required"}

# Create data directory if it doesn't exist
[ ! -d "${ZCASH_DATADIR}" ] && mkdir -p ${ZCASH_DATADIR}

# Insert config to default zcash-cli data directory
cat << EOF > /home/zcash/.zcash/zcash.conf
addnode=${ZCASH_ADDNODE}
rpcuser=${ZCASH_RPCUSER}
rpcpassword=${ZCASH_RPCPASSWORD}
EOF

# Use same config for 'zcashd', so we can exec 'zcash-cli'
# within the container
cp /home/zcash/.zcash/zcash.conf ${ZCASH_DATADIR}/zcash.conf

exec $@ --datadir=${ZCASH_DATADIR}
