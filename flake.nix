{
  description = "nemoworld.info — Hugo site";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in
    {
      # `nix develop`, and what direnv drops you into. Pinned rather than
      # floating on <nixpkgs> so that the hugo which builds the site in CI is
      # byte-for-byte the one that built it on the workstation — a theme that
      # renders locally and breaks in CI is not a debugging session worth
      # having.
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            hugo
            just
            # `just publish` pushes the built site over SSH.
            rsync
            openssh
          ];
        };
      });
    };
}
