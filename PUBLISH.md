# 发布到 GitHub 步骤

> 这份文件是给你自己看的（怎么把这个文件夹推到 GitHub），不需要包括在投稿文章里。

## 1. 在 GitHub 上创建新仓库

1. 打开 https://github.com/new
2. Repository name: `terminal-setup`（或你喜欢的名字）
3. Visibility: **Public**（这样别人才能 `curl ... | bash`）
4. 不要勾选 "Initialize with README"（我们已经有了）
5. 点 Create repository

## 2. 在本地初始化 git 并推送

```bash
cd /home/ubuntu/my/terminal-setup

git init
git add .
git commit -m "initial commit: terminal setup configs and one-click installer"
git branch -M main
git remote add origin https://github.com/<YOUR_USERNAME>/terminal-setup.git
git push -u origin main
```

如果 GitHub 让你输用户名密码，**密码处输入 Personal Access Token**（不是账号密码）。生成 token：
- GitHub 右上角头像 → Settings → Developer settings → Personal access tokens → Tokens (classic)
- Generate new token，勾选 `repo` 权限
- 复制下来粘贴在 password 提示符处

## 3. 更新文件里的占位符

发布前，把以下 3 个文件中的 `[YOUR_USERNAME]` / `REPLACE_WITH_YOUR_USERNAME` 替换成你的 GitHub 用户名：

```bash
# 找出所有占位符
grep -rn "YOUR_USERNAME\|REPLACE_WITH" /home/ubuntu/my/terminal-setup/

# 用 sed 一次全改（把 YOUR_USERNAME_HERE 换成你的实际用户名）
sed -i 's/\[YOUR_USERNAME\]/YOUR_USERNAME_HERE/g; s/REPLACE_WITH_YOUR_USERNAME/YOUR_USERNAME_HERE/g' \
    README.md install.sh bilibili-article.md
```

确认没有遗漏后 commit 一次：

```bash
git add .
git commit -m "fill in github username"
git push
```

## 4. 测试一键安装命令

在另一台干净的 Ubuntu 服务器上试：

```bash
curl -fsSL https://raw.githubusercontent.com/<YOUR_USERNAME>/terminal-setup/main/install.sh | bash
```

如果跑不通，调整 install.sh 后重新 push。

## 5. 投稿 Bilibili 专栏

1. 打开 https://member.bilibili.com/platform/upload/text/edit
2. 复制 `bilibili-article.md` 内容粘贴进去
3. **B 站编辑器支持 Markdown 但需要切到"Markdown 模式"**——右上角有切换按钮
4. 把 `[截图 N: ...]` 占位符替换成实际上传的图（按 SCREENSHOTS.md 拍图）
5. 把 README 里的 `[YOUR_USERNAME]/terminal-setup` 链接更新成真实链接
6. 发布
