{ config, ... }:

{
  imports =
    [
      ../../common
      ./hardware-configuration.nix
    ];
    
  networking.hostName = "ashahir-PC";
}

