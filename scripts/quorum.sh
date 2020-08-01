#!/bin/bash

# UDS_WAIT=10

# while getopts "t:n:" arg; do
#   case $arg in
#     t)
#       TESSERA=$OPTARG
#       ;;

#     n)
#       NODE_ID=$OPTARG
#       ;;
#   esac
# done

# for i in {1..50}
# do  
#   set -e
#   if [ "$(wget2 --http2 --timeout ${UDS_WAIT} -qO- $TESSERA:9000/upcheck)" == "I'm up!" ]; then echo "tessera is up" && break
#   else
#     echo "Sleep ${UDS_WAIT} seconds. Waiting for Tessera at $TESSERA/upcheck."
#     sleep ${UDS_WAIT}
#   fi
# done

if ! [ -d /opt/blockchain/quorum/qdata/geth/lightchaindata ]; then
  geth --datadir /opt/blockchain/quorum/qdata init /opt/blockchain/quorum/genesis.json
  # sleep 10s
fi


# PRIVATE_CONFIG=/opt/blockchain/tessera/qdata/tm.ipc
PRIVATE_CONFIG=ignore nohup geth --identity node$NODE_ID --verbosity 5 --networkid 10 \
  --datadir /opt/blockchain/quorum/qdata \
  --nodiscover --permissioned \
  --raft --raftport 50400 --port 21000 \
  --ws --wsaddr 0.0.0.0 --wsport 8546 --wsorigins "*" --wsapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft,rpc,quorumPermission \
  --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpccorsdomain "*" --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft,rpc,quorumPermission \
  --emitcheckpoints --unlock 0 --password /opt/blockchain/quorum/passwords 2> /opt/blockchain/quorum/logs/geth.log