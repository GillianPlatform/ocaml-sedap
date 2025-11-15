{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    opam
    pkg-config
    gnumake
    nodejs
  ];
}
