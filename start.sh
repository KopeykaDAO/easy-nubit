#!/bin/bash

wget https://raw.githubusercontent.com/KopeykaDAO/easy-nubit/main/Dockerfile
docker build -t nubit-node .
docker run -d --name nubit-node --restart unless-stopped -it -p 2121:2121 -p 26657:26657 -p 26658:26658 -p 26659:26659 nubit-node
echo "nohup bash <(curl -s https://nubit.sh) > /root/nubit-light.log" | docker exec -i nubit-node /bin/bash
exit 1
