#!/bin/bash

# Volumes dockers
volumes=("uctf-db_data" "uctf-redis_data" "uctf-registry_data" "uctf-uploads")

# Charger les données
for z in "${volumes[@]}"; do
    echo 
    echo "Chargement de ${z}"
    if [ -d sauvegarde/derniere ]; then
        docker run --rm -v $(docker volume ls -q | grep $z | head -n 1):/donnees -v ./sauvegarde:/sauvegarde nginx:stable bash -c "cd /donnees && tar xvf /sauvegarde/derniere/${z}.tar"
    else
        docker run --rm -v $(docker volume ls -q | grep $z | head -n 1):/donnees -v ./sauvegarde:/sauvegarde nginx:stable bash -c "cd /donnees && tar xvf /sauvegarde/init/${z}.tar"
    fi
done

# Démarrer le serveur
docker compose -f ./main-docker-compose.yaml up --build &
docker_pid=$!

actif=true

while [ -z $(docker ps -a --format '{{.Names}}:{{.Status}}' | grep "uctf-ctfd" | head -n 1 | grep "(healthy)") ]; do 
    xdg-open localhost:8000
done

terminer(){
    kill $docker_pid

    # Sauvegarder les données
    if [ ! -d ./sauvegarde/derniere ]; then
        mkdir ./sauvegarde/derniere
    fi

    for z in $volumes; do 
        echo 
        echo "Enregistrement de ${z}"
        docker run --rm -v $(docker volume ls -q | grep $z | head -n 1):/donnees -v ./sauvegarde:/sauvegarde nginx:stable bash -c "cd /donnees && tar cvf /sauvegarde/derniere/${z}.tar ."
    done

    actif=false
}

trap 'terminer' SIGINT

while ($actif); do 
    sleep 1
done