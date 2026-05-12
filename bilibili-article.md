# 我的终端工具配置分享

> 之前发了一个 3DS + SSH 的视频，评论区有人对我的终端配置感兴趣，专门写一篇专栏说明。
> 配置文件和一键安装脚本放在文末的 GitHub 仓库里。

---

## 1. Fish Shell

### 1.1 是什么

fish 是一个交互式 shell，可以理解为 bash 或 zsh 的替代品。和它们相比，fish 不需要装额外插件就能用上：

- 边输入边语法高亮，错误命令会变红
- 历史补全：输入命令前几个字符，灰色提示之前用过的完整命令，按右方向键采纳
- 参数补全：tab 键会显示命令的参数列表和说明

![fish 历史补全](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/01-fish-completion.png)

### 1.2 我设置的缩写

fish 有 abbreviation（缩写）功能：输入缩写后按空格或回车，会自动展开成完整命令，历史里存的也是展开后的完整版。

我用得比较频繁的几个：

| 缩写 | 展开 | 用途 |
|------|------|------|
| `clauded` | `claude --dangerously-skip-permissions` | 启动 Claude Code 并跳过权限提示 |
| `c` | `claude` | 启动 Claude Code |
| `e` | `exit` | 退出当前 shell |
| `n` | `nvim` | 启动 Neovim |
| `y` | 启动 yazi 并把退出时所在目录同步给 shell | 文件管理器 |
| `tls` | `tmux ls` | 列出 tmux session |
| `tnew` | `tmux new` | 新建 session |
| `tat` | `tmux at -t` | 接入指定 session |
| `tswitch` | `tmux switch -t` | 切换到指定 session |
| `manc` | `man -L zh_CN` | 中文 man 手册 |

`y` 不是简单的缩写，是一个 fish 函数。yazi 默认退出后 shell 还停留在原来的目录，这个函数让 shell 跟随到 yazi 退出时所在的目录。

---

## 2. Tmux

### 2.1 是什么

tmux 是终端多路复用工具。它解决三个问题：

- 在一个终端窗口里管理多个会话和面板
- SSH 断开后服务器上的程序继续运行，重连后接着用
- 跨设备访问同一个工作状态（手机、电脑连同一个 tmux session）

社区里另一个常被提到的替代是 Zellij。两者主要差别：Zellij 默认界面更友好（屏幕底部一直显示快捷键提示），学习成本低，但占用屏幕空间也更多。tmux 默认只有一行状态栏，屏幕利用率高。

我用 VS Code Remote 或者在手机上连服务器的时候本来就没多少行高，所以选择了占用更小的 tmux，代价是默认快捷键对手指不友好，需要自己调整。

![tmux 状态栏](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/02-tmux-status.png)

### 2.2 我的调整

**前缀键改成 `Alt + c`**

tmux 默认前缀是 `Ctrl + b`，按起来手指要扭一下。改成 `Alt + c`（Mac 上是 `Option + c`）后左手就能按完。

**不用前缀的快捷键**

| 按键 | 作用 |
|------|------|
| `Alt + 1` ~ `Alt + 9` | 直接切到对应编号的窗口 |
| `Alt + a` | detach（退出但保留会话） |
| `Alt + `` ` `` | 弹出 session/窗口选择列表 |
| `Alt + ]` | 粘贴最近复制的内容 |

![tmux 多窗口切换](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/03-tmux-window-switch.png)

**分屏**

用前缀 + `'` 上下分屏、前缀 + `5` 左右分屏。不用 tmux 默认的 `"` 和 `%`（要按 Shift）。

分屏后用前缀 + `h/j/k/l`（vim 风格）调整分隔线位置，可以连按。

**复制**

切到 vi 模式后，复制流程：

1. 鼠标向上滚动，自动进入复制模式
2. 方向键移动到起点，按空格开始选择
3. 移动到终点，按回车复制
4. 在任意位置按 `Alt + ]` 粘贴

也可以鼠标直接拖选，松开自动复制。

另外做了一个改动：滚轮往下滚到底时自动退出复制模式。tmux 默认进了复制模式后只能按 `q` 或 `Esc` 退出，挺烦的。

