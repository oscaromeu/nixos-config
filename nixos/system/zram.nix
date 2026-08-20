# Compressed swap in RAM: the machine has no swap partition.
{ ... }:
{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };
}
