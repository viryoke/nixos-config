# Cross-Platform Nix Configuration

跨平台 Nix 配置，统一管理 macOS、Ubuntu、Arch Linux 和 NixOS 的工作环境。

## 目录

- [项目结构](#项目结构)
- [快速开始](#快速开始)
- [平台支持](#平台支持)
- [功能模块](#功能模块)
- [工具清单](#工具清单)
  - [一、跨平台工具](#一跨平台工具)
  - [二、Linux专属工具](#二linux专属工具)
  - [三、macOS专属工具](#三macos专属工具)
- [自启动服务](#自启动服务)
- [CLI别名速查](#cli别名速查)
- [键位绑定](#键位绑定)
- [主题配色](#主题配色)
- [更新维护](#更新维护)

---

## 项目结构

```
nix-config/
├── flake.nix              # 主入口 - 定义所有配置
├── home.nix               # Home Manager 主配置
├── deploy.sh              # 部署辅助脚本
├── modules/               # 功能模块 (22个)
│   ├── shell.nix          # Shell (zsh, nushell)
│   ├── terminal.nix       # 终端 (ghostty [Linux], alacritty/kitty [mac])
│   ├── editor.nix         # 编辑器 (neovim, helix)
│   ├── cli-tools.nix      # CLI工具集
│   ├── file-manager.nix   # 文件管理 (yazi)
│   ├── version-control.nix# Git + Delta配置
│   ├── fonts.nix          # 字体 (JetBrains Mono, Noto)
│   ├── themes.nix         # GTK主题 [Linux]
│   ├── ai-tools.nix       # AI工具
│   ├── network.nix        # 网络/代理 (clash-verge-rev [Linux])
│   ├── vscode.nix         # VSCode配置
│   ├── zellij.nix         # 终端复用器
│   ├── github.nix         # GitHub CLI
│   ├── python.nix         # Python (uv)
│   ├── nodejs.nix         # Node.js (bun)
│   ├── wm.nix             # 窗口管理器 (niri) [Linux]
│   ├── display.nix        # 显示管理器 (ly) [Linux]
│   ├── bar.nix            # 状态栏 (waybar) [Linux]
│   ├── wallpaper.nix      # 壁纸 (hyprpaper) [Linux]
│   ├── container.nix      # 容器 (podman) [Linux]
│   ├── input-method.nix   # 输入法 (fcitx5) [Linux]
│   └── nvidia.nix         # NVIDIA显卡 [Linux]
├── platforms/             # 平台特定配置
│   ├── mac.nix            # macOS (alacritty, kitty)
│   ├── ubuntu.nix         # Ubuntu
│   ├── arch.nix           # Arch Linux
│   ├── nixos.nix          # NixOS
│   ├── darwin-system.nix  # macOS系统级
│   └── nixos-system.nix   # NixOS系统级
└── homebrew/
    └ Brewfile             # macOS GUI应用
```

---

## 快速开始

### 1. 安装 Nix

```bash
# macOS / Linux (多用户安装，推荐)
sh <(curl -L https://nixos.org/nix/install) --daemon

# 启用 Flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# 可选：配置 GitHub Token 绕过 API 速率限制
echo "ghp_your_token_here" > ~/.config/nix/github-token.txt
```

### 2. 应用配置

```bash
git clone https://github.com/viryoke/nix-config.git
cd nix-config

# 使用部署脚本（自动检测平台，自动备份冲突文件）
./deploy.sh deploy

# 跳过 flake update（遇到 API 限制时）
SKIP_UPDATE=1 ./deploy.sh deploy

# 或手动指定配置
# macOS (Home Manager)
home-manager switch --flake .#mac

# Ubuntu
home-manager switch --flake .#ubuntu

# Arch Linux
home-manager switch --flake .#arch

# NixOS (Home Manager)
home-manager switch --flake .#nixos

# NixOS (完整系统管理)
sudo nixos-rebuild switch --flake .#nixos-desktop

# macOS (nix-darwin完整系统管理)
darwin-rebuild switch --flake .#macbook
```

### 3. 设置默认 Shell (Ubuntu/Arch)

```bash
chsh -s $(which zsh)
```

### 4. 部署脚本命令

```bash
./deploy.sh deploy    # 部署配置（自动检测平台，自动备份冲突文件）
./deploy.sh rollback  # 回滚到上一版本
./deploy.sh generations # 查看历史版本
./deploy.sh clean     # 清理7天前的旧版本
./deploy.sh check     # 检查依赖是否安装

# 环境变量选项
SKIP_UPDATE=1 ./deploy.sh deploy  # 跳过 flake update（API限制时）
```

---

## 平台支持

| 平台 | 架构 | 配置名 | 配置类型 |
|------|------|--------|----------|
| macOS (Apple Silicon) | aarch64-darwin | `.#mac` | Home Manager |
| macOS (Apple Silicon) | aarch64-darwin | `.#macbook` | nix-darwin |
| Ubuntu | x86_64-linux | `.#ubuntu` | Home Manager |
| Arch Linux | x86_64-linux | `.#arch` | Home Manager |
| NixOS | x86_64-linux | `.#nixos` | Home Manager |
| NixOS | x86_64-linux | `.#nixos-desktop` | 系统配置 |

---

## 功能模块

### 跨平台模块 (14个)

| 模块 | 主要组件 | 功能 |
|------|----------|------|
| **shell** | zsh, nushell, starship | 多Shell支持，自动补全，语法高亮 |
| **editor** | neovim (LazyVim), helix | 代码编辑器 |
| **cli-tools** | bat, ripgrep, fd, eza, zoxide | 现代CLI工具替代 |
| **file-manager** | yazi | 键盘操作文件管理器 |
| **version-control** | git, lazygit, delta | Git增强配置 |
| **fonts** | JetBrains Mono NF, Noto | Nerd Font图标字体 |
| **ai-tools** | Claude Code CLI | AI编程助手 |
| **vscode** | VSCode配置 | 编辑器设置 |
| **zellij** | zellij | 终端复用器 |
| **github** | gh CLI | GitHub命令行 |
| **python** | uv | Python包管理 |
| **nodejs** | bun | JavaScript运行时 |
| **terminal** | ghostty [Linux], alacritty/kitty [mac] | 终端模拟器 |
| **network** | clash-verge-rev [Linux] | 代理客户端 |

### Linux专属模块 (9个)

| 模块 | 主要组件 | 功能 |
|------|----------|------|
| **wm** | niri | Wayland窗口管理器 |
| **display** | ly | TUI显示管理器 |
| **bar** | waybar | 状态栏 |
| **wallpaper** | hyprpaper | 壁纸管理 |
| **container** | podman | Rootless容器 |
| **input-method** | fcitx5 | 中文输入法 |
| **nvidia** | nvtop | GPU监控 |
| **themes** | Dracula GTK, Papirus图标 | 统一配色系统 |
| **terminal** | ghostty | GPU加速终端 |

### macOS专属配置

| 配置文件 | 主要组件 | 功能 |
|----------|----------|------|
| **mac.nix** | Karabiner-Elements, Rectangle, alacritty, kitty | 键盘映射、窗口管理、终端 |
| **darwin-system.nix** | 系统偏好设置 | Dock、Finder、Trackpad配置 |
| **Brewfile** | OrbStack, GUI应用 | Homebrew安装GUI工具 |

---

## 工具清单

### 一、跨平台工具

#### Shell与终端

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| zsh | 默认Shell | 启动新终端自动加载，配置自动补全、历史搜索（Ctrl+r）、语法高亮。SSH连接后自动启用 |
| nushell | 数据处理Shell | 处理结构化数据管道，JSON/CSV保持类型：`ls \| where size > 1mb \| select name size`。适合数据分析脚本 |
| starship | 跨平台提示符 | 显示当前目录、Git分支（紫色）、Python版本（蛇）、命令执行时间（黄色）。跨平台统一样式 |
| zellij | 终端复用器 | 会话持久化，SSH断开保持会话。`Ctrl+t`新标签，`Ctrl+n`新窗格，`Alt+1-9`切换标签 |

#### 终端 (平台差异)

| 工具 | 平台 | 用途 |
|------|------|------|
| ghostty | Linux | GPU加速终端，透明背景，Dracula内置主题 |
| alacritty | macOS | GPU加速终端 |
| kitty | macOS | GPU加速终端，支持图片显示 |

#### 编辑器

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| neovim | 主编辑器 | LazyVim配置，Leader键为空格。`nv config.py`编辑文件，`<Leader>ff`搜索文件，`<Leader>fg`全局搜索，`<Leader>ee`打开文件树。适合远程开发、快速编辑 |
| helix | 备用编辑器 | 开箱即用，无需配置。`hx file.rs`打开文件，选中即操作模式：`w`选词，`x`选行，`d`删除。适合临时编辑不想折腾配置 |
| vscode | GUI编辑器 | 大型项目开发、调试断点、远程SSH。安装Dracula主题扩展：`code --install-extension dracula-theme.theme-dracula`。适合需要图形界面的场景 |

#### 文件管理

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| yazi | 文件管理器 | 键盘操作，`fm`或`yazi`启动。`Enter`打开，`y`复制，`x`剪切，`p`粘贴，`d`删除，`r`重命名，`/`搜索，`gh`跳转Home，`gc`跳转Config |
| bat | 文件查看 | 语法高亮+Git标记。`bat config.py`查看Python文件彩色输出，`bat --paging=always long.log`分页查看。已配置Dracula主题 |
| eza | 文件列表 | 替代ls，显示图标+Git状态。`ls`自动别名，`ll`详细列表，`la`全部文件，`lt`树形结构（2层）。`eza --tree --level=3`查看目录树 |
| broot | 交互式目录树 | `br`启动，探索复杂项目结构。输入路径快速跳转，`e`编辑文件，`o`打开，`/`搜索。比tree更交互式的浏览 |
| dust | 磁盘分析 | 可视化磁盘占用。`dust ~/projects`分析项目目录空间，`dust -d 2`限制深度。快速定位大文件/目录 |

#### 搜索与跳转

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| ripgrep | 文本搜索 | 搜索代码内容，自动忽略.gitignore。`rg "function"`搜索函数定义，`rg -t py "import"`只搜Python，`rg -i "error"`忽略大小写。比grep快5-10倍 |
| fd | 文件查找 | 按名称查找文件。`fd config.py`查找配置文件，`fd -e json`查找所有JSON，`fd -H ".env"`搜索隐藏文件。比find快5倍 |
| fzf | 模糊搜索 | 模糊匹配历史/文件/进程。`Ctrl+r`搜索历史命令，`Ctrl+t`搜索文件并粘贴路径，`fzf -m`多选。快速选择不必精确输入 |
| zoxide | 智能跳转 | 记住常访问目录。`z proj`跳转到~/projects，`z nix`跳转到nix-config，`zi`交互式选择。比cd更高效，已别名cd |

#### 版本控制

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| git | 版本控制核心 | 已配置delta可视化diff。`ga file`添加，`gc -m "msg"`提交，`gs`状态，`gp`推送，`gl`日志图。`git config --global core.editor nvim`设置编辑器 |
| lazygit | Git TUI | 可视化Git界面。`lazygit`启动，`c`提交，`p`推送，`P`拉取，`s`暂存，`Enter`切换面板。直观查看分支、暂存区、diff |
| gh | GitHub CLI | 命令行操作仓库。`gh pr create`创建PR，`gh pr view 123`查看PR，`gh issue list`查看Issue，`gh repo clone user/repo`克隆 |
| delta | Diff查看器 | Git diff彩色显示。语法高亮+行号+并排对比。`git diff`自动使用，`delta file1 file2`对比文件。已配置Dracula主题 |

#### 开发工具

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| uv | Python包管理 | 比pip快10-100倍。`uv venv`创建环境，`uv pip install requests`安装包，`uv pip freeze > requirements.txt`导出依赖。项目级环境管理 |
| bun | JS运行时 | 替代npm/yarn，启动快。`bun install`安装依赖，`bun run dev`运行脚本，`bun test`执行测试。前端项目首选 |
| jq | JSON处理 | 解析转换JSON。`jq '.data[].name' response.json`提取字段，`jq -r`输出纯文本，`jq 'keys'`查看键。处理API响应必备 |

#### 系统监控

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| htop | 进程监控 | 交互式进程查看。`htop`启动，按CPU排序（F6），`k`杀进程，`F4`过滤进程名。实时监控系统资源 |
| bottom | 系统监控 | 现代化界面，显示CPU/内存/磁盘图表。`btm`启动，支持进程搜索过滤，比htop更美观 |
| hyperfine | 性能测试 | 对比命令执行时间。`hyperfine 'python script.py' 'bun script.js'`对比性能。适合优化脚本和工具选择 |

#### 网络与下载

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| curl | HTTP客户端 | 测试API、下载文件。`curl -X POST -d '{"key":"val"}' api.example.com`发送请求，`curl -I url`查看响应头 |
| wget | 文件下载 | 大文件下载支持断点续传。`wget -c url`继续下载，`wget -m url`镜像站点。比curl更适合文件下载 |
| httpie | HTTP客户端 | 更友好的curl。`http GET api.example.com`发送请求，`http POST api.example.com key=value`发送JSON。语法更直观 |

#### 压缩与同步

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| zip/unzip | ZIP打包 | 跨平台分发。`zip -r archive.zip folder`打包，`unzip archive.zip`解压。`unzip -l archive.zip`查看内容 |
| p7zip | 7z压缩 | 高压缩率格式。`7z a archive.7z folder`打包，`7z x archive.7z`解压。适合大文件压缩 |
| unrar | RAR解压 | `unrar x archive.rar`解压RAR文件 |
| rsync | 文件同步 | 跨机器同步，增量传输。`rsync -avz src/ dest/`同步目录，`rsync -avz --delete src/ server:dest/`镜像同步。备份部署必备 |

#### 任务与工具

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| just | 任务运行器 | 项目任务自动化，替代Makefile。`just test`运行测试，`just build`构建项目。justfile语法简单：`test: pytest` |
| watchexec | 文件监控 | 文件变化自动执行命令。`watchexec -e py 'pytest'`Python文件变化自动测试，`watchexec -e rs 'cargo build'`Rust自动编译 |
| tokei | 代码统计 | 统计项目代码。`tokei ./`显示行数、文件数、语言分布。了解项目规模 |
| trash-cli | 安全删除 | 删除到回收站可恢复。`rm`已别名到trash-put，`rl`查看列表，`tr`恢复，`te`清空。防止误删 |
| sd | sed替代 | 文本替换。`sd 'old' 'new' file`替换，`sd -s 'old' 'new'`原地替换。语法比sed简单 |
| difftastic | Diff工具 | 语法感知的diff。`difft file1 file2`对比文件，支持多种语言语法高亮 |

#### AI工具

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| claude-code | AI编程助手 | 终端内AI编程。`claude`启动交互，`claude edit file.py`编辑文件，`claude commit`生成提交信息。多文件上下文，理解项目结构 |

---

### 二、Linux专属工具

#### 窗口管理

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| niri | 窗口管理器 | Wayland滚动式窗口管理。`Mod+Return`打开终端，`Mod+Space`启动应用，`Mod+hjkl`切换窗口，`Mod+1-9`切换工作区。配置Dracula边框色 |
| waybar | 状态栏 | 顶部显示时间（紫色）、CPU/内存使用率、电池状态、音量。点击音量打开pavucontrol，通过niri自启动 |
| fuzzel | 应用启动器 | `Mod+Space`唤醒，输入应用名快速启动。支持搜索命令、计算器。Dracula配色，比rofi更轻量 |
| swaylock | 屏幕锁定 | `Mod+Escape`或3分钟无操作自动锁定。输入密码解锁，Dracula深色背景（#282a36），紫色输入框 |
| swayidle | 空闲管理 | 180秒自动锁屏，300秒系统睡眠。看电影时`swayidle -w timeout 3600 'swaylock'`临时延长。守护进程自启动 |
| mako | 通知守护进程 | 显示系统通知，点击执行动作。轻量Wayland通知器，通过niri自启动 |

#### 截图与剪贴板

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| grim | Wayland截图 | `Print`键全屏截图，保存到~/Pictures/Screenshots。`grim -g "$(slurp)" screenshot.png`区域截图 |
| slurp | 区域选择 | 选择屏幕区域。配合grim：`grim -g "$(slurp)"`截图指定区域。拖动鼠标框选范围 |
| cliphist | 剪贴板历史 | 保存复制内容历史。`cb-list`查看历史，`cb-select`通过fuzzel选择历史项粘贴，`cb-clear`清空。开机自启动监听 |
| wl-clipboard | 剪贴板操作 | Wayland剪贴板工具。`wl-copy text`复制，`wl-paste`粘贴内容。配合cliphist保存历史 |

#### 输入法

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| fcitx5 | 输入法框架 | Ctrl+Space切换中英文。开机自启动，支持拼音输入。环境变量：`GTK_IM_MODULE=fcitx`，`QT_IM_MODULE=fcitx` |
| fcitx5-chinese-addons | 拼音引擎 | 拼音输入，支持词库、模糊音。输入中文必备组件 |
| fcitx5-configtool | 配置工具 | 图形界面配置输入法。`fcitx5-configtool`启动，添加输入法、设置快捷键 |

#### 音量与亮度

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| pamixer | 音量控制 | 命令行音量调节。音量键调用，`pamixer --toggle-mute`静音切换，`pamixer --increase 5`增加5%。配合waybar显示 |
| pavucontrol | 音量GUI | 图形界面音量控制。单独调节应用音量、选择输出设备。点击waybar音量图标打开 |
| brightnessctl | 屏幕亮度 | 笔记本亮度键调节。`brightnessctl set +5%`增加，`brightnessctl info`查看当前亮度。支持多显示器 |
| playerctl | 媒体控制 | 播放键控制音乐。`playerctl play-pause`暂停，`playerctl next`下一首。支持Spotify、VLC等 |

#### 容器

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| podman | 容器运行时 | Docker替代，rootless模式更安全。CLI兼容Docker：`podman run -it ubuntu bash`，`podman ps`查看容器，`podman images`查看镜像 |
| podman-compose | 容器编排 | 替代docker-compose。`podman-compose up -d`启动服务，`podman-compose down`停止。YAML配置兼容Docker Compose |
| dive | 镜像分析 | 分析镜像层结构。`dive ubuntu:latest`查看每层内容和大小。优化镜像大小必备工具 |
| podman-tui | Podman TUI | 可视化管理界面。`pt`启动，查看容器、镜像、卷、网络。替代lazydocker |

#### 壁纸与主题

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| hyprpaper | 壁纸管理 | 设置桌面壁纸。开机自启动。`wp-list`查看壁纸列表，`wp-random`随机切换，`wp-set wallpaper.jpg`指定壁纸 |
| dracula-theme | GTK主题 | Dracula配色GTK主题。自动应用于GTK应用 |
| papirus-icon-theme | 图标主题 | Papirus图标集，配合Dracula主题 |
| bibata-cursors | 光标主题 | Bibata光标，现代简约风格 |

#### 终端

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| ghostty | GPU加速终端 | 透明背景0.9+模糊20px。`Ctrl+t`新建标签，`Ctrl+Enter`水平分屏，`Ctrl+Shift+Enter`垂直分屏。内置Dracula主题 |

#### 代理

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| clash-verge-rev | 代理GUI | 网络代理工具。开机自启动，GUI配置节点。`proxy-on`启用命令行代理（127.0.0.1:7890），`proxy-off`禁用，`proxy-test`测试连接 |

---

### 三、macOS专属工具

| 工具 | 用途 | 使用场景与命令示例 |
|------|------|-------------------|
| OrbStack | Docker/K8s替代 | 比Docker Desktop快5倍、内存少90%。支持docker/kubectl命令。`orb ubuntu run "apt update"`运行Linux命令，`orb create nixos nix`创建NixOS VM |
| Rectangle | 窗口管理 | 键盘快捷键调整窗口位置。`Meta+Ctrl+M`最大化，`Meta+Ctrl+Left`左半屏，`Meta+Ctrl+C`居中 |
| Karabiner-Elements | 键盘映射 | Caps Lock映射为Ctrl+Escape。自定义键盘快捷键，Mac键盘定制必备 |
| alacritty | GPU终端 | 跨平台GPU加速终端 |
| kitty | GPU终端 | 支持图片显示的终端 |

---

## 自启动服务

### Linux systemd用户服务

| 服务 | 说明 | 触发 |
|------|------|------|
| swayidle | 自动锁屏 | 180s锁屏，300s休眠 |
| cliphist | 剪贴板历史 | 图形会话启动 |
| fcitx5 | 输入法 | 图形会话启动 |
| hyprpaper | 壁纸 | 图形会话启动 |
| clash-verge-rev | 代理 | 图形会话启动 |
| waybar | 状态栏 | niri启动 |
| mako | 通知 | niri启动 |

---

## CLI别名速查

### 文件操作

```bash
ls      → eza --icons              # 图标列表
ll      → eza -l --icons           # 详细列表
la      → eza -la --icons          # 全部文件
cat     → bat --paging=never       # 美化输出
find    → fd                       # 快速查找
grep    → rg                       # 快速搜索
du      → dust                     # 磁盘使用
cd      → z                        # 智能跳转
rm      → trash-put                # 安全删除
rl      → trash-list               # 查看回收站
tr      → trash-restore            # 恢复文件
te      → trash-empty              # 清空回收站
```

### Git操作

```bash
g       → git                      # Git快捷
ga      → git add                  # 添加
gc      → git commit               # 提交
gs      → git status               # 状态
gp      → git push                 # 推送
gl      → git log --oneline --graph # 日志图
```

### 容器操作 (Linux)

```bash
docker      → podman               # Docker兼容
docker-compose → podman-compose    # Compose兼容
d           → podman               # Podman快捷
dc          → podman-compose       # Compose快捷
dps         → podman ps            # 运行容器
dex         → podman exec -it      # 进入容器
dcup        → podman-compose up -d # 启动服务
pt          → podman-tui           # TUI界面
```

### 剪贴板 (Linux)

```bash
cb-list     → cliphist list        # 查看历史
cb-clear    → cliphist clear       # 清空历史
cb-select   → 选择历史项粘贴       # fuzzel选择
```

### Python (uv)

```bash
pi      → uv pip install           # 安装包
pu      → uv pip uninstall         # 卸载包
pf      → uv pip freeze            # 导出依赖
pl      → uv pip list              # 列出包
pv      → uv venv                  # 创建环境
ua      → uv add                   # 添加依赖
ur      → uv remove                # 移除依赖
us      → uv sync                  # 同步依赖
ul      → uv lock                  # 锁定依赖
urun    → uv run                   # 运行命令
uinit   → uv init                  # 初始化项目
```

### GitHub (gh)

```bash
ghc     → gh repo create           # 创建仓库
ghr     → gh repo view             # 查看仓库
ghf     → gh repo fork             # Fork仓库
ghcl    → gh repo clone            # 克隆仓库
prc     → gh pr create             # 创建PR
prv     → gh pr view               # 查看PR
prm     → gh pr merge              # 合并PR
isc     → gh issue create          # 创建Issue
isv     → gh issue view            # 查看Issue
```

### 系统管理

```bash
nv          → nvim                 # Neovim
hx          → helix                # Helix
fm          → yazi                 # 文件管理器
rebuild     → home-manager switch --flake # 重建
update      → nix flake update     # 更新Flake
```

---

## 键位绑定

### Niri窗口管理器 (Linux)

| 按键 | 功能 |
|------|------|
| `Mod+h/j/k/l` | 焦点移动 |
| `Mod+Shift+h/j/k/l` | 窗口移动 |
| `Mod+1..9` | 切换工作区 |
| `Mod+Shift+1..9` | 窗口移至工作区 |
| `Mod+Return` | 打开终端 |
| `Mod+Space` | 打开启动器 |
| `Mod+X` | 关闭窗口 |
| `Mod+F` | 全屏切换 |
| `Mod+Escape` | 锁屏 |
| `Print` | 截屏 |
| `Shift+Print` | 区域截图 |

### Ghostty终端 (Linux)

| 按键 | 功能 |
|------|------|
| `Ctrl+t` | 新标签页 |
| `Ctrl+w` | 关闭标签页 |
| `Ctrl+Tab` | 切换标签页 |
| `Ctrl+Enter` | 水平分屏 |
| `Ctrl+Shift+Enter` | 垂直分屏 |
| `Ctrl+Alt+方向键` | 切换窗格 |

### Zellij终端复用器

| 按键 | 功能 |
|------|------|
| `Ctrl+t` | 新标签页 |
| `Ctrl+w` | 关闭标签页 |
| `Ctrl+h/j/k/l` | 窗格移动 |
| `Ctrl+n` | 新窗格(下) |
| `Ctrl+p` | 新窗格(右) |
| `Ctrl+f` | 全屏切换 |
| `Alt+1..9` | 切换标签页 |

### Yazi文件管理器

| 按键 | 功能 |
|------|------|
| `Enter` | 打开文件 |
| `y/x/p` | 复制/剪切/粘贴 |
| `d` | 删除 |
| `r` | 重命名 |
| `.` | 切换隐藏文件 |
| `/` | 搜索 |
| `g+h/c/d` | 跳转Home/Config/Downloads |

---

## 主题配色

### Dracula主题色值

| 颜色 | 用途 | 色值 |
|------|------|------|
| Background | 背景 | <span style="background:#282a36;padding:4px 12px;border-radius:4px;">#282a36</span> |
| Current Line | 当前行 | <span style="background:#44475a;padding:4px 12px;border-radius:4px;">#44475a</span> |
| Foreground | 文字 | <span style="background:#f8f8f2;color:#282a36;padding:4px 12px;border-radius:4px;">#f8f8f2</span> |
| Comment | 注释 | <span style="background:#6272a4;padding:4px 12px;border-radius:4px;">#6272a4</span> |
| Cyan | 青色 | <span style="background:#8be9fd;color:#282a36;padding:4px 12px;border-radius:4px;">#8be9fd</span> |
| Green | 绿色 | <span style="background:#50fa7b;color:#282a36;padding:4px 12px;border-radius:4px;">#50fa7b</span> |
| Orange | 橙色 | <span style="background:#ffb86c;color:#282a36;padding:4px 12px;border-radius:4px;">#ffb86c</span> |
| Pink | 粉色 | <span style="background:#ff79c6;padding:4px 12px;border-radius:4px;">#ff79c6</span> |
| Purple | 紫色 | <span style="background:#bd93f9;padding:4px 12px;border-radius:4px;">#bd93f9</span> |
| Red | 红色 | <span style="background:#ff5555;padding:4px 12px;border-radius:4px;">#ff5555</span> |
| Yellow | 黄色 | <span style="background:#f1fa8c;color:#282a36;padding:4px 12px;border-radius:4px;">#f1fa8c</span> |

### 应用主题配置

| 应用 | 主题来源 |
|------|----------|
| Ghostty | 内置 `dracula` |
| Neovim | dracula/vim插件 |
| VSCode | Dracula扩展 |
| Waybar | 自定义配色 |
| Zellij | 自定义主题 |
| GTK | Dracula主题包 |
| Bat | Dracula主题 |

---

## 更新维护

### 更新配置

```bash
# 更新所有inputs
nix flake update

# 更新特定input
nix flake update nixpkgs

# 应用配置
./deploy.sh deploy
```

### 查看信息

```bash
nix flake metadata    # 查看inputs状态
nix flake show        # 查看可用配置
nix flake check       # 检查配置语法
```

### 回滚配置

```bash
./deploy.sh generations  # 查看历史
./deploy.sh rollback     # 回滚上一版本
```

### 清理旧版本

```bash
./deploy.sh clean     # 清理7天前的旧版本
```

---

## 参考资源

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [LazyVim](https://www.lazyvim.org/)
- [Niri](https://github.com/YaLTeR/niri)
- [Zellij](https://zellij.dev/)
- [Dracula Theme](https://draculatheme.com/)
- [OrbStack](https://orbstack.dev/)

---

## 许可证

MIT License