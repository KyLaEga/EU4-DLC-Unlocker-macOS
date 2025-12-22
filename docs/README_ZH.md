# EU4 DLC 解锁器 macOS版

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/Platform-macOS-blue.svg)](https://www.apple.com/macos/)
[![Game](https://img.shields.io/badge/Game-Europa%20Universalis%20IV-red.svg)](https://store.steampowered.com/app/236850/)

**🌍 语言:** [English](../README.md) | [Русский](README_RU.md) | [Deutsch](README_DE.md) | [Français](README_FR.md) | [Español](README_ES.md) | [中文](README_ZH.md)

---

## ⚠️ 免责声明

> **⚠️ 重要：此工具仅适用于单人游戏模式！**  
> 不支持多人游戏。使用修改后的库，您无法邀请好友或通过Steam或Paradox启动器加入多人游戏会话。
>
> **🌐 想要在线游戏？** 使用 [CreamAPI](https://cs.rin.ru/forum/viewtopic.php?f=29&t=70576) — 它支持所有平台（Windows、macOS、Linux）的多人游戏。


> **本软件仅供教育目的使用。**  
> 您必须在Steam上拥有Europa Universalis IV的正版副本才能使用此工具。  
> 此工具不会下载任何DLC内容——它只解锁已存在于游戏文件中的DLC。  
> **使用风险自负。** 作者不对任何后果负责。

---

## 📖 描述

这是一个用于**macOS**上**Europa Universalis IV**的DLC解锁器。它使用[Goldberg Steam模拟器](https://github.com/inflation/goldberg_emulator)来模拟Steam上合法购买游戏的DLC所有权。

### 工作原理

该工具将原始的`libsteam_api.dylib`替换为修改版本，告诉游戏您拥有所有DLC。实际的DLC内容文件必须已经存在于您的游戏目录中。

### 功能特点

- ✅ 自动检测EU4安装路径
- ✅ 自动备份原始文件
- ✅ 简单的安装和卸载脚本
- ✅ 支持外部驱动器和自定义安装路径
- ✅ 配置中包含所有60多个EU4 DLC

---

## 📋 系统要求

- macOS 10.13或更高版本
- Europa Universalis IV（在Steam上合法购买）
- DLC内容文件（需单独获取）

---

## 🚀 安装

### 方法1：使用安装脚本（推荐）

1. **下载**此仓库或克隆它：
   ```bash
   git clone https://github.com/YOUR_USERNAME/EU4-DLC-Unlocker-macOS.git
   ```

2. **打开终端**并导航到文件夹：
   ```bash
   cd EU4-DLC-Unlocker-macOS
   ```

3. **运行安装程序：**
   ```bash
   ./install_dlc_unlocker.sh
   ```

4. 当提示时**输入路径**到您的EU4安装位置。

5. 通过Steam**启动游戏**。

### 方法2：手动安装

1. **找到您的EU4安装位置。** 常见位置：
   - `/Users/您的用户名/Library/Application Support/Steam/steamapps/common/Europa Universalis IV`
   - `/Volumes/您的驱动器/SteamLibrary/steamapps/common/Europa Universalis IV`

2. **找到`libsteam_api.dylib`：**
   ```bash
   find "/路径/到/Europa Universalis IV" -name "libsteam_api.dylib"
   ```
   通常位于：`eu4.app/Contents/Frameworks/`

3. **备份原始文件：**
   ```bash
   cp "/路径/到/libsteam_api.dylib" "/路径/到/libsteam_api.dylib.backup"
   ```

4. **复制修改后的库：**
   ```bash
   cp libsteam_api.dylib "/路径/到/eu4.app/Contents/Frameworks/"
   ```

5. **复制steam_settings文件夹：**
   ```bash
   cp -r steam_settings "/路径/到/eu4.app/Contents/Frameworks/"
   cp steam_settings/steam_appid.txt "/路径/到/eu4.app/Contents/Frameworks/"
   ```

---

## 🗑️ 卸载

运行卸载脚本：
```bash
./uninstall_dlc_unlocker.sh
```

或手动恢复备份：
```bash
cp "/路径/到/libsteam_api.dylib.backup" "/路径/到/libsteam_api.dylib"
```

---

## ❓ 常见问题

### DLC在启动器中显示警告图标

这意味着DLC内容文件缺失。解锁器只告诉游戏您"拥有"DLC——实际的内容文件必须存在于`dlc/`文件夹中。

### 在哪里获取DLC文件？

Paradox游戏的DLC文件是跨平台的（Windows/Mac/Linux）。如果您有Windows安装的文件，只需将`dlc/`文件夹的内容复制到您的Mac安装中。

### 游戏无法启动

1. 尝试通过Steam验证游戏文件
2. 确保使用适合您macOS版本的正确`libsteam_api.dylib`
3. 运行卸载程序并重试

---

## 🙏 致谢

- [Goldberg Steam模拟器](https://github.com/Mr_Goldberg/goldberg_emulator) 作者：Mr_Goldberg
- [macOS构建版本](https://github.com/inflation/goldberg_emulator) 作者：inflation
- 灵感来自[CreamInstaller](https://github.com/pointfeev/CreamInstaller)

---

## 📜 许可证

本项目采用MIT许可证 - 详见[LICENSE](../LICENSE)文件。
