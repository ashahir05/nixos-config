{ pkgs, lib ? pkgs.lib, inputs, ... }: final: prev:
  let
    overlayFileNames = lib.lists.remove null (lib.mapAttrsToList (key: value: if key != "default.nix" && value == "regular" && lib.strings.hasSuffix ".nix" key then key else null) (builtins.readDir ./.));
    overlayFiles = lib.lists.forEach overlayFileNames (file: lib.strings.removeSuffix ".nix" file);
    overlaysSet = file:
      let
        parts = lib.strings.splitString "." file;
        reversedParts = lib.lists.reverseList parts;
      in
        lib.foldl (x: y: if y == (lib.lists.last parts) then { ${y} = import ./${file}.nix { inherit  prev final inputs; }; } else { ${y} = x; }) {} reversedParts;
  in
    (lib.foldl (a: b: a // b) {} (lib.lists.forEach overlayFiles (file: overlaysSet file)))
