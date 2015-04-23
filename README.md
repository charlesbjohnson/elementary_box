# elementary_box

When trying out a new distro I prefer to work against a vagrant box instead of
manually creating a VM from virtualbox.

Unfortunately, there is a manual process involved when converting an iso to a base
vagrant box. This repo aims at automating that process as much as possible.

The distro I am currently targetting is [elementaryos](http://elementary.io) but any other distro that
relies on the same install process (the iso just boots to an install wizard that most
of the ubuntu derivatives use, I believe) can follow the process I've outlined.

## Dependencies

### Softwares:

- [VirtualBox](https://www.virtualbox.org)
- [Vagrant](https://www.vagrantup.com)
- [Packer](https://www.packer.io)

### Services:

- AWS S3 for caching artifacts
- [Atlas/Vagrant](https://atlas.hashicorp.com) Cloud for hosting vagrant boxes

### Artifacts:

- An iso, placed in `artifacts/releases/<name>-<version>.iso` (ie. `artifacts/releases/elementaryos-0.3.iso`)

Be sure to setup the required environmental variables in `.env`. You can use `.env.default` as a template.
Same thing with `terraform/terraform.tfvars`. Ditto `terraform/terraform.tfvars.default`.

When you have everything setup:

- Run `scripts/execute.sh`
- Follow the prompts, which will include:
  - Installing the OS from the install wizard that opens in the virtualbox VM
  - Powering off the VM
  - Logging in as `$APP_USER` (probably `vagrant`)
  - Installing an ssh server on the VM with `sudo apt-get update; sudo apt-get install -y openssh-server`
  - Powering off the VM again
- The rest is automated
