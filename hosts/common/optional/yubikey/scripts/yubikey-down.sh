#!/usr/bin/env bash
set -euo pipefail

destination="$HOME/.ssh"

echo "ran" > "${destination}/yubikey-down.log"
#rm /etc/ssh/{id_yubikey,id_yubikey.pub}
rm ${destination}/.ssh/{id_yubikey,id_yubikey.pub}

echo "deleted" >> "${destination}/yubikey-down.log
