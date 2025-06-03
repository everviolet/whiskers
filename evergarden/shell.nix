{
  evgLib,
  riceLib,

  lib,
  mkShellNoCC,
  writeShellApplication,
  ...
}:
let
  inherit (builtins)
    elem
    toJSON
    mapAttrs
    listToAttrs
    removeAttrs
    ;
  inherit (lib.lists) imap0;
  inherit (riceLib.color) rgbaToHsla hexToRgba;
  inherit (riceLib.float) floor;
  accents = [
    "red"
    "orange"
    "yellow"
    "lime"
    "green"
    "aqua"
    "skye"
    "snow"
    "blue"
    "purple"
    "pink"
    "cherry"
  ];
  neutrals = [
    "text"
    "subtext1"
    "subtext0"
    "overlay2"
    "overlay1"
    "overlay0"
    "surface2"
    "surface1"
    "surface0"
    "base"
    "mantle"
    "crust"
  ];
  colornames = neutrals ++ accents;

  palette =
    {
      version = "0.1.0";
    }
    // mapAttrs (variant: vpalette: {
      name = variant;
      emoji = " ";
      order = 0;
      dark = variant != "summer";
      colors = listToAttrs (imap0 (
        order: colorn:
        let
          colorv = vpalette.${colorn};
          hex = "#${colorv}";
          rgba = hexToRgba hex;
          rgb = mapAttrs (_: floor) (removeAttrs rgba [ "a" ]);
          hsl = removeAttrs (rgbaToHsla rgba) [ "a" ];
        in
        {
          name = colorn;
          value = {
            name = colorn;
            inherit order;
            inherit hex rgb hsl;
            accent = elem colorn accents;
          };
        }
      ) colornames);
      ansiColors =
      let
        createAnsiColor = ansiName: ansiColor:
        let
          inherit (ansiColor) name code;
          color = evgLib.palette.${variant}.${name};
          hex = "#${color}";
          rgba = hexToRgba hex;
          rgb = mapAttrs (_: floor) (removeAttrs rgba [ "a" ]);
          hsl = removeAttrs (rgbaToHsla rgba) [ "a" ];
        in
        {
          name = ansiName;
          inherit hex rgb hsl code;
        };
      in
        mapAttrs
          (ansiName: ansiColor: {
            name = ansiName;
            order = 0;
            normal = createAnsiColor ansiName ansiColor.normal;
            bright = createAnsiColor ("Bright " + ansiName) ansiColor.bright;
          })
          {
            Black = {
              normal = {
                name = "base";
                code = 0;
              };
              bright = {
                name = "overlay1";
                code = 8;
              };
            };
            Red = {
              normal = {
                name = "red";
                code = 1;
              };
              bright = {
                name = "red";
                code = 9;
              };
            };
            Green = {
              normal = {
                name = "green";
                code = 2;
              };
              bright = {
                name = "green";
                code = 10;
              };
            };
            Yellow = {
              normal = {
                name = "yellow";
                code = 3;
              };
              bright = {
                name = "yellow";
                code = 11;
              };
            };
            Blue = {
              normal = {
                name = "blue";
                code = 4;
              };
              bright = {
                name = "blue";
                code = 12;
              };
            };
            Magenta = {
              normal = {
                name = "pink";
                code = 5;
              };
              bright = {
                name = "pink";
                code = 13;
              };
            };
            Cyan = {
              normal = {
                name = "aqua";
                code = 6;
              };
              bright = {
                name = "aqua";
                code = 14;
              };
            };
            White = {
              normal = {
                name = "text";
                code = 7;
              };
              bright = {
                name = "subtext0";
                code = 15;
              };
            };
          };
    }) (removeAttrs evgLib.palette [ "colors" ]);

  generate-palette = writeShellApplication {
    name = "generate-palette";
    runtimeInputs = [
    ];
    text = ''
      echo '${toJSON palette}' > src/palette.json
    '';
  };

  scripts = [ generate-palette ];
in
mkShellNoCC {
  packages = scripts;
}
