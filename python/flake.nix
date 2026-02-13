{
  description = "Python devShells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvimModules = {
      url = "github:LeonFroelje/nixvim-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, nixvimModules }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in 
  {

    devShells.${system} = {
      default = (pkgs.buildFHSEnv {
        name = "Python dev shell";
        targetPkgs = p: with p; [
          fd
          ripgrep
          (nixvim.legacyPackages.${system}.makeNixvim nixvimModules.nixosModules."python") 
          python314
          python314Packages.pip
        ];
        runScript = "zsh";
      }).env;

      uv = (pkgs.buildFHSEnv {
        name = "uv-shell";
        targetPkgs = p: with p; [
          uv
          zlib
          glib
          openssl
          stdenv.cc.cc.lib 
          (nixvim.legacyPackages.${system}.makeNixvim nixvimModules.nixosModules."python") 
        ];
        runScript = "zsh";
        
        multiPkgs = p: [ p.zlib p.openssl ];
      }).env;
    };
  };
}
