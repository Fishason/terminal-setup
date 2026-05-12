# 截图指引

文章里 11 处 `[截图 N: ...]` 占位符，建议都补上真实截图（B 站投稿专栏支持图文混排，有图会更受欢迎）。

按顺序对照拍摄：

## 截图 1：终端整体效果（封面 / 开篇用）
**目标**：一张让人觉得"哇这个看起来真的能用来写代码"的图。
- tmux 左右分屏
- 左边 nvim 打开一个有代码的文件（python/js/lua 都行，要彩色 syntax highlight）
- 右边 yazi 或 fish shell
- 状态栏可见
**怎么拍**：找一个看起来体面的项目，分屏布局好，截整个终端窗口

## 截图 2：fish 边输入边显示灰色补全
- fish shell 里输入 `git ` 或 `cd ` 等命令
- 后面跟着灰色的历史补全
- 同时显示彩色高亮的语法
**怎么拍**：输入命令但不要按回车，截下来

## 截图 3：fish abbreviation 展开过程
- 输入 `cl` 然后按空格 → 自动展开成 `claude --dangerously-skip-permissions`
**怎么拍**：可以拍两张（展开前/展开后），或者录个 GIF

## 截图 4：tmux 状态栏特写
- 截下 tmux 底部那一栏
- 可以看到当前窗口高亮、其它窗口暗色、右侧路径
**怎么拍**：开多个 tmux 窗口（`Alt+c c` 新建），让状态栏热闹一点，再截屏

## 截图 5：Alt+数字 切窗口
- 截 tmux 多窗口的状态栏（窗口 1、2、3）
- 可选：旁边放一个箭头/标注 "Alt+2"
**怎么拍**：开 3-4 个 tmux 窗口分别运行不同程序（top, fish, vim 等）

## 截图 6：tmux 多重分屏布局
- 一个 tmux 窗口里上下 + 左右分了 4 个面板
- 每个面板跑不同东西（fish, nvim, yazi, top 之类）
**怎么拍**：先 `Alt+c '` 上下分，再在某个面板 `Alt+c 5` 左右分。每个面板跑一个有视觉效果的程序

## 截图 7：yazi 三列布局
- 左：父目录列表
- 中：当前目录文件列表，高亮选中一个文件
- 右：被选中文件的预览（代码或图片）
**怎么拍**：在 yazi 里移动到一个 `.py` 或 `.js` 文件上，右侧自动会显示预览

## 截图 8：yazi 图片预览
- yazi 选中一张图片，右侧显示字符画
**怎么拍**：在 yazi 里移到一张 png/jpg 文件上

## 截图 9：LazyVim 主界面（dashboard）
- nvim 启动时的欢迎页
- 显示 Sessions/Recent files/Find file 等选项
**怎么拍**：在空目录里执行 `nvim`（不带参数）

## 截图 10：nvim Space+e 弹出文件树
- nvim 已打开一个文件
- 左侧出现 snacks.explorer 文件树侧栏
**怎么拍**：进 nvim 后按 `Space + e`

## 截图 11：nvim 中 Space+- 弹出 yazi 浮窗
- nvim 编辑器在背景
- 中间浮窗是 yazi 文件管理器
**怎么拍**：进 nvim 后按 `Space + -`

---

## 截图工具建议

**Mac 上（如果你用 VS Code 终端）：**
- `Cmd + Shift + 4` 然后 Space → 点击窗口截整个窗口
- `Cmd + Shift + 4` 然后框选区域

**SSH 服务器直接的图（推荐）：**
建议直接在 Mac 上截 VS Code 终端窗口的图，这是观众实际能看到的样子。

**GIF 录制（如果想录交互过程）：**
- Mac: [LICEcap](https://www.cockos.com/licecap/) 或 [Kap](https://getkap.co/)
- 录 5-10 秒的小动作（比如展开 abbreviation、分屏、切窗口）

---

## 图片放在哪

放进 `screenshots/` 文件夹，然后在 `bilibili-article.md` 里把对应的 `[截图 N: ...]` 替换成 `![描述](screenshots/01-overview.png)` 之类的引用。

文件命名建议：
```
01-overview.png
02-fish-completion.png
03-fish-abbreviation.gif
04-tmux-status.png
05-tmux-window-switch.png
06-tmux-split.png
07-yazi-three-columns.png
08-yazi-image-preview.png
09-lazyvim-dashboard.png
10-lazyvim-file-tree.png
11-yazi-in-nvim.png
```
