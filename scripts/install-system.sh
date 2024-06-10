#! /usr/bin/env nix-shell
#! nix-shell -i bash -p gawk git mkpasswd
# shellcheck shell=bash

# Inspired by:
# https://github.com/aaron-dodd/nix-config/blob/main/scripts/install-system.sh

set -euo pipefail

TARGET_HOST="${1:-}"
TARGET_USER="${2:-djames}"
TARGET_USER_PASSWORD="${3:-}"

if [ "$(id -u)" -eq 0 ]; then
  echo "ERROR! $(basename "$0") should be run as a regular user"
  exit 1
fi

if [ ! -d "$HOME/nix-config/.git" ]; then
  git clone https://github.com/davejames/nix-config.git "$HOME/nix-config"
fi

pushd "$HOME/nix-config"

if [[ -z "$TARGET_HOST" ]]; then
  echo "ERROR! $(basename "$0") requires a hostname as the first argument"
  echo "       The following hosts are available"
  find hosts -maxdepth 2 -type f -name 'default.nix' -exec dirname {} \; | cut -d'/' -f2 | grep -v -E "iso"
  exit 1
fi

if [[ -z "$TARGET_USER" ]]; then
  echo "ERROR! $(basename "$0") requires a username as the second argument"
  echo "       The following users are available"
  find hosts/_common/users/ -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | grep -v E "root|nixos"
  exit 1
fi

if [ ! -e "hosts/$TARGET_HOST/disks.nix" ]; then
  echo "ERROR! $(basename "$0") could not find the required hosts/$TARGET_HOST/disks.nix"
  exit 1
fi

# # Check if the machine we're provisioning expects a keyfile to unlock a disk.
# # If it does, generate a new key, and write to a known location.
# if grep -q "data.keyfile" "hosts/$TARGET_HOST/disks.nix"; then
#   echo -n "$(head -c32 /dev/random | base64)" > /tmp/data.keyfile
# fi
#
# PERSISTENCE_ENABLED="grep -qE \"amnesia\.enable = true|services/amnesia\.nix\" \"hosts/$TARGET_HOST/configuration.nix\""
#
# if eval "$PERSISTENCE_ENABLED"; then
#   if [[ -z "$TARGET_USER_PASSWORD" ]]; then
#     read -r -s -p "Enter the password for ${TARGET_USER}: " TARGET_USER_PASSWORD
#     echo
#
#     read -r -s -p "Confirm the password for ${TARGET_USER}: " CONFIRM_TARGET_USER_PASSWORD
#     echo
#
#     if [ "$TARGET_USER_PASSWORD" != "$CONFIRM_TARGET_USER_PASSWORD" ]; then
#       unset TARGET_USER_PASSWORD
#       unset CONFIRM_TARGET_USER_PASSWORD
#
#       echo "Passwords do not match. Please try again."
#       exit 1
#     fi
#
#     unset CONFIRM_TARGET_USER_PASSWORD
#   fi
#
#   TARGET_USER_HASH="$(mkpasswd -m sha-512 "$TARGET_USER_PASSWORD")"
#   unset TARGET_USER_PASSWORD
# fi

echo "WARNING! The disks in $TARGET_HOST are about to get wiped"
echo "         NixOS will be re-installed"
echo "         This is a destructive operation"
echo
read -p "Are you sure? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo true

  sudo nix run github:nix-community/disko \
    --extra-experimental-features "nix-command flakes" \
    --no-write-lock-file \
    -- \
    --mode disko \
    "hosts/$TARGET_HOST/disks.nix"

  sudo nix-collect-garbage -d && nix-collect-garbage -d

  sudo nixos-install \
    --no-root-password --flake ".#$TARGET_HOST"

  # # Rsync nix-config to the target install and set the remote origin to SSH.
  # mkdir --parents "/mnt/home/$TARGET_USER/Development/nix-config"
  # rsync -a --delete "$HOME/nix-config" "/mnt/home/$TARGET_USER/Development"
  # pushd "/mnt/home/$TARGET_USER/Development/nix-config"
  # git remote set-url origin git@github.com:aaron-dodd/nix-config.git
  # popd
  #
  # PERSISTENCE_BASE_DIRECTORY=$(grep -roh "hosts" -e 'amnesia\.baseDirectory = "/[^"]*"' | gawk -F'"' '{print $2}')
  # if eval "$PERSISTENCE_ENABLED"; then
  #   if [ -z "$PERSISTENCE_BASE_DIRECTORY" ]; then
  #     PERSISTENCE_BASE_DIRECTORY="/persist"
  #   fi
  #
  #   sudo mkdir --parents "/mnt/$PERSISTENCE_BASE_DIRECTORY/passwords"
  #   echo -n "$TARGET_USER_HASH" > "/tmp/$TARGET_USER.passwd"
  #
  #   unset TARGET_USER_HASH
  #
  #   sudo cp "/tmp/$TARGET_USER.passwd" "/mnt/$PERSISTENCE_BASE_DIRECTORY/passwords/$TARGET_USER"
  #   rm -rf "/tmp/$TARGET_USER.passwd"
  # fi
  #
  # # If there is a keyfile for a data disk, put copy it to the root partition and
  # # ensure the permissions are set appropriately.
  # if [[ -f "/tmp/data.keyfile" ]]; then
  #   if eval "$PERSISTENCE_ENABLED"; then
  #     mkdir --parents "/mnt/$PERSISTENCE_BASE_DIRECTORY/etc"
  #     sudo cp "/tmp/data.keyfile" "/mnt/$PERSISTENCE_BASE_DIRECTORY/etc/data.keyfile"
  #     sudo chmod 0400 "/mnt/$PERSISTENCE_BASE_DIRECTORY/etc/data.keyfile"
  #   else
  #     sudo cp "/tmp/data.keyfile" "/mnt/etc/data.keyfile"
  #     sudo chmod 0400 /mnt/etc/data.keyfile
  #   fi
  # fi
fi
