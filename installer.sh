#!/bin/bash

docker compose -f main-docker-compose.yaml up --build &
pid=$!
while [ -z $(docker ps -a --format '{{.Names}}:{{.Status}}' | grep "uctf-ctfd" | head -n 1 | grep "(healthy)") ]; do
    sleep 1
done
kill $pid

./uctf.sh