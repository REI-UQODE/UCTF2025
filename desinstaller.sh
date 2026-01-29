#!/bin/bash

# Volumes docker
volumes=("uctf-db_data" "uctf-redis_data" "uctf-registry_data" "uctf-uploads")

# Conteneurs
conteneurs=("uctf-nginx" "uctf-ctfd" "uctf-redis-svc" "uctf-chall-manager" "uctf-chall-manager-janitor" "uctf-registry" "uctf-db" "uctf-cache")

for z in $conteneurs; do 
    docker stop $(docker ps --format '{{.Names}}' | grep $z)
    docker rm $(docker ps --format '{{.Names}}' | grep $z)
done

for z in $volumes; do 
    docker volume rm $(docker volume ls --format '{{.Name}}' | grep $z)
done

echo "Souhaitez-vous exécuter 'docker system prune?'"
echo "Si vous avez d'autres projets/applications docker, n'exécutez pas cette commande."
echo "Sinon, cette commande effacera les ressources inutilisé par cette application."
echo "[O/n] > "
read effacer

if [ $effacer -eq "O" ] || [ $effacer -eq "o" ]; then 
    docker system prune -y
else; then 
    echo "'docker system prune' ne sera pas exécuté."
fi

echo 
echo "Veuillez effacer le dossier contenant l'UCTF pour terminer la désinstallation"