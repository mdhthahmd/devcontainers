#!/bin/bash -i
cd $(dirname "$0")

if [ -z $HOME ]; then
    HOME="/root"
fi

FAILED=()

check() {
    LABEL=$1
    shift
    echo -e "\n๐งช  Testing $LABEL: $@"
    if $@; then 
        echo "๐  Passed!"
    else
        echo "๐ฅ  $LABEL check failed."
        FAILED+=("$LABEL")
    fi
}

checkMultiple() {
    PASSED=0
    LABEL="$1"
    shift; MINIMUMPASSED=$1
    shift; EXPRESSION="$1"
    while [ "$EXPRESSION" != "" ]; do
        if $EXPRESSION; then ((PASSED++)); fi
        shift; EXPRESSION=$1
    done
    check "$LABEL" [ $PASSED -ge $MINIMUMPASSED ]
}

checkExtension() {
    checkMultiple "$1" 1 "[ -d ""$HOME/.vscode-server/extensions/$1*"" ]" "[ -d ""$HOME/.vscode-server-insiders/extensions/$1*"" ]" "[ -d ""$HOME/.vscode-test-server/extensions/$1*"" ]"
}

# Actual tests
checkMultiple "vscode-server" 1 "[ -d ""$HOME/.vscode-server/bin"" ]" "[ -d ""$HOME/.vscode-server-insiders/bin"" ]" "[ -d ""$HOME/.vscode-test-server/bin"" ]"
checkExtension "dbaeumer.vscode-eslint"
check "node" "node --version"
check "non-root-user" "id node"
check "/home/node" [ -d "/home/node" ]
check "sudo" sudo echo "sudo works."
check "git" git --version
check "command-line-tools" which top ip lsb_release wget curl jq less nano unzip
check "zsh" zsh --version
check "oh-my-zsh" [ -d "$HOME/.oh-my-zsh" ]
check "node" node --version
check "nvm" nvm --version
check "yarn" yarn install
check "npm" npm install
check "eslint" "eslint server.js"
check "test-project" npm run test

# Report result
if [ ${#FAILED[@]} -ne 0 ]; then
    echo -e "\n๐ฅ  Failed tests: ${FAILED[@]}"
    exit 1
else 
    echo -e "\n๐ฏ  All passed!"
    exit 0
fi
