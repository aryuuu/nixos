{
  description = "my nixos system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    ghostty.url = "github:ghostty-org/ghostty";
    # nixpkgs-stable.url = "github:nixos/nixpkgs?ref=release-24.11";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    mcp-hub.url = "github:ravitemer/mcp-hub";
    gitlogue.url = "github:aryuuu/gitlogue-flake";
    opencode.url = "github:anomalyco/opencode";
    kiro-cli.url = "github:aryuuu/kiro-cli-flake";
  };

  outputs = { self, nixpkgs, neovim-nightly-overlay, zen-browser, mcp-hub, gitlogue, opencode, kiro-cli, ghostty, ... }: 
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
          modules = [
            {
              environment.systemPackages = [
                ghostty.packages.${system}.default
                neovim-nightly-overlay.packages.${system}.default
                zen-browser.packages.${system}.default
                mcp-hub.packages.${system}.default
                gitlogue.packages.${system}.default
                opencode.packages.${system}.default
                kiro-cli.packages.${system}.default
              ];
            }
            ./nixos/configuration.nix
          ];
        };
      };
    };
}
