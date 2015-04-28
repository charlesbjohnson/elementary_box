#!/usr/bin/env bash

VM="$1"
ISO="$2"

VBoxManage createhd --filename "$VM.vmdk" --size 40960 --format VMDK
VBoxManage createvm --name "$VM" --register --ostype Ubuntu_64
VBoxManage storagectl "$VM" --name IDE --add ide
VBoxManage storageattach "$VM" --storagectl IDE --type dvddrive --port 0 --device 0 --medium "$ISO"
VBoxManage storagectl "$VM" --name SATA --add sata
VBoxManage storageattach "$VM" --storagectl SATA --type hdd --port 0 --device 0 --medium "$VM.vmdk"
VBoxManage modifyvm "$VM" --memory 2048 --cpus 2
