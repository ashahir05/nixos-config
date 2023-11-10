{
  description = "Ahmed's Nix Config";

  inputs = {  
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;  
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    rec {
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );
      overlays = forAllSystems (system:
        let lib = nixpkgs.lib; pkgs = nixpkgs.legacyPackages.${system};
        in import ./overlays { inherit pkgs lib inputs; }
      );
        
      nixosModules = import ./modules;

      nixosConfigurations = {
        ashahir-PC = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/ashahir-PC/configuration.nix
          ];
        };
        ashahir-LP = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/ashahir-LP/configuration.nix
          ];
        };
      };
    };
}
