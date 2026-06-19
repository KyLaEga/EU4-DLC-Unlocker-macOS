# EU4 DLC 解锁器 macOS版

**版本 4.0.1 — 模块化引擎，CreamAPI v5.3.0.0，完整解锁 DLC，支持多人游戏**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 语言:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ 免责声明与法律提示

> **仅供教育目的。使用风险自负。**
>
> - 您必须**在 Steam 上拥有 Europa Universalis IV 的正版副本**。本工具**不会下载**
>   任何 DLC——它只是更改游戏中已存在文件的 DLC 的所有权状态。
> - 使用 DLC 解锁器**违反 Steam 订阅者协议和 Paradox 的 EULA**。原则上这可能导致
>   **VAC/账号封禁**。EU4 没有受 VAC 保护的服务器，因此实际风险较低，但**并非为零**——
>   由您自行承担。
> - 作者不对任何后果负责。如果您喜欢这款游戏，**请购买 DLC 以支持 Paradox Interactive。**

---

## 📖 描述

一个用于 **macOS** 上 **Europa Universalis IV** 的 DLC 解锁器。它使用
[CreamAPI v5.3.0.0](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576)
为在 Steam 上合法购买的游戏解锁 DLC 所有权。

### 工作原理

该工具将 CreamAPI 的 `libsteam_api.dylib`（位于真正 Steam 库之前的代理）安装到
`eu4.app/Contents/Frameworks/`，将原始库备份为 `libsteam_api_o.dylib`，并写入一个
`cream_api.ini`。启动时，游戏向 Steam 询问您拥有哪些 DLC，CreamAPI 对每个已解锁的
DLC 回答“是”，同时将其他一切代理到真正的 Steam——因此**多人游戏仍可正常使用**。

安装时，工具会**读取游戏自带的 `dlc/*.dlc` 元数据**并写入显式的 `[dlc]` 列表
（`unlockall = false`）。这是有意为之：EU4 有 130 多个内容包，而 `unlockall = true`
依赖 Steam 的*运行时* DLC 列表，对 DLC 众多的游戏该列表会**被截断**——于是只解锁一部分。
由你自己的内容构建的列表是**完整的**，并且**离线也可用**。它在每次安装时重新生成。
若未找到 DLC 元数据，则回退到 `unlockall = true`。

### 功能特点

- ✅ **支持多人游戏**（CreamAPI 代理到真正的 Steam）
- ✅ 完整 DLC 解锁——根据你自己的 `dlc/` 内容生成显式列表（不被截断、可离线），每次安装时重新生成
- ✅ 自动检测 EU4 安装（内置磁盘**和**外部驱动器）
- ✅ 安全备份原始文件；干净且可逆的卸载
- ✅ 非修改性的 `status` 命令——显示已安装的内容
- ✅ 经校验和验证的**通用**二进制（原生 Intel **与** Apple Silicon）

---

## 📋 系统要求

### 支持的平台

| 平台         | 架构                  | 状态                    |
|--------------|-----------------------|-------------------------|
| macOS 10.13+ | Intel (x86_64)        | ✅ 原生                 |
| macOS 11+    | Apple Silicon (M1–M4) | ✅ 原生 (arm64)         |

随附的 `libsteam_api.dylib` 是一个**通用**（fat）二进制，同时包含 `x86_64` 和
`arm64` 切片——在 Apple Silicon 上**无需 Rosetta 2**。

### 前置条件

- macOS 10.13（High Sierra）或更高版本
- 在 Steam 上合法购买的 Europa Universalis IV
- DLC **内容文件**（必须已存在——本工具不下载它们）
- 建议安装 Xcode 命令行工具（`xcode-select --install`）以使用 `codesign`/`xattr`

---

## 🚀 安装

**速览** — 三条命令，然后启动游戏：

```bash
git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
cd EU4-DLC-Unlocker-macOS
./install_dlc_unlocker.sh
```

### 分步说明

1. **先确认 DLC 内容已就位。** 游戏的 `dlc/` 文件夹必须已经包含 DLC 内容包
   （本工具解锁所有权，**不会下载**内容）。若为空，见下方常见问题
   〈在哪里获取 DLC 内容文件？〉。

2. **克隆或下载**仓库：
   ```bash
   git clone https://github.com/KyLaEga/EU4-DLC-Unlocker-macOS.git
   cd EU4-DLC-Unlocker-macOS
   ```

3. **运行安装程序：**
   ```bash
   ./install_dlc_unlocker.sh
   ```
   这是 `./bin/unlocker install eu4` 的轻量封装。该工具会验证随附库、自动检测
   EU4 安装（内置磁盘**和**外部驱动器）、将原始库备份为 `libsteam_api_o.dylib`、
   安装 CreamAPI、根据你的 `dlc/` 内容构建显式 DLC 列表，并为 Gatekeeper 做
   ad-hoc 重新签名。

   如果游戏位于不常见的位置，请直接指定路径：
   ```bash
   ./bin/unlocker install eu4 --path "/Volumes/My Drive/SteamLibrary/steamapps/common/Europa Universalis IV"
   ```

