# Nixos config

## Installation

To install it, you can use on of the following commands:

```bash
nix-shell -p git
git clone https://github.com/Hugo-Dutheil/nixos.git nixos
cd nixos
sudo cp /etc/nixos/hardware-configuration.nix .
sudo nixos-rebuild switch --flake /home/hdutheil/nixos#default --impure
```
