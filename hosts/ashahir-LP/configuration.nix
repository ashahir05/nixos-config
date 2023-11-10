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
  
  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.initrd.systemd.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.lanzaboote = {
    enable = false;
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
  
  environment.persistence."/persist" = {
    hideMounts = true;
    directories = [
      "/nixos"
    ];
  };
  
  hardware.bluetooth.enable = true;

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

