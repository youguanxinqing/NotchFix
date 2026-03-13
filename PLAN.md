# NotchFix 项目规划

## 核心功能

### MVP (最小可行产品)
1. ✅ **菜单栏图标检测** - 使用 Accessibility API 识别菜单栏图标
2. ✅ **图标隐藏/显示** - 通过勾选框控制图标显示状态
3. ✅ **NotchFix 菜单栏按钮** - 点击展开图标列表
4. ✅ **配置持久化** - 保存用户的隐藏配置到本地
5. ✅ **右键菜单** - 刷新、设置、退出功能

### 待实现功能
- ⏳ 图标拖拽排序
- ⏳ 快捷键支持
- ⏳ 自动隐藏规则
- ⏳ 主题定制

## 技术方案

### 1. 菜单栏图标检测 ✅
**实现**: Accessibility API

**关键代码**:
```swift
let systemWideElement = AXUIElementCreateSystemWide()
AXUIElementCopyAttributeValue(systemWideElement, kAXMenuBarAttribute, &menuBarRef)
AXUIElementCopyAttributeValue(menuBar, kAXChildrenAttribute, &childrenRef)
```

**状态**: 已实现，需要辅助功能权限

### 2. 图标隐藏机制 ✅
**实现**: 设置 `kAXHiddenAttribute` 属性

**限制**: 
- 需要辅助功能权限
- 不是所有应用都支持此属性
- 部分应用可能无法隐藏

**状态**: 已实现，等待权限问题解决后验证

### 3. UI 界面 ✅
- 菜单栏按钮（左键展开列表，右键显示菜单）
- 图标列表（显示名称、Bundle ID、勾选框）
- 刷新按钮
- 设置窗口

**状态**: 已完成

### 4. 配置存储 ✅
**位置**: `~/Library/Application Support/NotchFix/config.json`

**格式**:
```json
{
  "hiddenApps": ["com.example.app1", "com.example.app2"],
  "iconOrder": []
}
```

**状态**: 已完成

## 项目结构

```
NotchFix/
├── Sources/
│   ├── App/
│   │   ├── NotchFixApp.swift          ✅ App 入口
│   │   └── AppDelegate.swift          ✅ 菜单栏管理
│   ├── Views/
│   │   ├── SettingsView.swift         ✅ 设置界面
│   │   ├── IconListView.swift         ✅ 图标列表
│   │   └── AppListView.swift          ⚠️ 废弃（方案2遗留）
│   ├── Models/
│   │   ├── MenuBarIcon.swift          ✅ 图标数据模型
│   │   ├── Config.swift               ✅ 配置模型
│   │   └── MenuBarApp.swift           ⚠️ 废弃（方案2遗留）
│   └── Services/
│       ├── MenuBarScanner.swift       ✅ 扫描菜单栏图标
│       ├── IconManager.swift          ✅ 隐藏/显示逻辑
│       ├── ConfigManager.swift        ✅ 配置读写
│       └── AppScanner.swift           ⚠️ 废弃（方案2遗留）
├── NotchFix.entitlements              ✅ 权限声明
├── Package.swift                      ✅ Swift Package 配置
├── justfile                           ✅ 构建脚本
├── README.md                          ⏳ 需要更新
├── PLAN.md                            ✅ 本文件
├── PLAN_V2.md                         ⚠️ 废弃（方案2遗留）
└── DEVELOPMENT_LOG.md                 ✅ 开发日志
```

## 开发路线图

### Phase 1: 基础框架 ✅
- [x] 创建 Xcode 项目
- [x] 实现菜单栏按钮
- [x] 创建设置窗口
- [x] 配置权限请求

### Phase 2: 核心功能 ✅
- [x] 实现菜单栏图标扫描
- [x] 实现图标隐藏/显示
- [x] 实现图标列表 UI
- [x] 配置持久化

### Phase 3: 优化 ⏳
- [x] UI 优化
- [x] 错误处理
- [x] 用户引导
- [ ] 性能优化

### Phase 4: 发布 ⏳
- [ ] 解决权限问题
- [ ] 验证隐藏功能
- [ ] 打包签名
- [ ] 编写文档
- [ ] 发布到 GitHub

## 当前问题

### 1. 辅助功能权限 🔴
**问题**: 即使授予权限，仍然报错 `-25205`

**原因**: 
- 开发版本和安装版本签名不同
- Xcode Command Line Tools 损坏影响编译

**解决方案**:
1. 修复 Command Line Tools: `sudo xcode-select --reset`
2. 重新编译安装
3. 重新授权

### 2. 图标隐藏未验证 🟡
**状态**: 代码已实现，但因权限问题无法测试

**风险**: `kAXHiddenAttribute` 可能不被所有应用支持

## 技术难点

1. **权限管理复杂**
   - macOS 按二进制文件授权，不是按应用名
   - 每次重新编译需要重新授权
   - 用户体验差

2. **API 兼容性**
   - Accessibility API 不是所有应用都完全支持
   - 需要处理各种边界情况

3. **编译环境依赖**
   - 依赖 Xcode Command Line Tools
   - 环境问题影响开发效率

## 参考项目

- [Bartender](https://www.macbartender.com/) - 商业产品，功能完善
- [Hidden Bar](https://github.com/dwarvesf/hidden) - 开源替代品
- [Dozer](https://github.com/Mortennn/Dozer) - 简化版实现
