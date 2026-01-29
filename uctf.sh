#!/bin/bash

# =======
# Options
# =======

if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
    echo "USAGE installer.sh [OPTIONS]"
    echo "  -h  --help          afficher le présent message"
    echo "  -fd --fichier-defis produire un fichier de défis"
    echo "  -s  --sauvegarde    produire une sauvegarde"
    echo "  -i  --charger       charger un fichier de défis ou une sauvegarde"
    echo "  -R  --reinitialiser effacer la sauvegarde et réinitialiser le ctf"
    exit
fi

if [ "$1" == "-fd" ] || [ "$1" == "--fichier-defis" ]; then 
    cd sauvegarde/init
    zip ../../defis.zip *
    cd ../../
    exit
fi

if [ "$1" == "-s" ] || [ "$1" == "--sauvegarde" ]; then 
    if [ ! -d sauvegarde/derniere ]; then
        echo "Vous n'avez pas de sauvegarde."
    fi 

    cd sauvegarde/derniere
    zip ../../sauvegarde.zip *
    cd ../../
    exit
fi

if [ "$1" == "-i" ] || [ "$1" == "--charger" ]; then 
    if [ -z "$2" ]; then
        echo "USAGE uctf.sh --charger <fichier>"
        echo "Veuillez spécifier un fichier à charger"
        exit
    fi

    if [ ! -f "$2" ]; then
        echo "USAGE uctf.sh --charger <fichier>"
        echo "Le chemin spécifié n'est pas un fichier"
        exit
    fi

    unzip "$2" -d sauvegarde/derniere/
fi

if [ "$1" == "-R" ] || [ "$1" == "--reinitialiser" ]; then 
    echo "Êtes-vous sûr de vouloir EFFACER VOTRE SAUVEGARDE?"
    echo "Toutes les données seront EFFACÉES. Cette action est IRRÉVESIBLE."
    echo "[O/n]"
    read effacer
    
    if [ "$effacer" == "O" ] || [ "$effacer" == "o" ]; then 
        rm -rf sauvegarde/derniere
    else 
        echo "Annulation"
    fi

    exit
fi

# ======================
# Exécution du programme
# ======================

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

actif="true"

while [ -z "$(docker ps -a --format '{{.Names}}:{{.Status}}' | grep 'uctf-ctfd' | head -n 1 | grep '(healthy)')" ]; do 
    sleep 1
done

xdg-open http://localhost:8000
echo "Votre navigateur devrait s'ouvrir. S'il n'est pas ouvert, naviguez au lien suivant : http://localhost:8000"

terminer(){
    kill $docker_pid

    # Sauvegarder les données
    if [ ! -d ./sauvegarde/derniere ]; then
        mkdir ./sauvegarde/derniere
    fi

    for z in "${volumes[@]}"; do 
        echo 
        echo "Enregistrement de ${z}"
        docker run --rm -v $(docker volume ls -q | grep $z | head -n 1):/donnees -v ./sauvegarde:/sauvegarde nginx:stable bash -c "cd /donnees && tar cvf /sauvegarde/derniere/${z}.tar ."
    done

    actif="false"
}

trap 'terminer' SIGINT

while [ "$actif" == "true" ]; do 
    sleep 1
done