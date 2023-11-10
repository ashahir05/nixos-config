{ pkgs, inputs, lib, ... }:

{
  imports = [
    ./environment.nix
    ./packages.nix
    inputs.nix-index-database.nixosModules.nix-index
  ];

  system.stateVersion = "23.05";

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Asia/Dhaka";
  time.hardwareClockInLocalTime = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  sound.enable = true;
  services.pipewire.audio.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome.cheese
    gnome.gnome-music
    epiphany
    gnome.gnome-maps
    gnome.geary
    gnome.totem
  ];
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    adw-gtk3
    wl-clipboard
    wl-clipboard-x11
  ];

  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    config.credential.helper = "libsecret";
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    liberation_ttf
    amiri
    eb-garamond
    lohit-fonts.bengali
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  users.users.ashahir05 = {
    description = "Ahmed Shahir Samin";
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "dialout" ];
    packages = with pkgs; [
      
    ];
  };

  nixpkgs = {
    overlays = [

    ];
 
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = let 
      flakeInputs = builtins.listToAttrs (lib.lists.remove null (lib.attrsets.mapAttrsToList (key: value: if value ? _type && value._type == "flake" then { name = key; value = value; } else null) inputs));
    in 
      lib.mapAttrs (_: value: { flake = value; }) flakeInputs;
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry; 

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };

    settings = {
      experimental-features = "nix-command flakes repl-flake";
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  
  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;
  
  programs.nix-ld.enable = true;

  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
    pkgs.gst_all_1.gst-plugins-good
    pkgs.gst_all_1.gst-plugins-bad
    pkgs.gst_all_1.gst-plugins-ugly
    pkgs.gst_all_1.gst-libav
  ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
