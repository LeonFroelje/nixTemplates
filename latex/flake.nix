{
  description = "LaTeX devShell";
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
          name = "latex-shell";
          targetPkgs =
            p: with p; [
              texliveFull # Or texlive.combined.scheme-medium
              ltex-ls-plus
              (nixvimModules.lib.mkNvim [ nixvimModules.nixosModules.latex-de-DE ])
            ];
          runScript = "zsh";
        }).env;
    };
}
