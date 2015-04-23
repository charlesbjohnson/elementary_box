#!/usr/bin/env bash

VM="$1"
EXPORT="$2"

VBoxManage export "$VM" --output "$EXPORT"
