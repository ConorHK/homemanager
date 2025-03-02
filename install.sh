#!/bin/sh
sudo nix \
	--extra-experimental-features 'flakes nix-command' \
	run github:nix-community/disko#disko-install -- \
	--flake "$1" \
	--write-efi-boot-entries \
	--disk main "$2"
