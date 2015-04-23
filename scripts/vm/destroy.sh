#!/usr/bin/env bash

VM="$1"

VBoxManage storageattach "$VM" --storagectl IDE --port 0 --device 0 --medium "none"
VBoxManage unregistervm "$VM" --delete
