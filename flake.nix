{
  description = "my nixos system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    ghostty = {
      url = "github:ghostty-org/ghostty";

      # NOTE: The below 2 lines are only required on nixos-unstable,
      # if you're on stable, they may break your build
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
    };
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    mcp-hub.url = "github:ravitemer/mcp-hub";
  };

  outputs = { self, nixpkgs, ghostty, neovim-nightly-overlay, zen-browser, mcp-hub, ... }: 
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
                mcp-hub.packages.${pkgs.system}.default
              ];
            }
            ./nixos/configuration.nix
          ];
        };
      };
    };
}
