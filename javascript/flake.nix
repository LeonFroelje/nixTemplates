{
  description = "JavaScript/Node devShell";
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
          name = "js-shell";
          targetPkgs =
            p: with p; [
              nodejs_22
              corepack # Includes npm, pnpm, yarn
              typescript-language-server
              (nixvimModules.lib.mkNvim [ nixvimModules.nixosModules.javascript ])
            ];
          runScript = "zsh";
        }).env;
    };
}
