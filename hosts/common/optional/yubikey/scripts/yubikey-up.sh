#!/usr/bin/env bash
set -euo pipefail

destination="$HOME/.ssh"

serial=$(ykman list | awk '{print $NF}')
# If it got unplugged before we ran, just don't bother
if [ -z "$serial" ]; then
    # FIXME: Warn probably
    exit 0
fi

# TODO: Add 5cNFC
# TODO: Fix the symlinks
declare -A serials=([nano5c]="23183421" [dummy]="12345678")

key_name=""
for key in "${!serials[@]}"; do
    if [[ "$serial" == "${serials[$key]}" ]]; then
        key_name="$key"
    fi
done

if [ -z "$key_name" ]; then
    echo WARNING: Unidentified yubikey with serial "${serial}" . Won\'t link an SSH key.
    exit 0
fi

echo "Creating links to /etc/ssh/id_${key_name}"
# ln -sf "/etc/ssh/id_${key_name}" /etc/ssh/id_yubikey
# ln -sf "/etc/ssh/id_${key_name}.pub" /etc/ssh/id_yubikey.pub
ln -sf "${destination}/id_${key_name}" "${destination}/id_yubikey"
ln -sf "${destination}/id_${key_name}.pub" "${destination}/id_yubikey.pub"
