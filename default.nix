{ nixpkgs ? import <nixpkgs> {} }:
with nixpkgs; mkShell {
  packages = [
    fish
    hugo
  ];
}
