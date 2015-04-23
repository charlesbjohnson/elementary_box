#!/usr/bin/env bash

VM="$1"
PORT="$2"

VBoxManage controlvm "$VM" nic1 bridged eth0
VBoxManage modifyvm "$VM" --natpf1 "ssh,tcp,,$PORT,,22"
