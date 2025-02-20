{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

    nixpkgs = {
    # You can add overlays here
    overlays = [
      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      inputs.self.overlays.modifications
      inputs.self.overlays.additions
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  jh-devv.nixos = {
    hyprland.enable = true;
    pkgs.gaming.enable = true;
    services.enable = true;
    services.gnome.enable = true;
    boot.grub.enable = true;
    boot.gdm.enable = true;
    boot.gdm.windowManager = pkgs.hyprland;
  };

  # Shell
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  # User Accounts Configuration
  users.users.jh-devv = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  # Networking Configuration
  networking = {
    hostName = "luminara";
    networkmanager.enable = true;
  };
  
  time.timeZone = "Europe/Helsinki";

  services.xserver.layout = "fi";

  # System Version
  system.stateVersion = "23.05";
}
