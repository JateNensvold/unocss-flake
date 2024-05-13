{ lib, stdenv, fetchFromGitHub, stdenvNoCC, jq, moreutils, nodePackages, pnpm
, corepack, cacert, }:

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

    nativeBuildInputs = [ jq moreutils cacert ];

    # https://github.com/NixOS/nixpkgs/blob/de80f1eeac3152c5bbfb1f8891b6414d526bfc54/pkgs/by-name/po/pot/package.nix#L54
    installPhase = ''
      export HOME=$(mktemp -d)
      pnpm config set store-dir $out
      pnpm config set side-effects-cache false
      pnpm config set update-notifier false
      # use --ignore-script and --no-optional to avoid downloading binaries
      # use --frozen-lockfile to avoid checking git deps

      pnpm install --frozen-lockfile --no-optional --ignore-script --force
      # Remove timestamp and sort the json files
      rm -rf $out/v3/tmp
      for f in $(find $out -name "*.json"); do
        sed -i -E -e 's/"checkedAt":[0-9]+,//g' $f
        jq --sort-keys . $f | sponge $f
      done
    '';

    dontConfigure = true;
    dontFixup = true;
    dontBuild = true;
    outputHashMode = "recursive";
    outputHash = "sha256-5HxofXpDVhtL5S5wmsXyi2Uyq1z0EqQQve9aVw4ijSA=";
  };
  nativeBuildInputs = [ pnpm nodePackages.nodejs corepack ];

  preBuild = ''
    export HOME=$(mktemp -d)
    pnpm config set store-dir ${pnpm-deps}

    # chmod -R +w ../..
	pnpm --version
    pnpm install --offline --frozen-lockfile --no-optional --ignore-script
    patchShebangs node_modules/{*,.*}
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    pnpm deploy --filter=@unocss --offline --prod --no-optional $out

    mv $out/bin/nodeServer.js $out/bin/unocss

    runHook postInstall
  '';

  meta = {
    description = "Unocss Language";
    homepage = "https://github.com/unocss/unocss";
    license = lib.licenses.mit;
    mainProgram = "unocss";
    platforms = lib.platforms.unix;
  };
}
