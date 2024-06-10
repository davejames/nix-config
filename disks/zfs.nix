{diskName, ...}:
{
  devices = { 
    disk = {
      main = {
        type = "disk";
        device = "/dev/${diskName}";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              start = "0";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              priority = 2;
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        # mode = "mirror";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          acltype = "posixacl";
          atime = "off";
          dedup = "on";
          devices = "off";
          canmount = "off";
          mountpoint = "none";
          xattr = "sa";
        };
        postCreateHook = ''
          zfs set keylocation=prompt zroot;
        '';
        datasets = {
          "ROOT" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "ROOT/empty" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = ''
              zfs list -t snapshot -H -o name | grep -E '^zroot/ROOT/empty$' || zfs snapshot zroot/ROOT/empty@start
            '';
          };
          swap = {
              type = "zfs_volume";
              content.type = "swap";
            size = "2G";
        };
        "ROOT/tmp" = {
            type = "zfs_fs";
            mountpoint = "/tmp";
        };
        "ROOT/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
        };

          "ROOT/nix/store" = {
            type = "zfs_fs";
            mountpoint = "/nix/store";
            options.dedup = "on";
        };

          "data" = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              "com.sun:auto-snapshot" = "true";
            };
          };
        "data/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
        };
          "data/home/djames" = {
            type = "zfs_fs";
            mountpoint = "/home/djames";
          };
          "data/home/djames/Downloads" = {
            type = "zfs_fs";
            mountpoint = "/home/djames/Downloads";
            options = {
                "com.sun:auto-snapshot" = "false";
            };
          };
          "data/home/djames/Development" = {
            type = "zfs_fs";
            options.mountpoint = "/home/djames/Development";
          };
        };
      };
    };
  };
  fileSystems."/".neededForBoot = true;
  fileSystems."/boot".neededForBoot = true;
}
