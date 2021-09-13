#!/bin/bash
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Midhath Ahmed. All rights reserved.
# Licensed under the MIT License.
#-------------------------------------------------------------------------------------------------------------
#
# Syntax: ./devenv-setup.sh [project name] [development environment]

PROJECT=${1:-"new-project"}
DEVENV=${2:-"dotnet-sdk-5.0.400-nodejs-14.17.6"}
REMOTE_DEVENV=https://github.com/mdhthahmd/devcontainers.git

set -e

git init $PROJECT && cd $PROJECT

git remote add origin $REMOTE_DEVENV
git sparse-checkout init
git sparse-checkout set "environments/$DEVENV"

git pull origin main

# move all files and folders including dot prefixed ones
shopt -s dotglob nullglob
mv environments/$DEVENV/* .
shopt -u dotglob nullglob

# clean up
rm -rf environments .git


# curl  https://api.github.com/repos/mdhthahmd/devcontainers/git/trees/main | jq -r '.tree[] | select(.path=="environments").url'
# curl $(curl  https://api.github.com/repos/mdhthahmd/devcontainers/git/trees/main | jq -r '.tree[] | select(.path=="environments").url') | jq -r '.tree[].path'