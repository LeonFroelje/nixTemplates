{
  description = "Rust devShell";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvimModules.url = "github:LeonFroelje/nixvim-modules";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      nixvimModules,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default =
        (pkgs.buildFHSEnv {
          name = "rust-shell";
          targetPkgs =
            p: with p; [
              cargo
              rustc
              rust-analyzer
              clippy
              rustfmt
              pkg-config
              openssl
              stdenv.cc
              (nixvimModules.lib.mkNvim [ nixvimModules.nixosModules.rust ])
            ];
          runScript = "zsh";
        }).env;
    };
}
