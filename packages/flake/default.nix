{
  lib,
  stdenvNoCC,
  replaceVars,
  gum,
  nixos-option,
  writeShellApplication,
  inputs,
  ...
}: let
  substitute = args: builtins.readFile (replaceVars args);

  filter-flake = writeShellApplication {
    name = "filter-flake";
    text = builtins.readFile ./filter-flake.sh;
    checkPhase = "";
  };
  filter-flakes = writeShellApplication {
    name = "filter-flakes";
    text = builtins.readFile ./filter-flakes.sh;
    checkPhase = "";
    runtimeInputs = [
      filter-flake
    ];
  };
  get-registry-flakes = writeShellApplication {
    name = "get-registry-flakes";
    text = builtins.readFile ./get-registry-flakes.sh;
    checkPhase = "";
  };
in
  writeShellApplication {
    name = "flake";
    text = substitute {
      src = ./flake.sh;

      help = ./help;
      flakeCompat = inputs.flake-compat;
      isDarwin =
        if stdenvNoCC.isDarwin
        then "true"
        else "false";
    };
    checkPhase = "";
    runtimeInputs = [
      gum
      filter-flakes
      get-registry-flakes
      nixos-option
    ];
  }
