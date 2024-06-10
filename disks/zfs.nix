{diskName, ...}:
{
  disk = {
    "${diskName}" = {
      type = "disk";
      device = "/dev/${diskName}";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          zfs = {
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
          options.mountpoint = "/";
          postCreateHook = ''
            zfs list -t snapshot -H -o name | grep -E '^zroot/ROOT/empty$' || zfs snapshot zroot/ROOT/empty@start
          '';
        };
        swap = {
            type = "zfs_volume";
            content.type = "swap";
          size = "2G";
      };
      "ROOT/nix" = {
          type = "zfs_fs";
          options.mountpoint = "/nix";
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
          options.mountpoint = "/home";
      };
        "data/home/djames" = {
          type = "zfs_fs";
          options.mountpoint = "/home/djames";
        };
        "data/home/djames/Downloads" = {
          type = "zfs_fs";
          options = {
              mountpoint = "/home/djames/Downloads";
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
}
