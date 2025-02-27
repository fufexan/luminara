{ inputs, options, config, lib, pkgs, ... }:
let
  cfg = config.jh-devv.nixos.hyprland;
in {
  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      cliphist
      kitty
      libsecret
      libvirt
      libnotify
      wlr-randr
      wl-clipboard
      xdg-utils
      xorg.xhost
    ];

    # Hardware and Environment Configuration
    hardware = {
      bluetooth.enable = true;
      opengl.enable = true;
    };

    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

    # Enable Hyprland

    programs.hyprland = {
        enable = true;
        xwayland.enable = true; 
    };

    # XDG Portal.
    xdg = {
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          #xdg-desktop-portal-wlr
          xdg-desktop-portal-gtk
        ];
      };
    };

    # Polkit
    security.polkit.enable = true;

    # Enable gnome polkit
    systemd = {
      # Please figure out hyprland config in home manager owo
      user.services.polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        #wantedBy = [ "graphical-session.target" ];
        #wants = [ "graphical-session.target" ];
        #after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    }; 



    # Environment Variables Configuration
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    # Fonts Configuration
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono"]; })
      # Add more fonts here if needed
    ];

    # Swaylock
    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };

  };
}
