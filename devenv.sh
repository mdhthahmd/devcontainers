#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Midhath Ahmed. All rights reserved.
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Syntax: ./devenv.sh [project name]

set -e

PROJECT=${1:-"new-project"}

GH_USER=mdhthahmd
GH_REPO=devcontainers
GH_BRANCH=main

declare -a DEV_ENVIRONMENTS=(`echo $( curl -s https://raw.githubusercontent.com/$GH_USER/$GH_REPO/$GH_BRANCH/.environments) | sed 's/\n/\n/g'`)

ENV_NO=${#DEV_ENVIRONMENTS[@]}

while true; do
    for (( i=0; i < ${ENV_NO}; i++ ));
    do
        echo "[$i] ${DEV_ENVIRONMENTS[$i]}"
    done
    echo ""; read -p "please choose an environment: `echo $'\n> '`" env
    if [ "$env" -ge 0 ] && [ "$env" -le "$ENV_NO" ]; then
        break
    fi
done

read -p "project name? ($PROJECT): " name

if [ -n "$name" ]; then
    PROJECT=$name
fi

# check if $PROJECT exists and prompt to overwrite
if [ -d "$PROJECT" ]; then
    while true; do
        read -p "path $PROJECT already exists, overwrite? [Y/N]: " confirm
        case $confirm in
            [Yy]* ) rm -rf $PROJECT; break;;
            [Nn]* ) exit;;
            * ) echo "Please answer yes or no.";;
        esac
    done
fi

git init $PROJECT && cd $PROJECT

REMOTE_DEVENV=https://github.com/$GH_USER/$GH_REPO.git

git remote add origin $REMOTE_DEVENV
git sparse-checkout init
git sparse-checkout set "config/${DEV_ENVIRONMENTS[env]}"

git pull origin $GH_BRANCH

# move all files and folders including dot prefixed ones
shopt -s dotglob nullglob
mv environments/${DEV_ENVIRONMENTS[env]}/* .
shopt -u dotglob nullglob

# clean up
rm -rf environments .git