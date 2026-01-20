{
  description = "Typst devShells for specific languages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim = {
          url = "github:nix-community/nixvim";
          inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixvim }:
  let
    languages = [ "de-DE" "en-US" "en-GB" ];
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in 
  {
    nixosModules = builtins.listToAttrs (pkgs.lib.lists.map (lang: {
      name = "typst-${lang}";
      value = { config, lib, pkgs, ... }: {
        imports = [ ./typst.nix ];
        typstConfig = {
          enable = true;
          language = lang;
        };
      };
    }) languages);
    devShells.${system} = builtins.listToAttrs (pkgs.lib.lists.map (lang: {
        name = "typst-${lang}";
        value = pkgs.mkShell {
          packages = [
            pkgs.ltex-ls-plus
            (nixvim.legacyPackages.${system}.makeNixvim self.nixosModules."typst-${lang}" ) 
          ];
          shellHook = "zsh";
        };
     }) languages);
  };
}