4. **通过 Steam 启动 EU4。** 有了显式 `[dlc]` 列表，离线也能用。**重要：**
   如果游戏或 Paradox Launcher 已经打开，请**彻底退出（`⌘Q`）**再重新启动——
   CreamAPI 只在进程启动时读取一次 `cream_api.ini`。

### 验证

在不更改任何内容的情况下检查补丁状态：
```bash
./bin/unlocker status eu4
```
应当看到：
```
[+] Patch state:     INSTALLED (CreamAPI active)
[+] Original backup: PRESENT (...libsteam_api_o.dylib)
[+] cream_api.ini:   PRESENT
[*]   unlockall = false; explicit [dlc] list (N DLC)
```
然后在 Paradox Launcher 中打开 **DLC** 标签页——凡是内容已存在的 DLC 都应显示为
已拥有（没有“Buy”按钮，没有警告图标）。

---

## 🛠️ 用法（`unlocker` 命令行）

唯一入口是 `bin/unlocker`；两个 `*_dlc_unlocker.sh` 是为向后兼容而保留的轻量封装。

```text
./bin/unlocker install   [eu4]   # 备份原始库 + 安装 CreamAPI
./bin/unlocker uninstall [eu4]   # 恢复原始库
./bin/unlocker status    [eu4]   # 不修改：补丁 / 备份 / 完整性
./bin/unlocker --help
./bin/unlocker --version

选项（命令之后）：
  --yes          非交互式；默认回答“是”。
  --path DIR     使用此游戏目录，而非自动检测。
```

在不更改任何内容的情况下检查状态：
```bash
./bin/unlocker status eu4
```

### `install` 在底层做了什么

1. **完整性校验** — 除非随附的 `libsteam_api.dylib` 与已固定的 SHA256 匹配，
   否则不会运行（防篡改/防损坏）。
2. **定位游戏** — 展开 `games/eu4.conf` 中的搜索路径（处理空格和外部
   `/Volumes/*` 驱动器）；或使用 `--path`。
3. **备份**原始库为 `libsteam_api_o.dylib`（不会覆盖已有的良好备份）。
4. **安装 CreamAPI** — 复制代理 dylib，并在重新签名前再次校验副本的哈希。
5. **构建 `cream_api.ini`** — 扫描 `dlc/*/*.dlc`，收集每个 `steam_id`，去重后
   写入带 `unlockall = false` 的显式 `[dlc]` 列表。
6. **macOS 加固** — 移除隔离属性（`xattr`）并对 dylib 做 ad-hoc 重新签名
   （`codesign -s -`），使 Gatekeeper 能在游戏进程中加载它。

`uninstall` 撤销第 3–4 步（恢复备份、删除 `cream_api.ini`、重新签名）。
`status` 报告以上全部信息且不做任何更改。

---

## 🗑️ 卸载

```bash
./uninstall_dlc_unlocker.sh
# 或：./bin/unlocker uninstall eu4
```

从备份恢复 `libsteam_api.dylib`，删除 `cream_api.ini`，重新签名原始库，并清理遗留文件。

> Steam 的**“验证游戏文件完整性”**会悄悄恢复原始库并移除补丁——这是正常的。
> 重新运行安装程序，或运行 `status` 检查当前状态。

---

## ❓ 常见问题

### DLC 在启动器中显示警告图标
缺少 DLC 的**内容文件**。本工具只更改所有权状态——实际内容必须位于游戏的 `dlc/` 文件夹中。

### 在哪里获取 DLC 内容文件？
本工具**不分发也不下载** DLC——内容由你自备。Paradox 的 DLC 内容是跨平台的，
因此通常的做法是**从你已经拥有的机器上复制 `dlc/` 文件夹**（例如你自己的
Windows/Linux 安装）到你的 Mac 安装中：
```
.../steamapps/common/Europa Universalis IV/dlc/
```
每个 DLC 位于各自的子文件夹（`dlc/dlcNNN_name/`）中，含一个 `.dlc` 元数据文件、
一个 `.zip` 和一张缩略图。复制后，（重新）运行安装程序，让 `[dlc]` 列表据新内容重建。

**内容是多卷压缩包（`*.zip.001`、`*.zip.002` …）？**
这些分卷是**同一个**被切分的压缩包，并非各自独立的 zip。在 macOS 上这样合并并解压
（不要分别解压每一卷）：
```bash
# 7-Zip 支持 EU4 内容包常用的 LZMA，并在你指向第一卷时自动读取所有分卷：
brew install sevenzip
7zz x "DLC-….zip.001" -o"/路径/到/Europa Universalis IV"   # 写出 dlc/ 目录树

# 或者先把分卷拼接成一个文件（顺序很重要）：
cat DLC-….zip.00{1,2,3,4} > DLC-….zip
7zz x DLC-….zip -o"/路径/到/Europa Universalis IV"
```
把 `-o` 指向游戏文件夹（`dlc/` 的上一级）——压缩包里已包含顶层 `dlc/`，因此解压到
那里会就地合并。

