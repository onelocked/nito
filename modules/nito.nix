{
  inputs,
  config,
  lib,
  ...
}:
{
  config = {
    tack.inputs = {
      nixpkgs = "gh:nixos/nixpkgs/nixos-unstable";
      nixvim = "gh:nix-community/nixvim";
    };
    perSystem =
      { pkgs, ... }:
      {
        packages = lib.genAttrs [ "light" "dark" "monochrome" ] (
          theme:
          (inputs.nixvim.lib.evalNixvim {
            extraSpecialArgs = {
              inherit inputs;
              inherit (inputs.nixvim.lib.nixvim) mkRaw;
            };
            modules = with config.neovim; [
              core
              mods
              visual
              {
                nixpkgs = { inherit pkgs; };
                nito = { inherit theme; };
              }
            ];
          }).config.build.package
        );
      };
  };
  options = {
    perSystem = lib.mkOption { type = lib.types.deferredModule; };
    systems = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "x86_64-linux" ];
    };
    neovim = {
      mods = lib.mkOption {
        type = lib.types.deferredModule;
      };
      visual = lib.mkOption {
        type = lib.types.deferredModule;
      };
      core = lib.mkOption {
        type = lib.types.deferredModule;
      };
    };
  };
}
