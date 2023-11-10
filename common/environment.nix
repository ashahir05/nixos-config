{ config, pkgs, ... }: {
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  environment.shellAliases = {
    scfg = "cd /nixos";
    spkgs = "scfg && $EDITOR ./common/pkgs.nix ; cd $OLDPWD";
    scommit = "scfg && git add . && git commit -a -m \"Automated commit on $(date)\" ; cd $OLDPWD";
    spush = "scommit && scfg && git push ; cd $OLDPWD";
    sup = "spush && sudo nixos-rebuild switch --flake /nixos/#$\{HOST\}";
    
    cfg = "cd $HOME/.config/nix";
    pkgs = "$EDITOR $HOME/.config/nix/pkgs.nix ; cd $OLDPWD";
    commit = "cfg && git add . && git commit -a -m \"Automated commit on $(date)\" ; cd $OLDPWD";
    push = "commit && cfg && git push ; cd $OLDPWD";
    up = "push && home-manager switch --flake $\{HOME\}/.config/nix/#$\{USER\}@$\{HOST\}";

    srf = "spush && scfg && nix flake update ; cd $OLDPWD";
    rf = "push && cfg && nix flake update ; cd $OLDPWD";
    
    nixgc = "nix-collect-garbage -d && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
  };
}