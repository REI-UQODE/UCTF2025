# UCTF 2025

La compétiton de cybersécurité de l'UQODE 2025 sur votre ordinateur.

## Avis

Ce projet fait usage de **Nginx**, **CTFd**, **Chall-Manager** et **CTFd-Chall-Manager**, qui sont leurs propres projets avec leurs propres contributeurs et leur propore licence.

## Pré-requis

- Une connection internet (pour l'installation)
- Docker
  - **Si vous êtes sur windows**, veuillez vous assurer d'activer le Windows Subsystem for Linux (WSL)

## Installation

1. Exécutez `./installer.sh`
2. Di vous n'avez pas précédemment téléchargé les défis, acceptez de les télécharger. Sinon refusez, puis indiquez le chemin vers le fichier des défis précédemment téléchargé.
3. Le programme devrait s'exécuter automatiquement

## Exécution

> [!WARNING]
> Le programme ne serat pas fonctionnel avant d'avoir exécuté les étapes d'installation

exécutez `./uctf.sh`

## Désinstallation

exécutez `./désinstaller.sh`

Si vous n'utilisez pas docker, vous pouvez exécuter `docker system prune`, le désinstaller et si vous n'utilisez pas le WSL sur Windows, vous pouvez les désinstaller aussi.

## Réutiliser un fichier de défis