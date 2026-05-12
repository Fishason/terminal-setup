#!/usr/bin/env bash
# Terminal Setup 一键安装脚本
# 用法: bash install.sh
# 或:   curl -fsSL https://raw.githubusercontent.com/[USER]/terminal-setup/main/install.sh | bash

set -e

# ===== 配色输出 =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}==>${NC} $*"; }
success() { echo -e "${GREEN}✓${NC}   $*"; }
warn()    { echo -e "${YELLOW}!${NC}   $*"; }
error()   { echo -e "${RED}✗${NC}   $*" >&2; }

# ===== 检测环境 =====
info "Detecting environment..."

if [[ "$(uname)" != "Linux" ]]; then
    error "This script is for Linux only."
    exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
    error "This script requires apt (Debian/Ubuntu). For other distros, see README for manual steps."
    exit 1
fi

ARCH=$(uname -m)
if [[ "$ARCH" != "x86_64" ]]; then
    warn "Architecture $ARCH detected. Some binary downloads may fail. Continue at your own risk."
fi

# ===== 确定仓库根目录 =====
# 支持两种调用方式：本地 cd 到 repo 后 bash install.sh，或 curl ... | bash
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    USE_LOCAL=true
else
    # 通过管道执行，需要先 clone 仓库
    REPO_DIR="/tmp/terminal-setup-$$"
    USE_LOCAL=false
fi

if [[ "$USE_LOCAL" == "false" ]]; then
    info "Cloning repo to $REPO_DIR..."
    git clone --depth 1 https://github.com/Fishason/terminal-setup.git "$REPO_DIR"
fi

CONFIG_DIR="$REPO_DIR/config"

if [[ ! -d "$CONFIG_DIR" ]]; then
    error "Config directory not found: $CONFIG_DIR"
    exit 1
fi

# ===== 备份函数 =====
backup_if_exists() {
    local target="$1"
    if [[ -e "$target" ]]; then
        local backup="${target}.bak.$(date +%s)"
        info "Backing up $target → $backup"
        mv "$target" "$backup"
    fi
}

# ===== 1. 装系统包 =====
info "Installing apt packages (fish, tmux, git, curl, unzip, ripgrep, fd-find, glow)..."
sudo apt update -qq
sudo apt install -y \
    fish \
    tmux \
    git \
    curl \
    unzip \
    ripgrep \
    fd-find \
    glow

# 把 fd-find 别名为 fd
mkdir -p ~/.local/bin
ln -sf /usr/bin/fdfind ~/.local/bin/fd
success "System packages installed."

# ===== 2. 装 Yazi (musl) =====
info "Installing yazi (musl release)..."
YAZI_TAG=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
YAZI_URL="https://github.com/sxyazi/yazi/releases/download/${YAZI_TAG}/yazi-x86_64-unknown-linux-musl.zip"

curl -sL -o /tmp/yazi.zip "$YAZI_URL"
unzip -qo /tmp/yazi.zip -d /tmp/yazi-extracted
cp /tmp/yazi-extracted/yazi-x86_64-unknown-linux-musl/{yazi,ya} ~/.local/bin/
chmod +x ~/.local/bin/{yazi,ya}
rm -rf /tmp/yazi.zip /tmp/yazi-extracted
success "Yazi $YAZI_TAG installed at ~/.local/bin/yazi"

# ===== 3. 装 Neovim (AppImage) =====
info "Installing neovim (latest AppImage)..."
NVIM_TAG=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name"' | cut -d'"' -f4)
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_TAG}/nvim-linux-x86_64.appimage"

curl -sL -o ~/.local/bin/nvim "$NVIM_URL"
chmod +x ~/.local/bin/nvim
success "Neovim $NVIM_TAG installed at ~/.local/bin/nvim"

# ===== 4. 装 viu (字符画图片渲染) =====
info "Installing viu for image preview..."
if command -v cargo >/dev/null 2>&1; then
    cargo install --quiet viu
    success "viu installed via cargo."
else
    warn "cargo not found. Skipping viu install. Install Rust later via:"
    warn "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    warn "Then: cargo install viu"
fi

# ===== 5. 部署配置文件 =====
info "Deploying configuration files..."

# Fish
mkdir -p ~/.config/fish/functions
backup_if_exists ~/.config/fish/config.fish
cp "$CONFIG_DIR/fish/config.fish" ~/.config/fish/config.fish
backup_if_exists ~/.config/fish/functions/y.fish
cp "$CONFIG_DIR/fish/functions/y.fish" ~/.config/fish/functions/y.fish
success "Fish config deployed."

# Tmux
backup_if_exists ~/.tmux.conf
cp "$CONFIG_DIR/tmux/tmux.conf" ~/.tmux.conf
success "Tmux config deployed."

# Yazi
mkdir -p ~/.config/yazi
backup_if_exists ~/.config/yazi/yazi.toml
cp "$CONFIG_DIR/yazi/yazi.toml" ~/.config/yazi/yazi.toml
success "Yazi config deployed."

# Chafa wrapper (用 viu 替代真 chafa)
if command -v viu >/dev/null 2>&1; then
    backup_if_exists ~/.local/bin/chafa
    cp "$CONFIG_DIR/chafa-wrapper.sh" ~/.local/bin/chafa
    chmod +x ~/.local/bin/chafa
    success "Chafa wrapper (→ viu) deployed."
else
    warn "viu not installed, skipping chafa wrapper. Image preview in yazi may not work."
fi

# Nvim (LazyVim starter + 我的覆盖配置)
if [[ ! -d ~/.config/nvim ]]; then
    info "Cloning LazyVim starter..."
    git clone --quiet https://github.com/LazyVim/starter ~/.config/nvim
    rm -rf ~/.config/nvim/.git
fi
backup_if_exists ~/.config/nvim/lua/config/keymaps.lua
backup_if_exists ~/.config/nvim/lua/config/options.lua
backup_if_exists ~/.config/nvim/lua/config/lazy.lua
backup_if_exists ~/.config/nvim/lua/plugins
cp -r "$CONFIG_DIR/nvim/lua" ~/.config/nvim/
success "Nvim config deployed."

# ===== 6. 设 fish 为默认 shell（可选） =====
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
FISH_PATH=$(command -v fish)

if [[ "$CURRENT_SHELL" != "$FISH_PATH" ]]; then
    echo
    read -rp "Set fish as your default shell? (y/N) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        if ! grep -qx "$FISH_PATH" /etc/shells; then
            echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
        fi
        chsh -s "$FISH_PATH"
        success "Default shell set to fish. Will take effect on next login."
    fi
fi

# ===== 7. 收尾提示 =====
echo
success "All done!"
echo
info "Next steps:"
echo "  1. Start a new shell (or run: exec fish)"
echo "  2. First time running nvim will auto-install all LazyVim plugins (~1 minute)"
echo "  3. Check ${YELLOW}README.md${NC} for keybinding cheat sheet"
echo
info "Configuration backups saved with .bak.<timestamp> suffix."
