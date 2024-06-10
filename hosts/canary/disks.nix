let
  diskConfig = import ../../disks/zfs.nix {diskName = "sda";};
in
  {
    inherit (diskConfig) disko;
}
