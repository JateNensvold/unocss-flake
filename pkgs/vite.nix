{ lib, stdenv, fetchFromGitHub, pnpm_9, nodejs, makeWrapper }:

stdenv.mkDerivation (finalAttrs: {
  pname = "vite";
  version = "5.4.7";

  src = fetchFromGitHub {
    owner = "vitejs";
    repo = "vite";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bWYdtmD+NK/RVHFlXjCNtrJCzd/fwXrUM9mNpXA5jsI=";
  };

  pnpmWorkspace = "vite";
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src pnpmWorkspace;
    hash = "sha256-+gR9Al7gyCQprJxmgG4ARVTLDUsJO4FhtVK6GNupYr0=";
  };

  nativeBuildInputs = [ nodejs pnpm_9.configHook makeWrapper ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter=vite build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/vite}
    cp -r {packages,node_modules} $out/lib/vite

    makeWrapper ${lib.getExe nodejs} $out/bin/vite \
      --inherit-argv0 \
      --add-flags $out/lib/vite/packages/vite/bin/vite.js

    runHook postInstall
  '';

  doInstallCheck = true;

  meta = with lib; {
    description = "Next generation frontend tooling. It's fast!";
    homepage = "https://github.com/vitejs/vite";
    license = licenses.mit;
    mainProgram = "vite";
    platforms = platforms.all;
  };
})
