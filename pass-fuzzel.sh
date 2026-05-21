#!/usr/bin/env bash

shopt -s nullglob globstar

typeit=0
if [[ $1 == "--type" ]]; then
	typeit=1
	shift
fi

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

if [[ $typeit -eq 0 ]]; then
	pass show -c "$password" 2>/dev/null
else
	pass show "$password" \
		| { IFS= read -r pass; printf %s "$pass"; } \
		| $type_cmd
fi
