#!/usr/bin/env bash

function run() {
  local target_export="$TARGET.ovf"
  local target_export_dir="./artifacts/exports/$TARGET"
  local target_export_path="$target_export_dir/$target_export"

  local target_release="$TARGET.iso"
  local target_release_dir="./artifacts/releases"
  local target_release_path="$target_release_dir/$target_release"

  if [[ ! -f "$target_export_path" ]]; then
    mkdir -p "$target_export_dir"
    echo "Export file \"$target_export\" not found"
    echo 'Begin exporting process..'

    if [[ ! -f "$target_release_path" ]]; then
      mkdir -p "$target_release_dir"
      echo "Release file \"$target_release\" not found"
      echo 'Cannot generate any artifacts without a corresponding release!'
      exit 1
    fi

    echo 'Begin manual install process...'
    local vm="$TARGET-$(date '+%Y%m%d%H%M%S')"

    source ./scripts/vm/create.sh "$vm" "$target_release_path"
    source ./scripts/vm/start.sh "$vm"

    echo
    echo 'Please install the OS manually'
    echo "Waiting until \"$vm\" state is \"poweroff\"..."
    while true; do
      STATE=$(source ./scripts/vm/state.sh "$vm")

      if [[ "$STATE" = 'poweroff' ]]; then
        break
      fi

      sleep 3
    done

    echo "Detected \"$vm\" \"poweroff\" state"
    prompt

    IS_YES="$?"
    if [[ "$IS_YES" -ne 0 ]]; then
      echo "Export for \"$target_export\" canceled"
      source ./scripts/vm/destroy.sh "$vm"
      exit 1
    fi

    echo 'Rebooting VM...'
    local ssh_port=2223
    source ./scripts/vm/bridge.sh "$vm" "$ssh_port"
    source ./scripts/vm/start.sh "$vm"

    echo
    echo 'Please manually install an SSH server'
    echo "Waiting until \"$vm\" state is \"poweroff\"..."

    PROVISIONED=1
    while true; do
      if [[ "$PROVISIONED" -ne 0 ]]; then
        sed -i -E "/^\[127.0.0.1\]:$ssh_port.*$/d" ~/.ssh/known_hosts

        echo "Attempting SSH connection to \"$APP_USER@127.0.0.1\" on port \"$ssh_port\"..."
        if ssh -q -p "$ssh_port" -o StrictHostKeyChecking=no "$APP_USER"@127.0.0.1 APP_USER="$APP_USER" APP_PASSWORD="$APP_PASSWORD" bash -s < ./scripts/vm/provision.sh; then
          echo
          echo "Provisioning \"$vm\" finished"
          echo "Please poweroff \"$vm\""
          PROVISIONED=0
        fi
      fi

      STATE=$(source ./scripts/vm/state.sh "$vm")
      if [[ "$STATE" = 'poweroff' ]]; then
        break
      fi

      sleep 3
    done

    echo "Detected \"$vm\" \"poweroff\" state"
    if [[ "$PROVISIONED" -ne 0 ]]; then
      echo "Failed to provision \"$vm\""
      echo "Export for \"$target_export\" canceled"
      source ./scripts/vm/destroy.sh "$vm"
      exit 1
    fi

    prompt

    IS_YES="$?"
    if [[ "$IS_YES" -eq 0 ]]; then
      echo "Export for \"$target_export\" finished"
      source ./scripts/vm/export.sh "$vm" "$target_export_path"
    fi

    source ./scripts/vm/destroy.sh "$vm"
  fi
}

function prompt() {
  local result
  local answer

  while true; do
    echo 'Was the installation successful? (yes/no)'
    read answer

    if echo "$answer" | grep --quiet --ignore-case '^yes'; then
      result=0
      break
    fi

    if echo "$answer" | grep --quiet --ignore-case '^no'; then
      result=1
      break
    fi
  done

  return "$result"
}

run
