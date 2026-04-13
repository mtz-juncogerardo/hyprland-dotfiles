#!/usr/bin/env bash
set -euo pipefail

# Hyprland environment installer.
# Stow-style: creates symlinks from $HOME into this repo so edits stay tracked.

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$REPO_DIR/config"
HOME_SRC="$REPO_DIR/home"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

msg()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mXX\033[0m %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] && die "no ejecutar como root; usa tu usuario normal (se pedirá sudo cuando haga falta)."
command -v pacman >/dev/null || die "pacman no encontrado; este script es solo para Arch."

# ---------------------------------------------------------------------------
# 1. paru (AUR helper)
# ---------------------------------------------------------------------------
if ! command -v paru >/dev/null; then
    msg "Instalando paru..."
    sudo pacman -S --needed --noconfirm base-devel git
    tmp="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru.git "$tmp/paru"
    ( cd "$tmp/paru" && makepkg -si --noconfirm )
    rm -rf "$tmp"
fi

# ---------------------------------------------------------------------------
# 2. Paquetes oficiales + AUR
# ---------------------------------------------------------------------------
msg "Instalando paquetes oficiales..."
sudo pacman -S --needed --noconfirm - < "$REPO_DIR/packages/pacman.txt"

msg "Instalando paquetes AUR..."
paru -S --needed --noconfirm - < "$REPO_DIR/packages/aur.txt"

# ---------------------------------------------------------------------------
# 3. oh-my-zsh + plugins
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    msg "Instalando oh-my-zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
declare -A ZSH_PLUGINS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting"
    [zsh-completions]="https://github.com/zsh-users/zsh-completions"
)
for p in "${!ZSH_PLUGINS[@]}"; do
    dest="$ZSH_CUSTOM/plugins/$p"
    [[ -d "$dest" ]] || git clone --depth=1 "${ZSH_PLUGINS[$p]}" "$dest"
done

# ---------------------------------------------------------------------------
# 4. Symlinks (stow-style) con backup
# ---------------------------------------------------------------------------
link() {
    local src="$1" dst="$2"
    if [[ -L "$dst" ]]; then
        [[ "$(readlink -f "$dst")" == "$(readlink -f "$src")" ]] && return 0
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${dst#$HOME/}")"
        mv "$dst" "$BACKUP_DIR/${dst#$HOME/}"
        warn "backup: $dst -> $BACKUP_DIR/${dst#$HOME/}"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
}

msg "Creando symlinks en ~/.config..."
mkdir -p "$HOME/.config"
for entry in "$CONFIG_SRC"/*; do
    [[ -e "$entry" ]] || continue
    link "$entry" "$HOME/.config/$(basename "$entry")"
done

msg "Creando symlinks en ~ (zshrc, scripts, wallpapers)..."
link "$HOME_SRC/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.local/bin"
for bin in "$HOME_SRC/.local/bin"/*; do
    [[ -e "$bin" ]] || continue
    link "$bin" "$HOME/.local/bin/$(basename "$bin")"
    chmod +x "$bin"
done

mkdir -p "$HOME/wallpapers"
for w in "$HOME_SRC/wallpapers"/*; do
    [[ -e "$w" ]] || continue
    link "$w" "$HOME/wallpapers/$(basename "$w")"
done

# ---------------------------------------------------------------------------
# 5. Servicios y shell por defecto
# ---------------------------------------------------------------------------
msg "Habilitando servicios..."
sudo systemctl enable sddm.service || warn "no se pudo habilitar sddm"
sudo systemctl enable NetworkManager.service || true
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true

if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    msg "Cambiando shell por defecto a zsh..."
    chsh -s "$(command -v zsh)" || warn "chsh falló; cámbialo manualmente"
fi

msg "Listo. Reinicia para entrar a Hyprland vía SDDM."
[[ -d "$BACKUP_DIR" ]] && msg "Backup de configs previas: $BACKUP_DIR"