### Steam“验证完整性”还原了我的补丁
这是正常的——Steam 用原始库替换了我们的库。运行
`./bin/unlocker status eu4` 检查，然后重新安装。

### 游戏无法启动
macOS Gatekeeper 可能会阻止修改后的库。安装程序已移除隔离属性并对 dylib 进行
ad-hoc 重新签名；如果您是手动复制文件：
```bash
xattr -dr com.apple.quarantine "/路径/到/eu4.app"
codesign --force -s - "/路径/到/eu4.app/Contents/Frameworks/libsteam_api.dylib"
```
如果缺少 `codesign`/`xattr`，请先安装命令行工具：
`xcode-select --install`。仍无法解决？请卸载后重试。

### 随附的库安全吗？
随附的 `libsteam_api.dylib` 与官方 CreamAPI *nonlog* macOS 构建逐字节相同，
在 **VirusTotal 上为 0/64**。您可以自行重新校验——参见
[docs/SECURITY.md](SECURITY.md) 和
[vendor/creamapi/VERSION.txt](../vendor/creamapi/VERSION.txt)。（注意：该二进制的
install-name 中嵌入了上游构建路径；这无害，且正是本工具用来检测已安装补丁的依据。）

### 会解锁哪些 DLC？
**`dlc/` 文件夹中存在内容的所有 DLC。** 安装程序读取每个 `dlc/*.dlc` 文件，收集其
Steam appid，并将完整集合写入 `cream_api.ini` 的 `[dlc]` 段。添加了新内容？重新运行
安装程序，列表会重新生成。（我们刻意不用 `unlockall = true`——Steam 的运行时列表对 EU4
会被截断，只能解锁一部分。`status eu4` 会显示当前配置覆盖了多少个 DLC。）

### 为什么 `status` 显示的 DLC 比我的文件夹少？
这是正常的，没有遗漏。`dlc/` 文件夹存放的是**内容包**（完整游戏共 134 个），但 Steam
把它们作为更少的**购买项**出售——一次购买常常捆绑多个包（一个扩展 + 其兵种包 + 其音乐包
共用一个 Steam appid）。本工具**按 Steam appid** 授予所有权，因此约 75 个 appid 即可
覆盖全部 134 个包。`status` 显示 appid 的数量；启动器会显示它们解锁的所有包。

### 我能解锁其他 Paradox 游戏吗？
引擎与具体游戏无关。例如要支持 CK3，只需新增一个 `games/<game>.conf`
（appid + 搜索路径）——无需更改代码。目前只随附 EU4；
参见 [docs/CONTRIBUTING.md](CONTRIBUTING.md)。

---

## 📜 解锁策略沿革

macOS 解锁器先后用过三种解锁策略。如果你用过旧版本，下面是变化与原因：

| 版本      | 策略                                  | 多人 | 说明 |
|-----------|---------------------------------------|:----:|------|
| 1.x – 2.x | **Goldberg Steam 模拟器**             | ❌ | 完全*离线模拟* Steam 并替换 `libsteam_api.dylib`；使用 `steam_settings/` 文件夹和 `steam_appid.txt`。**仅单人**——无法邀请好友或加入会话。 |
| 3.0       | **CreamAPI + `unlockall = true`**     | ✅ | 改用 CreamAPI *代理*，转发给真正的 Steam，多人游戏恢复可用。DLC 来自 Steam 的运行时列表。 |
| 4.0.1+    | **CreamAPI + 显式 `[dlc]` 列表**       | ✅ | Steam 的运行时列表对 EU4 会被截断（仅约 ⅓ 解锁），因此安装程序现在根据你自己的 `dlc/` 内容构建完整列表。 |

如果你是从 1.x–2.x 安装升级，`uninstall` 仍会清理旧的 Goldberg 残留
（`steam_settings/`、`steam_appid.txt`、`*.backup`）。

---

## 🔐 安全性与完整性

如果随附 dylib 的 SHA256 与 `vendor/creamapi/VERSION.txt` 不匹配，安装程序将拒绝
运行（防篡改/防损坏保护），并且 CI 在每次推送时都会重新验证。参见
[docs/SECURITY.md](SECURITY.md)。

## 🙏 致谢

- [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — DLC 解锁库
- 灵感来自 CreamInstaller (repo no longer available)

## 📜 许可证

采用 MIT 许可证 — 详见 [LICENSE](../LICENSE)。

## ⭐ 支持

如果它帮到了您：⭐ 为仓库点星，🐛 报告问题，💡 提出改进建议。
**如果您喜欢 EU4 及其 DLC，请购买它们以支持 Paradox Interactive。**
