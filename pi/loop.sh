#!/bin/bash

DRIVE_MOUNTPOINT="/mnt/drive"

# Utils: adapted from https://github.com/cimryan/teslausb/blob/master/run/archiveloop

function retry () {
  local attempts=0
  while [ true ]
  do
    if eval "$@"
    then
      true
      return
    fi
    if [ "$attempts" -ge 10 ]
    then
      echo "attempts exhausted"
      false
      return
    fi
    /bin/sleep 1
    attempts=$((attempts + 1))
    log "retry #$attempts"
  done
  false
  return
}

function mount_mountpoint() {
  local mount_point="$1"
  echo "-> Mounting $mount_point"

  local mounted=true
  mount "$mount_point" || mounted=false
  if [ "$mounted" = true ]
  then
    echo "mounted $mount_point."
    true
    return
  else
    echo "failed to mount $mount_point."
    false
    return
  fi
}

# PiPS5

function ps5_mount() {
  echo "-> Mounting the drive to PS5"
  modprobe g_mass_storage
}

function ps5_unmount() {
  echo "-> Unmounting the drive from PS5"
  modprobe -r g_mass_storage
}

function pi_mount() {
  echo "-> Mounting the drive"
  retry mount_mountpoint $DRIVE_MOUNTPOINT

  echo "-> Running fsck"
  /sbin/fsck -y $DRIVE_MOUNTPOINT
}

function pi_unmount() {
  echo "-> Unmounting the drive"
  retry umount $DRIVE_MOUNTPOINT
}

function wait_for_request_to_access() {
  echo "-> Wait for request to access (/tmp/PIPS5_ACCESS_LOCK)"
  while [ true ]
  do
    if [[ -f /tmp/PIPS5_ACCESS_LOCK ]]
    then
      return
    fi
    sleep 1
  done
}

function wait_for_finish_access() {
  echo "-> Wait for access request ended (/tmp/PIPS5_ACCESS_LOCK)"
  while [ true ]
  do
    if [[ ! -f /tmp/PIPS5_ACCESS_LOCK ]]
    then
      return
    fi
    sleep 1
  done
}

while [ true ]
do
  ps5_mount

  wait_for_request_to_access

  ps5_unmount

  pi_mount
  
  wait_for_finish_access
done