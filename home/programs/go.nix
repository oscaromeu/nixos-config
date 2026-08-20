{ ... }:
{
  programs = {
    go = {
      enable = true;
      env = {
        GOBIN = ".go/bin";
        GOPATH = ".go";
      };
    };
  };
}