![tmux 复制模式](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/04-tmux-copy-mode.png)

### 2.3 配合 fish 缩写

```
tnew       # tmux new
tat 0      # tmux at -t 0
tls        # tmux ls
tswitch 1  # tmux switch -t 1
```

---

## 3. Yazi

### 3.1 是什么

yazi 是用 Rust 写的终端文件管理器。在没有图形界面的服务器上，它充当 Finder/资源管理器的角色。

主要功能：

- 三列布局：父目录 / 当前目录 / 文件预览
- vim 风格按键（`hjkl` 导航）
- 文本、代码、图片、PDF、视频都能在第三列预览
- 复制、剪切、粘贴、删除、新建、重命名等文件操作
- 模糊搜索文件名和文件内容

![yazi 三列布局](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/05-yazi-three-columns.png)

![yazi 文件预览](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/06-yazi-preview.png)

### 3.2 我的调整

- 列宽改成 `[2, 2, 4]`，把更多空间给预览区
- 图片预览：服务器上 Ubuntu 22.04 自带的 chafa 版本太老与新版 yazi 不兼容，所以用一个包装脚本把 chafa 调用转给 viu，实际效果一样
- 图片按回车全屏显示，按任意键返回
- 文本文件按回车用 nvim 打开
- 配合 fish 的 `y` 函数，按 yazi 里的大写 `Q` 退出时 shell 会 cd 到 yazi 当前目录

---

## 4. Neovim（LazyVim 发行版）

### 4.1 是什么

Neovim 是 vim 的分叉版，向后兼容 vim 的所有键位和命令，但底层换成 Lua 后多了一些现代功能：

- 内置 LSP，相当于 VS Code 的智能感知（跳定义、查引用、自动补全）
- Treesitter，基于语法树的高亮，比正则高亮准确
- 异步执行，插件不会卡住编辑

裸 nvim 配置起来比较折磨。我用 LazyVim，一个开箱即用的发行版。

![LazyVim 主界面](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/07-lazyvim-dashboard.png)

`ZZ` 是 vim 的传统快捷键，在 Normal 模式按两下大写 Z，相当于 `:wq`。

### 4.2 我的自定义

- 逗号 `,` 在 Normal 模式打开文件树（覆盖了 vim 默认的反向 f/F 跳转）
- `jj` 在 Insert 模式退出到 Normal，不用伸手按 Esc
- `Alt + h` 跳到行首，`Alt + l` 跳到行尾
- `Tab` / `Shift + Tab` 缩进
- 行号显示绝对行号，不用相对行号
- 启用了 JSON、Python、C/C++ 三个语言的扩展（LSP、调试、补全自动配齐）
- 状态栏精简，去掉了左下角的 git 分支和右下角的时间
- 文件树侧栏宽度调到 25 列
- 装了 yazi.nvim：按 `Space + -` 在 nvim 内部弹出 yazi 浮窗，选中文件直接在 nvim 打开

![nvim 内嵌 yazi 浮窗](https://raw.githubusercontent.com/Fishason/terminal-setup/main/screenshots/08-nvim-yazi-float.png)

---

## 5. 配置和一键安装

完整配置文件、安装脚本、键位速查表都在 GitHub：

> 仓库地址：<https://github.com/Fishason/terminal-setup>

Ubuntu 服务器一行命令安装：

```
curl -fsSL https://raw.githubusercontent.com/Fishason/terminal-setup/main/install.sh | bash
```

脚本会装 fish、tmux、yazi、nvim 和周边工具，自动备份你已有的配置文件后写入新的。

---

## 写在最后

这套配置我自己用了一段时间，断断续续踩了不少坑才稳定下来。如果只能选一个工具开始学，建议从 tmux 入手，它是其它工具的容器，先掌握 tmux 之后其它工具叠加进来会顺很多。

配置如果有问题或者你有更好的建议，可以在 GitHub issue 或评论区交流。

---

- B 站主页：<https://space.bilibili.com/385436236>
- 配置仓库：<https://github.com/Fishason/terminal-setup>
- 3DS SSH 视频：<https://www.bilibili.com/video/BV1BxRCBdEXz/>
