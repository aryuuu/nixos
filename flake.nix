{
  description = "my nixos system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ghostty, ... }: 
    let 
      system = "x86_64-linux";
      
      pkgs = import nixpkgs {
        inherit system;
        
        config = {
            allowUnfree = true;
        };
      };

    in 
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit system; };

          modules = [
            {
              environment.systemPackages = [
                ghostty.packages.x86_64-linux.default
              ];
            }
            ./nixos/configuration.nix
          ];
        };
      };
    };
}
