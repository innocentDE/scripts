#!/bin/bash

packages=("git" "curl" "fzf" "vim" "htop")
choice=$(gum choose "Download all packages" "Select packages individually")

if [ "$choice" == "Download all packages" ]; then
  selected_packages=("${packages[@]}")
else
  selected_packages=($(gum choose --no-limit "${packages[@]}"))
fi

echo "You have selected the following packages:"
for package in "${selected_packages[@]}"; do
  echo "- $package"
done

if gum confirm "Do you want to proceed with downloading these packages?"; then
  for package in "${selected_packages[@]}"; do
    echo "Downloading $package..."
    curl -o "${package}.bin" https://ash-speed.hetzner.com/100MB.bin
    echo "$package downloaded."
  done
  echo "All selected packages have been downloaded."
else
  echo "Aborted."
fi
