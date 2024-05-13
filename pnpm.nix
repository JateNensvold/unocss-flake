{ pkgs }:
with pkgs;
stdenv.mkDerivation rec {
  pname = "pnpm";
  version = "v9.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-zA5NzYkF/eb58i7sjfOaTOOfZjvMbs86uT6LWUpUfZo=";
  };

  installPhase = ''
    runHook preInstall
    echo "install phase"
    echo "$out"
    ls -la
    mkdir -p "$out/bin"
    cp -r pnpm-linux-x64 "$out/bin/"

    runHook postInstall
  '';

  postInstall = ''
    echo "post install phase"
    echo "$out"
    ls -la
  '';
}
