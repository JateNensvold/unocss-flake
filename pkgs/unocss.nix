{ lib, stdenv, fetchFromGitHub, stdenvNoCC, jq, moreutils, pnpm, cacert
, nodejs_22 }:

stdenv.mkDerivation rec {
  pname = "unocss";
  version = "v0.60.0";

  src = fetchFromGitHub {
    owner = "unocss";
    repo = "unocss";
    rev = "${version}";
    hash = "sha256-TE7qCcBfSrk+D1yAqW0MXzx4WKs1OLaNtDzDhFR+o2s=";
  };

  pnpm-deps = stdenvNoCC.mkDerivation {
    pname = "${pname}-pnpm-deps";
    inherit src version;

    nativeBuildInputs = [ jq moreutils cacert pnpm ];

    # https://github.com/NixOS/nixpkgs/blob/de80f1eeac3152c5bbfb1f8891b6414d526bfc54/pkgs/by-name/po/pot/package.nix#L54
    installPhase = ''
      export HOME=$(mktemp -d)

      pnpm config set store-dir $out
      pnpm install --frozen-lockfile --ignore-script

      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
  };
  nativeBuildInputs = [ nodejs_22 pnpm];

  preBuild = ''
    export HOME=$(mktemp -d)
    export STORE_PATH=$(mktemp -d)

    cp -Tr "${pnpm-deps}" "$STORE_PATH"
    chmod -R +w "$STORE_PATH"

    pnpm config set store-dir "$STORE_PATH"
    pnpm list
    pnpm install --offline --frozen-lockfile --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  # postBuild = ''
  #   pnpm --version
  #   pnpm list
  # '';

  installPhase = ''
    # export HOME=$(mktemp -d)

    # pnpm config set store-dir ${pnpm-deps}/share
    # pnpm install --offline --frozen-lockfile --ignore-script --no-optional

    # mkdir -p $out/bin
    # pnpm deploy --filter=@unocss --offline --prod --no-optional $out
  '';

  # installPhase = ''
  #   runHook preInstall
  #
  #   mkdir -p ${pnpm-deps}/v3
  #   mv $out/bin/nodeServer.js $out/bin/unocss
  #
  #   runHook postInstall
  # '';

  meta = {
    description = "Unocss Language";
    homepage = "https://github.com/unocss/unocss";
    license = lib.licenses.mit;
    mainProgram = "unocss";
    platforms = lib.platforms.unix;
  };
}
