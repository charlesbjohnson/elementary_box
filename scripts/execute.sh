#!/usr/bin/env bash

source ./.env

if [[ -z "$NAME" || -z "$VERSION" ]]; then
  echo "\"NAME\" and/or \"VERSION\" not given, cannot generate artifacts without both values!"
  exit 1
fi

vagrant up
vagrant provision

vagrant ssh --command "cd ~/app/terraform; terraform apply -refresh"

vagrant ssh --command "cd ~/app; source ./scripts/synchronize.sh"

TARGET="$NAME-$VERSION"
if [[ ! -f "./artifacts/boxes/$TARGET.box" ]]; then
  mkdir -p ./artifacts/boxes
  echo "Box file \"$TARGET.box\" not found"
  echo 'Begin boxing process..'

  TARGET="$TARGET" source ./scripts/generate.sh
  TARGET="$TARGET" packer build packer/generic-ovf-to-box.json
fi

vagrant ssh --command "cd ~/app; source ./scripts/synchronize.sh"
