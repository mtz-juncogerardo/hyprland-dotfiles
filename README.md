# Hyprland dotfiles

Entorno Hyprland completo (Arch Linux): configs, paquetes, temas, scripts.

## Uso

```bash
git clone https://github.com/mtz-juncogerardo/hyprland-dotfiles.git ~/repos/hyprland-dotfiles
cd ~/repos/hyprland-dotfiles
./install.sh
```

Requiere Arch Linux con `pacman` y usuario con `sudo`. **No** ejecutar como root.

El script:

1. Instala `paru` si falta.
2. Instala paquetes oficiales (`packages/pacman.txt`) y AUR (`packages/aur.txt`).
3. Instala `oh-my-zsh` + plugins (autosuggestions, syntax-highlighting, completions).
4. Crea **symlinks** desde `~/.config`, `~/.zshrc`, `~/.local/bin` y `~/wallpapers` hacia este repo (stow-style). Las configs existentes se mueven a `~/.dotfiles-backup/<timestamp>/`.
5. Habilita SDDM, NetworkManager, PipeWire.
6. Cambia la shell por defecto a zsh.

## Contenido

- `config/` — espejo de `~/.config` (hypr, waybar, kitty, rofi, wofi, dunst, nvim, themes, gtk, qt, etc.)
- `home/.zshrc` — zsh config
- `home/.local/bin/` — scripts (brightness, powermenu, screenshot, volume, theme-apply…)
- `home/wallpapers/main.jpg` — wallpaper actual
- `packages/pacman.txt`, `packages/aur.txt` — listas de paquetes

## Excluido a propósito

Paquetes específicos de hardware/bootloader: `linux-zen`, `linux-firmware`, `nvidia-*`, `intel-ucode`, `limine`, `efibootmgr`, `dkms`, `btrfs-progs`, `snapper`, `zram-generator`, `ly`. Instálalos manualmente según tu hardware.

## Editar configs

Los archivos reales viven en el repo; `~/.config/*` son symlinks. Edita donde sea y `git commit` aquí.
