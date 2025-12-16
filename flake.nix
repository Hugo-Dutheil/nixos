{
  description = "Main flake";

  inputs = {
#     nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
#       url = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs =
    { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      settings = {
        username = "hdutheil";
        configPath = "/home/${settings.username}/nixos";
        machine = "thinkpad";
        nixosVersion = "25.05";
      };
      theme =
        import "${settings.configPath}/colors/colors.nix" { inherit settings; };
      colors = theme.theme;
    in {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs settings colors; };

        modules = [

          "${settings.configPath}/configuration.nix"

          inputs.home-manager.nixosModules.home-manager {
            environment.systemPackages = [ ];#inputs.quickshell.packages.${system}.default ];
            home-manager.extraSpecialArgs = { inherit inputs settings colors; };
          }

        ] ++ nixpkgs.lib.optionals (settings.machine == "thinkpad") [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p16s-amd-gen2
        ];
      };
    };
}
