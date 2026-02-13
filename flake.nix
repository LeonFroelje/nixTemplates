{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    templates = {
      typst = {
        path = ./typst;
        description = "Typst devShells in for different languages";
        welcomeText = "";
      };
      python= {
        path = ./python;
        description = "Python devShells";
        welcomeText = "";
      };
    };


  };
}
