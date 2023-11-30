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
    sbctl
    e2fsprogs
    manix
    file
    lshw
    ibus-engines.openbangla-keyboard
    vlc
    google-chrome
  ];
}
