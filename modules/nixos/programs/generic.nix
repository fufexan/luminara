{ options, config, lib, pkgs, ... }:
let
  cfg = config.jh-devv.nixos.pkgs.generic;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      blueman
      brightnessctl
      cmake
      fzf
      gcc
      git
      killall
      jq
      meson
      mpv
      imv
      playerctl
      libwebp
      ranger
      file
      ffmpeg
      tree
      unzip
      vim
      wget
      ];
  };
}