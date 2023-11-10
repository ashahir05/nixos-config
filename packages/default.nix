{ pkgs, lib ? pkgs.lib, overlays, ... }:
  let
    pkgsFileNames = lib.lists.remove null (lib.mapAttrsToList (key: value: if (value == "directory") then key else null) (builtins.readDir ./.));
    overlayFileNames = lib.lists.remove null (lib.mapAttrsToList (key: value: if (key != "default.nix" && value == "regular" && lib.strings.hasSuffix ".nix" key) then key else null) (builtins.readDir ../overlays));
    pkgsFiles = lib.lists.forEach pkgsFileNames (file: lib.strings.removeSuffix ".nix" file);
    overlayFiles = lib.lists.forEach overlayFileNames (file: lib.strings.removeSuffix ".nix" file);
    
    modifiedPkgs = (pkgs.extend overlays.x86_64-linux);
    
    overlaysSet = file:
      let
        parts = lib.strings.splitString "." file;
      in
        lib.foldl (x: y: if y == (lib.lists.last parts) then { ${y} = (lib.attrsets.attrByPath parts null modifiedPkgs ); } else { ${y} = x; }) {} parts;
        
    pkgsSet = file:
      { ${lib.lists.last (lib.strings.splitString "." file)} = modifiedPkgs.callPackage ./${file} {}; };
      
    overlayPackages = (lib.foldl (a: b: a // b) {} (lib.lists.forEach overlayFiles (file: overlaysSet file)));
    newPackages = (lib.foldl (a: b: a // b) {} (lib.lists.forEach pkgsFiles (file: pkgsSet "${file}")));
  in
      overlayPackages // newPackages
