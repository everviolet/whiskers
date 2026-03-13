{ lib, rustPlatform }:
let
  toml = (lib.importTOML ./Cargo.toml).package;
in
rustPlatform.buildRustPackage {
  pname = "whiskers-evergarden";
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
    "evergarden-0.1.0" = "sha256-Rf+2sCqOpEcEKQOQtsATMRW4gdBXCU/6sq/8wFkfiDw=";
  };

  meta = {
    inherit (toml) homepage description;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ comfysage ];
    mainPackage = "whiskers";
  };
}
