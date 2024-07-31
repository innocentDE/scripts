#!/bin/bash

sudo chmod +x gum-install.sh
./gum-install.sh > /dev/null 2>&1

extract_package_names() {
  find packages -mindepth 1 -maxdepth 1 -type d -exec basename {} \;
}

while true; do
  packages=($(extract_package_names))

  choice=$(gum choose "all" "custom" "abort")

  if [ "$choice" == "all" ]; then
    selected_packages=("${packages[@]}")
  elif [ "$choice" == "abort" ]; then
    exit 1
  else
    selected_packages=($(gum choose --no-limit "${packages[@]}"))
  fi

  if [ ${#selected_packages[@]} -eq 0 ]; then
    echo "No packages selected."
    exit 1
  fi

  echo "You have selected the following packages:"
  for package in "${selected_packages[@]}"; do
    echo "- $package"
  done

  if gum confirm "Do you want to proceed with these packages?"; then
    clear
    total_packages=${#selected_packages[@]}
    completed=0

    for package in "${selected_packages[@]}"; do
      ((completed++))
      progress="$completed/$total_packages packages installed"

      gum spin --title "$progress"

      script_path="packages/$package/$package.sh"
      if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if ./"$script_path" > /dev/null 2>&1; then
          echo "- $package ✔"
        else
          echo "- $package ✘"
        fi
      else
        echo "Script for package $script_path not found. Skipping."
      fi
    done
    echo "All selected packages have been installed."
    break
  fi
done
