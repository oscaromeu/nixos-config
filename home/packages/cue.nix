# Not in nixpkgs: unstable still ships cue 0.17 and the CUE trees this
# machine works on pin the 0.18 evaluator.
{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "cue";
  version = "0.18.0-rc.4";

  src = fetchFromGitHub {
    owner = "cue-lang";
    repo = "cue";
    tag = "v${version}";
    hash = "sha256-5bnrVCxfO0xqW/fXOtlpUPHgjJNaILu0VW8vtfnF+Q4=";
  };

  vendorHash = "sha256-5KTIGS0IrclWIQYjPSNW9Qd5gctPZPCd0htSRgIXBvc=";

  subPackages = [ "cmd/cue" ];

  # `cue version` prints "(devel)": the CLI reads its version from the Go
  # build info, which a source build does not carry. The line that matters
  # is "CUE language version v0.18.0".
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Validate and define text-based and dynamic configuration";
    homepage = "https://cuelang.org";
    license = lib.licenses.asl20;
    mainProgram = "cue";
  };
}
