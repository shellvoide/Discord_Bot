#!/bin/bash

if [ $(id -u) != 0 ]; then
    echo "Run this script as root!"
    exit 0
fi

if [[ "$#" -eq 0 ]]; then
    echo "No arguments passed."
    echo "Usage: sudo ./MakeBot.sh <projectName> <Discord Bot Token>"
    echo "Example: sudo ./MakeBot.sh randomBotName 1312312312415135135"
    exit 0
fi

fileName=$_| cut -d '/' -f 2
projectName=$1
oAuthToken=$2
output=`node -h | grep "Command not found"`
if [[ $output == '' ]]; then
    echo "[+] NodeJS Installed on the system!"
    echo "Checking version: "
    version=`node -v | cut -d '.' -f 1`
    echo "Version is $version"
    if [[ $version == 'v12' ]]; then
        echo "Checking version of npm"
        version_npm=`npm -v | grep "Command not found"`
        if [[ $version_npm =~ [0-9] ]]; then
            echo "[!] NPM not installed on system."
            echo "Beginning installation"
            apt install -y npm
            bash $fileName $projectName $oAuthToken; exit 0
        else
            echo "Preparing installation of Discord.js"
            mkdir $projectName && cd $projectName
            npm init -y
            npm install --save discord.js dotenv
            touch bot.js .env
            echo "$oAuthToken" > .env
            echo "Installation Completed! You may begin to work on your bot now."
            echo "Main working file: $projectName/bot.js"
            mv ../default.js $projectName/bot.js
            echo "client.login('$oAuthToken');" >> bot.js
            exit 0
        fi
    else
        echo "Upgrading to version 12"
        apt update
        apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
        curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
        apt -y install nodejs
        clear
        version=`node -v`
        echo "Installed Version $version"
        echo "Restarting..."
        bash $fileName $projectName $oAuthToken; exit 0
    fi


else
    echo "[!] No installation of NodeJS found on system!. Initiating installation process!"
    apt update
    apt -y install curl dirmngr apt-transport-https lsb-release ca-certificates
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
    apt -y install nodejs
    clear
    echo "Successfully installed! Restarting..."
    bash $fileName $projectName $oAuthToken; exit 0
fi