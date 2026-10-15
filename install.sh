#!/usr/bin/env bash
# ==============================================================================
# ARCHYDRE HYPRLAND DOTFILES INSTALLER
# Automated setup for Arch Linux & Arch-based distributions
# GitHub: https://github.com/archydre/dotfiles
# ==============================================================================

set -euo pipefail

# Colors
C_RESET="\033[0m"
C_RED="\033[1;31m"
C_GREEN="\033[1;32m"
C_YELLOW="\033[1;33m"
C_BLUE="\033[1;34m"
C_PURPLE="\033[1;35m"
C_CYAN="\033[1;36m"

info()    { echo -e "${C_CYAN}[INFO]${C_RESET} $*"; }
success() { echo -e "${C_GREEN}[OK]${C_RESET} $*"; }
warn()    { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
error()   { echo -e "${C_RED}[ERROR]${C_RESET} $*" >&2; }

# Print Banner
clear 2>/dev/null || true
cat << "EOF"
  █████  ██████   ██████ ██   ██ ██    ██ ██████  ██████  ███████ 
 ██   ██ ██   ██ ██      ██   ██  ██  ██  ██   ██ ██   ██ ██      
 ███████ ██████  ██      ███████   ████   ██   ██ ██████  █████   
 ██   ██ ██   ██ ██      ██   ██    ██    ██   ██ ██   ██ ██      
 ██   ██ ██   ██  ██████ ██   ██    ██    ██████  ██   ██ ███████ 
                 Dynamic Hyprland Desktop Setup
EOF
echo -e "${C_PURPLE}------------------------------------------------------------${C_RESET}"
echo -e "${C_PURPLE}   GitHub: https://github.com/archydre/dotfiles${C_RESET}"
echo -e "${C_PURPLE}------------------------------------------------------------${C_RESET}\n"

# Verify Arch Linux
if [ ! -f /etc/arch-release ]; then
    warn "Este script foi projetado especificamente para Arch Linux ou derivados."
    read -rp "Deseja continuar mesmo assim? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        info "Instalação cancelada."
        exit 0
    fi
fi

# Detect repository directory
REPO_URL="https://github.com/archydre/dotfiles.git"
CLONE_DIR="$HOME/dotfiles"

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
SCRIPT_DIR=""
if [ -f "$SCRIPT_SOURCE" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_SOURCE")" 2>/dev/null && pwd)"
fi

if [ -z "$SCRIPT_DIR" ] || [ ! -d "$SCRIPT_DIR/.config" ]; then
    info "Execução remota detectada. Clonando repositório para $CLONE_DIR..."
    if [ -d "$CLONE_DIR/.git" ]; then
        info "Atualizando repositório existente..."
        git -C "$CLONE_DIR" pull
    else
        git clone "$REPO_URL" "$CLONE_DIR"
    fi
    SCRIPT_DIR="$CLONE_DIR"
fi

# Detect AUR Helper (yay or paru)
detect_aur_helper() {
    if command -v yay &>/dev/null; then
        echo "yay"
    elif command -v paru &>/dev/null; then
        echo "paru"
    else
        echo ""
    fi
}

AUR_HELPER="$(detect_aur_helper)"

if [ -z "$AUR_HELPER" ]; then
    info "Nenhum gerenciador AUR (yay/paru) detectado."
    info "Instalando pré-requisitos e compilando 'yay-bin'..."
    sudo pacman -S --needed --noconfirm base-devel git
    TMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/yay-bin.git "$TMP_DIR/yay-bin"
    (cd "$TMP_DIR/yay-bin" && makepkg -si --noconfirm)
    rm -rf "$TMP_DIR"
    AUR_HELPER="yay"
    success "yay instalado com sucesso!"
fi

# Packages List
PACMAN_PACKAGES=(
    hyprland
    waybar
    wofi
    alacritty
    dunst
    hyprpaper
    hyprlock
    grim
    slurp
    swappy
    wl-clipboard
    cliphist
    jq
    wireplumber
    playerctl
    pavucontrol
    ttf-jetbrains-mono-nerd
    noto-fonts-emoji
    nautilus
    hyprpolkitagent
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    qt5-wayland
    qt6-wayland
)

AUR_PACKAGES=(
    bibata-cursor-theme-bin
)

info "Verificando dependências oficiais..."
MISSING_PACMAN=()
for pkg in "${PACMAN_PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null; then
        MISSING_PACMAN+=("$pkg")
    fi
done

if [ ${#MISSING_PACMAN[@]} -gt 0 ]; then
    info "Instalando pacotes oficiais: ${MISSING_PACMAN[*]}..."
    sudo pacman -S --needed --noconfirm "${MISSING_PACMAN[@]}"
    success "Pacotes oficiais instalados!"
else
    success "Todos os pacotes oficiais já estão instalados."
fi

info "Verificando dependências AUR..."
MISSING_AUR=()
for pkg in "${AUR_PACKAGES[@]}"; do
    if ! pacman -Qi "$pkg" &>/dev/null && ! pacman -Qi "${pkg%-bin}" &>/dev/null; then
        MISSING_AUR+=("$pkg")
    fi
done

if [ ${#MISSING_AUR[@]} -gt 0 ]; then
    info "Instalando pacotes AUR: ${MISSING_AUR[*]} via $AUR_HELPER..."
    "$AUR_HELPER" -S --needed --noconfirm "${MISSING_AUR[@]}"
    success "Pacotes AUR instalados!"
else
    success "Todos os pacotes AUR já estão instalados."
fi

# Backup existing configs
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_TARGETS=(hypr waybar alacritty wofi dunst swappy)
BACKUP_PERFORMED=false

for target in "${CONFIG_TARGETS[@]}"; do
    if [ -d "$HOME/.config/$target" ] || [ -f "$HOME/.config/$target" ]; then
        if [ "$BACKUP_PERFORMED" = false ]; then
            info "Criando backup das configurações atuais em $BACKUP_DIR..."
            mkdir -p "$BACKUP_DIR"
            BACKUP_PERFORMED=true
        fi
        cp -r "$HOME/.config/$target" "$BACKUP_DIR/"
    fi
done

if [ "$BACKUP_PERFORMED" = true ]; then
    success "Backup concluído com segurança."
fi

# Create target directories
info "Criando estrutura de diretórios do usuário..."
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/backgrounds"
mkdir -p "$HOME/Pictures/Screenshots"

# Copy configurations
info "Copiando arquivos de configuração para ~/.config..."
for dir in "$SCRIPT_DIR"/.config/*; do
    name="$(basename "$dir")"
    mkdir -p "$HOME/.config/$name"
    cp -r "$dir"/* "$HOME/.config/$name/"
done

# Copy scripts
info "Copiando scripts utilitários para ~/.local/bin..."
cp -r "$SCRIPT_DIR"/.local/bin/* "$HOME/.local/bin/"
chmod +x "$HOME/.local/bin"/hypr-* 2>/dev/null || true

# Copy wallpapers
info "Copiando papéis de parede para ~/.local/share/backgrounds..."
cp -r "$SCRIPT_DIR"/wallpapers/* "$HOME/.local/share/backgrounds/"

# Dynamic Path / Placeholder Replacement
info "Configurando caminhos dinâmicos para $HOME..."
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/hypr/hyprpaper.conf" 2>/dev/null || true
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/hypr/hyprlock.conf" 2>/dev/null || true
sed -i "s|__HOME__|$HOME|g" "$HOME/.config/swappy/config" 2>/dev/null || true

# Detect active monitors for hyprpaper
MONITORS=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].name' 2>/dev/null || true)
WALLPAPER_FILE="$HOME/.local/share/backgrounds/2026-08-15-23-15-28-kwami-fattah-al-sissi-fCvhuIf_wBA-unsplash.jpg"
if [ -n "$MONITORS" ] && [ -f "$WALLPAPER_FILE" ]; then
    info "Configurando monitores ativos no hyprpaper..."
    {
        echo "preload = $WALLPAPER_FILE"
        echo ""
        for mon in $MONITORS; do
            echo "wallpaper {"
            echo "    monitor = $mon"
            echo "    path = $WALLPAPER_FILE"
            echo "}"
        done
        echo ""
        echo "splash = false"
    } > "$HOME/.config/hypr/hyprpaper.conf"
fi

# Ensure ~/.local/bin is in PATH for bash & zsh
info "Garantindo ~/.local/bin na variável PATH..."
add_path_if_missing() {
    local rc_file="$1"
    if [ -f "$rc_file" ]; then
        if ! grep -q 'export PATH=.*$HOME/\.local/bin' "$rc_file" && ! grep -q 'PATH=.*~/\.local/bin' "$rc_file"; then
            echo -e '\n# Adicionado pelo instalador de dotfiles archydre' >> "$rc_file"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$rc_file"
            info "PATH adicionado em $rc_file"
        fi
    fi
}
add_path_if_missing "$HOME/.bashrc"
add_path_if_missing "$HOME/.zshrc"

# Enable user services
if command -v systemctl &>/dev/null; then
    info "Habilitando serviço polkit do Hyprland..."
    systemctl --user enable hyprpolkitagent.service 2>/dev/null || true
fi

# Finished!
echo ""
echo -e "${C_GREEN}============================================================${C_RESET}"
echo -e "${C_GREEN}  🎉 INSTALAÇÃO CONCLUÍDA COM SUCESSO! 🎉${C_RESET}"
echo -e "${C_GREEN}============================================================${C_RESET}"
echo ""
echo -e "${C_PURPLE}Principais recursos ativos:${C_RESET}"
echo -e "  • ${C_CYAN}Navegação dinâmica de Workspaces estilo GNOME${C_RESET} (sem bounce/pulos visuais)"
echo -e "  • ${C_CYAN}Super + Scroll do mouse${C_RESET} (Baixo = Próximo / Cima = Anterior)"
echo -e "  • ${C_CYAN}Compactação automática de workspaces vazios${C_RESET}"
echo -e "  • ${C_CYAN}Waybar Catppuccin Mocha com suporte a scroll e interatividade${C_RESET}"
echo -e "  • ${C_CYAN}Seletor visual de Wallpapers (Super + Shift + W)${C_RESET}"
echo -e "  • ${C_CYAN}Histórico de Clipboard (Super + V)${C_RESET}"
echo -e "  • ${C_CYAN}Menu Power / Desligamento elegante (Super + Shift + Q)${C_RESET}"
echo -e "  • ${C_CYAN}Captura de tela com Swappy e Loupe (Print / Super + Shift + S)${C_RESET}"
echo ""
echo -e "${C_YELLOW}Como iniciar:${C_RESET}"
echo -e "  Se estiver no terminal (TTY), execute: ${C_CYAN}Hyprland${C_RESET}"
echo -e "  Ou selecione a sessão 'Hyprland' no seu gerenciador de login (SDDM/GDM)."
echo ""
