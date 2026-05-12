# Terminal Setup

> 一套适合 SSH 远程开发的终端配置 — **fish + tmux + yazi + nvim (LazyVim)**

完全在终端内写代码、看文件、管理会话，告别 VS Code Remote 的卡顿。配合 B 站投稿专栏使用。

## 配套文章

- 📺 详细介绍：[B 站专栏链接](https://www.bilibili.com/read/...)（待填）
- 🎮 3DS SSH 工具视频（缘起）：<https://www.bilibili.com/video/BV1BxRCBdEXz/>

## 一键安装

在 Ubuntu 服务器上执行：

```bash
curl -fsSL https://raw.githubusercontent.com/Fishason/terminal-setup/main/install.sh | bash
```

或者克隆后手动执行：

```bash
git clone https://github.com/Fishason/terminal-setup.git
cd terminal-setup
bash install.sh
```

脚本会：
- 用 `apt` 装 fish / tmux / ripgrep / fd-find / glow 等基础工具
- 从 GitHub releases 装 yazi 和 nvim（最新版二进制）
- 用 `cargo` 装 viu（图片字符画渲染）
- **备份你已有的配置**（`.bak` 后缀），再写入新的
- 把 fish 设为默认 shell（可选）

完成后重启 shell 或新开终端窗口即可。

## 仓库结构

```
terminal-setup/
├── README.md              # 你正在看的这个
├── bilibili-article.md    # B 站投稿原文
├── install.sh             # 一键安装脚本
├── SCREENSHOTS.md         # 截图指引（给作者本人用）
└── config/
    ├── tmux/tmux.conf
    ├── fish/
    │   ├── config.fish
    │   └── functions/y.fish
    ├── yazi/yazi.toml
    └── nvim/              # LazyVim 完整配置
        ├── init.lua
        └── lua/
            ├── config/    # 自定义 keymaps / options / lazy 启动
            └── plugins/   # 插件配置覆盖（lualine、snacks、yazi.nvim）
```

## 手动安装（一项一项装）

### 1. Fish

```bash
sudo apt install fish
chsh -s $(which fish)         # 设为默认 shell（可选）
cp config/fish/config.fish ~/.config/fish/
cp config/fish/functions/y.fish ~/.config/fish/functions/
```

### 2. Tmux

```bash
sudo apt install tmux
cp config/tmux/tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf   # 如已有 tmux 在跑
```

### 3. Yazi

```bash
# 下载 musl 版本（兼容老 GLIBC）
LATEST=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep tag_name | cut -d'"' -f4)
curl -L -o /tmp/yazi.zip "https://github.com/sxyazi/yazi/releases/download/${LATEST}/yazi-x86_64-unknown-linux-musl.zip"
unzip -o /tmp/yazi.zip -d /tmp/
cp /tmp/yazi-x86_64-unknown-linux-musl/{yazi,ya} ~/.local/bin/
chmod +x ~/.local/bin/{yazi,ya}

# 配置
mkdir -p ~/.config/yazi
cp config/yazi/yazi.toml ~/.config/yazi/
```

### 4. Neovim + LazyVim

```bash
# 装最新版 nvim AppImage
LATEST=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep tag_name | cut -d'"' -f4)
curl -L -o ~/.local/bin/nvim "https://github.com/neovim/neovim/releases/download/${LATEST}/nvim-linux-x86_64.appimage"
chmod +x ~/.local/bin/nvim

# 装 LazyVim starter + 我的覆盖配置
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
cp -r config/nvim/* ~/.config/nvim/

# 装周边工具
sudo apt install ripgrep fd-find
ln -sf /usr/bin/fdfind ~/.local/bin/fd

# 首次启动 nvim 自动安装所有插件
nvim
```

### 5. 图片预览支持（可选）

```bash
# 装 viu（图片转字符画）
cargo install viu

# 用 viu 包装替换 chafa（Ubuntu 22.04 自带的 chafa 太老，与 yazi 不兼容）
cp config/chafa-wrapper.sh ~/.local/bin/chafa
chmod +x ~/.local/bin/chafa
```

## 关键键位速查

### Fish
| 缩写 | 展开 |
|------|------|
| `c` | `claude` |
| `clauded` | `claude --dangerously-skip-permissions` |
| `e` | `exit` |
| `n` | `nvim` |
| `tls` `tnew` `tat` `tswitch` | tmux 系列 |

### Tmux（前缀键 = `Alt+c`）
| 按键 | 作用 |
|------|------|
| `Alt + 1~9` | 直接切窗口 |
| `Alt + a` | detach |
| `Alt + `` ` `` | 切 session |
| `Alt + ]` | 粘贴 |
| `Alt+c '` | 上下分屏 |
| `Alt+c 5` | 左右分屏 |
| `Alt+c h/j/k/l` | 调整分屏大小 |
| `Alt+c [` | 进入复制模式 |

### Yazi
| 按键 | 作用 |
|------|------|
| `hjkl` | 导航 |
| `Space` | 选中文件 |
| `y/x/p/d` | 复制/剪切/粘贴/删除 |
| `q` | 退出 |
| `Q` | 退出 + shell 跟随 cwd（配合 fish 函数 y） |

### Nvim (LazyVim)
| 按键 | 作用 |
|------|------|
| `Space + Space` | 模糊找文件 |
| `Space + /` | 全局搜内容 |
| `Space + e` / `,` | 文件树侧栏 |
| `Space + -` | 在浮窗里弹出 yazi |
| `gd` `gr` | LSP 跳定义/引用 |
| `jj` | 退出 insert 模式 |
| `ZZ` | 保存并退出 |

## 反馈

有问题、改进建议欢迎提 [Issue](../../issues) 或在 B 站评论区找我。

## License

CC-BY 4.0
