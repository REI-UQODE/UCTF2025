# \<\/UCTF> 2025

![Bannière </UCTF>](README/complet_arrière-plan.svg)

La compétiton de cybersécurité de l'UQODE 2025 sur votre ordinateur.

## Avis

Ce projet fait usage de **Nginx**, **CTFd**, **Chall-Manager** et **CTFd-Chall-Manager**, qui sont leurs propres projets avec leurs propres contributeurs et leur propore licence.

## Pré-requis

- Une connection internet (pour l'installation)
- Docker
  - **Si vous êtes sur windows**, veuillez vous assurer d'activer le Windows Subsystem for Linux (WSL)

## Installation

1. Téléchargez le projet ici-présent
2. Exécutez `./installer.sh`
3. Si vous n'avez pas précédemment téléchargé les défis, acceptez de les télécharger. Sinon refusez, puis indiquez le chemin vers le fichier des défis précédemment téléchargé.
4. Le programme devrait s'exécuter automatiquement

## Exécution

> [!WARNING]
> Le programme ne serat pas fonctionnel avant d'avoir exécuté les étapes d'installation

exécutez `./uctf.sh`

## Désinstallation

exécutez `./désinstaller.sh`

Si vous n'utilisez pas docker, vous pouvez exécuter `docker system prune`, le désinstaller et si vous n'utilisez pas le WSL sur Windows, vous pouvez les désinstaller aussi.

## Fonctionnement

Ce projet se base sur CTFd, une plateforme de compétition en cybersécurité libre de droit. Elle est exécutée dans un conteneur Docker, géré à l'aide de Docker Compose. Nginx est utilisé pour le reverse-proxy. Affin de gérer les défis dynamiques, la plateforme communique avec Chall-Manager à travers CTFd-Chall-Manager.

### Processus d'exécution

1. Vérifie si un dossier `sauvegarde/derniere` (dossier contenant la dernière sauvegarde) existe
   1. Si oui, remplace le contenu des quatres volumes docker par le contenu des archives `.tar` s'y trouvant.
   2. Si non, prend les `.tar` se trouvant dans `sauvegarde/init`
2. Lance Docker Compose en arrière plan
   - **Nginx** Reverse-Proxy
   - **CTFd** Site web
   - **MariaDB** Base de donnée
   - **Redis-SVC**
   - **Chall-Manager** Le gestionnaire de défis dynamiques
3. Lorsqu'un signal `SIGINT` est reçus, copie le contenu des volumes dans les archives `.tar` dans `sauvegarde/derniere`

### Processus d'installation

1. Lance le projet Compose pour créer les volumes
2. Ferme le projet Compose
3. Télécharge/Installe les données de sauvegarde dépendamment de l'utilisateur
4. Lance le processus d'exécution

### Processus de désinstallation

1. Efface toutes les ressources docker associées à ce projet
2. Si l'utilisateur le demande, exécute `docker system prune`
3. Demande à l'utilisateur d'effacer le dossier du projet