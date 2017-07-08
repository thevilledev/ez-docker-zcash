#!/bin/bash
: ${CONTAINER_NAME:="dockerzcash_zcash_1"}
docker exec ${CONTAINER_NAME} zcash-cli "$@"
