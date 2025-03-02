#!/bin/sh
sudo nix \
	--extra-experimental-features 'flakes nix-command' \
	run github:nix-community/disko#disko-install -- \
	--flake "." \
	--write-efi-boot-entries \
	--disk main "$1"
