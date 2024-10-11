{ lib, stdenv, fetchFromGitHub, pnpm_9, nodejs, makeBinaryWrapper }:

stdenv.mkDerivation (finalAttrs: {
  pname = "unocss-language-server";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "xna00";
    repo = "unocss-language-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WRCvpBpLLjpLucpTk2N+6RILsx7a6F143D4XBDU0wKk=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-w46qG+7B7sYSzJXHNslrUxzTAg0mNEXVEZP1vSEEohA=";
  };

  nativeBuildInputs = [ nodejs pnpm_9.configHook makeBinaryWrapper ];

  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependents false
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/unocss-language-server}

    cp -r {bin,out,node_modules} $out/lib/unocss-language-server

    cp package.json $out/
    makeWrapper ${lib.getExe nodejs} $out/bin/unocss-language-server \
      --inherit-argv0 \
      --add-flags $out/lib/unocss-language-server/bin/index.js

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Language server for unocss";
    homepage = "https://github.com/xna00/unocss-language-server";
    license = licenses.mit;
    mainProgram = "unocss-language-server";
    platforms = platforms.all;
  };
})
