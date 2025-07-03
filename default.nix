{ lib, rustPlatform }:
let
  toml = (lib.importTOML ./Cargo.toml).package;
in
rustPlatform.buildRustPackage {
  pname = "whiskers-evg";
  inherit (toml) version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.intersection (lib.fileset.fromSource (lib.sources.cleanSource ./.)) (
      lib.fileset.unions [
        ./Cargo.toml
        ./Cargo.lock
        ./src
      ]
    );
  };

  cargoLock.lockFile = ./Cargo.lock;

  cargoLock.outputHashes = {
    "evergarden-0.1.0" = "sha256-4vJ5kk66gu8inG13NzSqZYaPjXNu2r2tHMtNkQEoVO0=";
  };

  meta = {
    inherit (toml) homepage description;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ comfysage ];
    mainPackage = "whiskers-evg";
  };
}
