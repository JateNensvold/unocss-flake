{ buildFHSEnv, fetchurl, stdenv, nodejs_22 }:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";
  pname = "pnpm";
  version = "9.1.0";
  platform = {
    x86_64-linux = "linux-x64";
    x86_64-darwin = "macos-x64";
    aarch64-linux = "linux-arm64";
    aarch64-darwin = "macos-arm64";
  }.${system} or throwSystem;

  sha256 = {
    x86_64-linux = "0dhq19px4ms7pc1vm2ik4bvf9nnbpcca2w9j9lvx6c1zskmdk1j7";
    x86_64-darwin = "1cyp8g3z8m1c45g73kg2nprj0206940mid5jhs0lmcip125141wk";
    aarch64-linux = "0gcyinkmb074xq29cqs10bjzpvn37zxmdfhkdyb5yiwk6z23fk6y";
    aarch64-darwin = "04f5k7cmlbsi8b1cklkzmry4da57zwdn39khjjzg5ba8lbb7f2v3";
  }.${system} or throwSystem;
  pnpm-pkg = stdenv.mkDerivation rec {
    inherit version;
    pname = "pnpm-pkg";
    src = fetchurl {
      url =
        "https://github.com/pnpm/pnpm/releases/download/v${version}/pnpm-${platform}";
      sha256 = sha256;
    };
    unpackPhase = ":";
    dontStrip = true;
    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share
      cp -r $src $out/bin/pnpm
      chmod a+x $out/bin/pnpm

      runHook postInstall
    '';
  };
in buildFHSEnv {
  inherit pname version;
  targetPkgs = pkgs: [ pnpm-pkg nodejs_22 ];

  runScript = "pnpm";
}
