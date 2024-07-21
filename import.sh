#!/bin/bash

docker exec -i nubit-node rm -rf /root/.nubit-light-nubit-alphatestnet-1
docker cp ~/nubit-node/mnemonic.txt nubit-node:/root/nubit-node/mnemonic.txt
docker cp ~/.nubit-light-nubit-alphatestnet-1 nubit-node:/root/.nubit-light-nubit-alphatestnet-1
docker restart nubit-node
exit 1
