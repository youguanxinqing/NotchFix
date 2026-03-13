# NotchFix

> 解决 macOS 刘海屏菜单栏图标被隐藏的问题

## 问题

macOS M4 刘海屏会压缩菜单栏空间，当图标过多时，系统会自动隐藏部分图标，导致无法访问常用工具。

## 解决方案

NotchFix 是一个原生 macOS 菜单栏管理工具，提供：

- 🔍 扫描并显示所有菜单栏图标
- ✅ 通过勾选框控制图标显示/隐藏
- 📦 通过 NotchFix 按钮快速访问隐藏的图标
- 💾 自动保存配置
- ⚡️ 轻量级，原生 Swift 实现
- 🔒 完全本地运行，无需网络权限

## 技术栈

- Swift 5.9+
- SwiftUI
- macOS 13.0+
- Accessibility API

## 安装

### 前置要求

- macOS 13.0 或更高版本
- Xcode Command Line Tools

### 构建安装

```bash
# 克隆仓库
git clone https://github.com/youguanxinqing/NotchFix.git
cd NotchFix

# 安装到 /Applications
just install
```

### 使用 just 命令

```bash
just build    # 调试模式构建
just release  # 发布模式构建
just install  # 构建并安装到 /Applications
just clean    # 清理构建产物
just run      # 构建并运行
```

## 使用方法

### 1. 授予辅助功能权限

首次运行时，NotchFix 会请求辅助功能权限：

1. 点击"打开系统设置"
2. 在"隐私与安全性 → 辅助功能"中找到 NotchFix
3. 勾选启用
4. 重启 NotchFix

### 2. 管理菜单栏图标

- **左键点击** NotchFix 图标 → 显示图标列表
- **右键点击** NotchFix 图标 → 显示菜单（刷新、设置、退出）
- **勾选图标** → 隐藏该图标
- **取消勾选** → 显示该图标

### 3. 快捷操作

- 点击刷新按钮重新扫描图标
- 配置自动保存，重启后生效

## 已知限制

1. **需要辅助功能权限**
   - macOS 安全机制要求
   - 用于扫描和控制菜单栏图标

2. **部分应用可能无法隐藏**
   - 不是所有应用都支持 `kAXHiddenAttribute`
   - 系统应用通常无法隐藏

3. **每次重新编译需要重新授权**
   - macOS 按二进制签名管理权限
   - 建议安装到 `/Applications` 后使用

## 故障排除

### 权限问题

如果遇到 `-25205` 错误（API 已禁用）：

1. 确认已在系统设置中授予权限
2. 确保运行的是 `/Applications/NotchFix.app`，不是开发版本
3. 尝试移除并重新添加权限
4. 重启 Mac

### 编译问题

如果遇到 `xcrun` 错误：

```bash
# 重置 Command Line Tools
sudo xcode-select --reset

# 或重新安装
sudo rm -rf /Library/Developer/CommandLineTools
xcode-select --install
```

### 扫描不到图标

1. 确认已授予辅助功能权限
2. 点击刷新按钮重新扫描
3. 查看控制台日志：`/Applications/NotchFix.app/Contents/MacOS/NotchFix`

## 开发

### 项目结构

```
NotchFix/
├── Sources/
│   ├── App/              # 应用入口和菜单栏管理
│   ├── Views/            # SwiftUI 界面
│   ├── Models/           # 数据模型
│   └── Services/         # 业务逻辑（扫描、隐藏、配置）
├── NotchFix.entitlements # 权限声明
├── Package.swift         # Swift Package 配置
└── justfile             # 构建脚本
```

### 开发文档

- [PLAN.md](PLAN.md) - 项目规划和技术方案
- [DEVELOPMENT_LOG.md](DEVELOPMENT_LOG.md) - 开发日志和经验总结

## 贡献

欢迎提交 Issue 和 Pull Request！

## License

MIT

## 致谢

灵感来源于：
- [Bartender](https://www.macbartender.com/)
- [Hidden Bar](https://github.com/dwarvesf/hidden)
- [Dozer](https://github.com/Mortennn/Dozer)
