# pass-fuzzel

A minimal [pass](https://www.passwordstore.org/) menu integration for [fuzzel](https://codeberg.org/dnkl/fuzzel) — the Wayland-native application launcher.

Lets you select, copy, or type any password from your password store via a fuzzel dmenu prompt. Spiritual successor to `passmenu` (which uses dmenu/rofi), rewritten for Wayland-first setups.

## Features

- Browse and select passwords from your `pass` store using fuzzel
- Copy selected password to clipboard (`pass show -c`)
- Type selected password directly into the focused field via `ydotool` (Wayland) or `xdotool` (X11)
- OTP support via --otp: generate a TOTP code and copy or type it
- Respects `$PASSWORD_STORE_DIR`
- Tiny — single self-contained shell script

## Dependencies

- [`pass`](https://www.passwordstore.org/)
- [`fuzzel`](https://codeberg.org/dnkl/fuzzel)
- For OTP: [`pass-otp`](https://github.com/tadfisher/pass-otp) extension
- For `--type` on Wayland: [`ydotool`](https://github.com/ReimuNotMoe/ydotool)
- For `--type` on X11: [`xdotool`](https://github.com/jordansissel/xdotool)

## Installation

Clone the repo and copy the script somewhere on your `$PATH`:

```bash
git clone https://github.com/yourname/pass-fuzzel.git
cd pass-fuzzel
chmod +x pass-fuzzel.sh
cp pass-fuzzel.sh ~/.local/bin/pass-fuzzel
```

## Usage

**Copy password to clipboard:**
```bash
pass-fuzzel
```

**Type password directly into the focused field:**
```bash
pass-fuzzel --type
```

**Generate OTP and copy to clipboard:**
```bash
pass-fuzzel --otp
```

**Generate OTP and type it into the focused field:**
```bash
pass-fuzzel --otp --type
```

The `--otp` and `--type` flags are independent and can be combined freely. The script auto-detects Wayland vs X11 when using `--type`.

## Keybinding example (Hyprland)

```ini
# Passwords
bind = SUPER, P, exec, pass-fuzzel
bind = SUPER SHIFT, P, exec, pass-fuzzel --type

# OTP codes
bind = SUPER, O, exec, pass-fuzzel --otp
bind = SUPER SHIFT, O, exec, pass-fuzzel --otp --type
```

## Setting up OTP entries

OTP secrets are stored inside your `pass` entries as an `otpauth://` URI. To add one:

```bash
pass otp insert github/myaccount
```

You'll be prompted to paste the `otpauth://totp/...` URI (usually shown as a QR code — scan it with a QR reader to get the raw URI).

## Notes on `--type` / ydotool

`ydotool` requires the `ydotoold` daemon to be running. You can start it as a systemd user service:

```bash
systemctl --user enable --now ydotool
```

Make sure your user has access to `/dev/uinput` (usually via the `input` group):

```bash
sudo usermod -aG input $USER
```

## License

MIT
