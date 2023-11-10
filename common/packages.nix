{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    wget
    home-manager
    usbutils
    neovim
    ripgrep
    nnn
    commonsCompress
    unzip
    manix
    file
    lshw
    openbangla-keyboard
    amberol
    vlc
    fragments
    google-chrome
  ];
}