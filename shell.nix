let
  pkgs = import (fetchTarball {
    name = "nixpkgs-22.05-darwin-2022-11-19";
    url = "https://github.com/NixOS/nixpkgs/archive/02ac89b8e803.tar.gz";
    sha256 = "1lambnw3icwbga47rhm03mjz5rniq1m34h4djpz8xgvh7z5wzq8v";
  }) { };

in pkgs.mkShell {
  buildInputs = [
    pkgs.nixfmt
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-test
    pkgs.elmPackages.elm-format
  ];
}
