# Not in nixpkgs; built from source because home-operations only ships
# binaries per-arch and this repo targets three systems.
{
  lib,
  # go.mod asks for go >= 1.27 and stable's default is still 1.26.
  buildGo127Module,
  fetchFromGitHub,
}:

buildGo127Module rec {
  pname = "flate";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "home-operations";
    repo = "flate";
    tag = "v${version}";
    hash = "sha256-sm22CX+3B7roECyNz5v9yLaqlTPZN7GWMcNthBn5IpY=";
  };

  vendorHash = "sha256-TyYkEU+UbN2B+rj0D3QxwEOGpwLKwHW9jZT/kitPYn8=";

  subPackages = [ "cmd/flate" ];

  # Same ldflags as upstream's goreleaser; main.version feeds --version.
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Inflate, validate, and diff Flux resources";
    homepage = "https://github.com/home-operations/flate";
    license = lib.licenses.agpl3Only;
    mainProgram = "flate";
  };
}
