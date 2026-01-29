#!/bin/bash

# --help
if [ "$1" == "--help" ] || [ "$1" == "-h" ] || [ "$1" == "-?" ]; then
    echo "USAGE installer.sh [--help|fichier]"
    echo "  --help  afficher le présent message"
    echo "  fichier chemin vers le fichier des défis (optionnel)"
    exit
fi

# Initialiser l'environnement docker
docker compose -f main-docker-compose.yaml up --build &
pid=$!
echo $pid 

while [ -z "$(docker ps -a --format '{{.Names}}:{{.Status}}' | grep "uctf-ctfd" | head -n 1 | grep '(healthy)')" ]; do
    sleep 1
done
kill -9 $pid

# Attendre la fermeture complète des conteneurs
while [ -n "$(docker ps | grep 'uctf-ctfd' | head -n 1)" ]; do
    sleep 1
done

# Installer/Télécharger les données de sauvegarde
if [ -f "$1" ]; then 
    unzip $1 -d ./sauvegarde/init
else 
    echo "Télécharger les défis? [O/n]"
    read telecharger

    if [ "$telecharger" == "N" ] || [ "$telecharger" == "n" ]; then 
        echo "Veuillez spécifier l'emplacement du fichier des défis."
        read defis
        unzip $defis -d ./sauvegarde/init
    else 
        wget "https://uqoca-my.sharepoint.com/:u:/g/personal/uqode_uqo_ca/IQB15yGeaIq5RZ_Bfk4yzqGBAd89CJntzQKvUO5sMaG_8Og?download=1" -O ./sauvegarde/defis.zip
        unzip ./sauvegarde/defis.zip -d ./sauvegarde/init/
        rm ./sauvegarde/defis.zip
    fi 
fi 

# Partir le programme
./uctf.sh