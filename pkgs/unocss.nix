{ lib, stdenv, fetchFromGitHub, pnpm_9, nodejs, makeBinaryWrapper }:

stdenv.mkDerivation (finalAttrs: {
  pname = "unocss";
  version = "0.62.4";

  src = fetchFromGitHub {
    owner = "unocss";
    repo = "unocss";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bY51oSBAZKRcMdwT//PI6iHljSJ0OkTYCt93cHhbKXA=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-EqYXvcbVxeJ7IF3aKGlyV2vPY0j3O++bR5Wi3zkpssc=";
  };

  nativeBuildInputs = [ nodejs pnpm_9.configHook makeBinaryWrapper ];

  prePnpmInstall = ''
    pnpm config set dedupe-peer-dependents false
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build --filter=cli

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/unocss}

    cp -r {packages,node_modules} $out/lib/unocss

    makeWrapper ${lib.getExe nodejs} $out/bin/unocss \
      --inherit-argv0 \
      --add-flags $out/lib/unocss/node_modules/@unocss/cli/bin/unocss.mjs

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "The instant on-demand atomic CSS engine";
    homepage = "https://github.com/unocss/unocss";
    license = licenses.mit;
    mainProgram = "unocss";
    platforms = platforms.all;
  };
})
