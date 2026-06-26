#!/usr/bin/env bash
set -e
cd ~
git clone https://github.com/Hugo-Dutheil/nixos.git nixos
sudo cp /etc/nixos/hardware-configuration.nix ~/nixos/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/nixos#default --impure
