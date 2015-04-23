#!/usr/bin/env bash

VM="$1"

VBoxManage showvminfo --machinereadable "$VM" \
  | grep 'VMState=' \
  | sed -E 's/^VMState="(.+)"$/\1/g'
