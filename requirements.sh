#!/bin/bash

if ! command -v sudo &> /dev/null
then
    echo "sudo could not be found, installing..."
    sudo apt update
    sudo apt install -y sudo
    sudo usermod -aG sudo $USER

    echo "sudo has been installed and the current user has been added to the sudo group."
fi
