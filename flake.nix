{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.tytanic.url = "github:typst-community/tytanic";

  outputs = { self, nixpkgs, tytanic }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          tinymist
          gemini-cli
          just
          tytanic.packages.${system}.default
        ];
      };
    };
}
