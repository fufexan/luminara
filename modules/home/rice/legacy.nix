{ config, lib, pkgs, ... }:
let
  cfg = config.jh-devv.home.rice.legacy;
in {
  config = lib.mkIf cfg.enable {
    home.file."${config.xdg.configHome}" = {
      source = ./legacy;
      recursive = true;
    };

  };
}
