#!/usr/bin/env bash

shopt -s nullglob globstar

typeit=0
otpmode=0

for arg in "$@"; do
	case "$arg" in
		--type) typeit=1 ;;
		--otp)  otpmode=1 ;;
	esac
done

dmenu="fuzzel --dmenu"

if [[ $typeit -eq 1 ]]; then
	if [[ -n $WAYLAND_DISPLAY ]]; then
		type_cmd="ydotool type --file -"
	elif [[ -n $DISPLAY ]]; then
		type_cmd="xdotool type --clearmodifiers --file -"
	else
		echo "No display detected" >&2
		exit 1
	fi
fi

prefix=${PASSWORD_STORE_DIR:-~/.password-store}

password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | sort | $dmenu)

[[ -n $password ]] || exit

if [[ $otpmode -eq 1 ]]; then
	if ! command -v pass-otp &>/dev/null && ! pass otp --help &>/dev/null 2>&1; then
		echo "pass-otp extension not found. Install: https://github.com/tadfisher/pass-otp" >&2
		exit 1
	fi
	if [[ $typeit -eq 1 ]]; then
		pass otp "$password" \
			| { IFS= read -r code; printf %s "$code"; } \
			| $type_cmd
	else
		pass otp -c "$password" 2>/dev/null
	fi
else
	if [[ $typeit -eq 0 ]]; then
		pass show -c "$password" 2>/dev/null
	else
		pass show "$password" \
			| { IFS= read -r pass; printf %s "$pass"; } \
			| $type_cmd
	fi
fi

