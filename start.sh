#!/bin/bash

# Обновление пакетов
echo "Происходит обновление пакетов..."
if sudo apt update && sudo apt upgrade -y; then
  echo "Обновление пакетов: Успешно"
else
  echo "Обновление пакетов: Ошибка"
  exit 1
fi

# Установка дополнительных пакетов
echo "Происходит установка дополнительных пакетов..."
if sudo apt install ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev curl git wget make -y; then
  echo "Установка дополнительных пакетов: Успешно"
else
  echo "Установка дополнительных пакетов: Ошибка"
  exit 1
fi

# Установка Docker если его нет
if ! command -v docker
then
  echo "Происходит установка Docker..."
  if curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&
    sudo apt-get update &&
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y; then
    echo "Установка Docker: Успешно"
  else
    echo "Установка Docker: Ошибка"
    exit 1
  fi
fi

# Установка Docker Compose если его нет
if ! command -v docker-compose
then
  echo "Происходит установка Docker Compose..."
  if sudo apt-get install docker-compose -y; then
    echo "Установка Docker Compose: Успешно"
  else
    echo "Установка Docker Compose: Ошибка"
    exit 1
  fi
fi

# Создание Docker контейнера
wget https://raw.githubusercontent.com/KopeykaDAO/easy-nubit/main/Dockerfile
docker build -t nubit-node .
docker run -d --name nubit-node --restart unless-stopped -it -p 2121:2121 -p 26657:26657 -p 26658:26658 -p 26659:26659 nubit-node

# Копирование ноды в контейнер если она уже была установлена
if [ -d "~/.nubit-light-nubit-alphatestnet-1" ]
then
  docker cp ~/nubit-node/mnemonic.txt nubit-node:/root/nubit-node/mnemonic.txt
  docker cp ~/.nubit-light-nubit-alphatestnet-1 nubit-node:/root/.nubit-light-nubit-alphatestnet-1
fi

# Запуск ноды
echo "nohup bash <(curl -s https://nubit.sh) > /root/nubit-light.log" | docker exec -i nubit-node /bin/bash
