{
  description = "my nixos system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty?ref=v1.0.1";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, ghostty, neovim-nightly-overlay, zen-browser, ... }: 
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
                neovim-nightly-overlay.packages.${pkgs.system}.default
                zen-browser.packages.${pkgs.system}.default
              ];
            }
            ./nixos/configuration.nix
          ];
        };
      };
    };
}
