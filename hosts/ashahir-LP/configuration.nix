{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [
      ../../common
      ./hardware-configuration.nix
      inputs.lanzaboote.nixosModules.lanzaboote 
      inputs.impermanence.nixosModules.impermanence 
    ];
    
  networking.hostName = "ashahir-LP";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [];
  networking.firewall.allowedUDPPorts = [];
  
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.plymouth.enable = true;

  boot.kernelParams = [
    "quiet"
    "splash"
    "loglevel=3"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
  
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/var"
      "/etc"
    ];
  };
  
  hardware.bluetooth.enable = true;

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = false;
  security.pam.services.gdm-fingerprint = lib.mkIf (config.services.fprintd.enable) {
    text = ''
      auth       required                    pam_shells.so
      auth       requisite                   pam_nologin.so
      auth       requisite                   pam_faillock.so      preauth
      auth       required                    ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth       optional                    pam_permit.so
      auth       required                    pam_env.so
      auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
      
      account    include                     login
      password   required                    pam_deny.so
      
      session    include                     login
      session    optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 150;
    memoryPercent = 60;
  };
  
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        igpu_power_threshold = -1;
        renice = 20;
      };
    };
  };
}

