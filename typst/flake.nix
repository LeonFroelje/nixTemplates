{
  description = "Typst devShells for specific languages";

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
  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      nixvimModules,
    }:
    let
      languages = [
        "de-DE"
        "en-US"
        "en-GB"
      ];
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system} = builtins.listToAttrs (
        pkgs.lib.lists.map (lang: {
          name = "typst-${lang}";
          value = pkgs.mkShell {
            packages = with pkgs; [
              ltex-ls-plus
              fd
              ripgrep
              (nixvimModules.lib.mkNvim (
                with nixvimModules.nixosModules;
                [
                  nixvimModules.nixosModules."typst-${lang}"
                ]
              ))
            ];
            shellHook = "zsh";
          };
        }) languages
      );
    };
}
