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
    removeAttrs
    ;
  inherit (riceLib.color) rgbaToHsla hexToRgba;
  inherit (riceLib.float) floor;

  palette =
    {
      version = "0.1.0";
    }
    // mapAttrs (variant: vpalette: {
      name = variant;
      emoji = " ";
      order = 0;
      dark = variant != "summer";
      colors = mapAttrs (
        colorn: colorv:
        let
          hex = "#${colorv}";
          rgba = hexToRgba hex;
          rgb = mapAttrs (_: floor) (removeAttrs rgba [ "a" ]);
          hsl = removeAttrs (rgbaToHsla rgba) [ "a" ];
        in
        {
          name = colorn;
          order = 0;
          inherit hex rgb hsl;
          accent = elem colorn [
            "red"
            "orange"
            "yellow"
            "green"
            "aqua"
            "skye"
            "blue"
            "purple"
            "pink"
          ];
        }
      ) vpalette;
      ansiColors =
        mapAttrs
          (ansiName: ansiColor: {
            name = ansiName;
            order = 0;
            normal =
              let
                color = evgLib.palette.${variant}.${ansiColor.normal.name};
                hex = "#${color}";
                rgba = hexToRgba hex;
                rgb = mapAttrs (_: floor) (removeAttrs rgba [ "a" ]);
                hsl = removeAttrs (rgbaToHsla rgba) [ "a" ];
              in
              {
                name = ansiName;
                inherit hex rgb hsl;
                inherit (ansiColor.normal) code;
              };
            bright =
              let
                color = evgLib.palette.${variant}.${ansiColor.normal.name};
                hex = "#${color}";
                rgba = hexToRgba hex;
                rgb = mapAttrs (_: floor) (removeAttrs rgba [ "a" ]);
                hsl = removeAttrs (rgbaToHsla rgba) [ "a" ];
              in
              {
                name = "Bright " + ansiName;
                inherit hex rgb hsl;
                inherit (ansiColor.bright) code;
              };
          })
          {
            Black = {
              normal = {
                name = "base";
                code = 0;
              };
              bright = {
                name = "surface0";
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
