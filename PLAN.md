# NotchFix 项目规划

## 核心功能

### MVP (最小可行产品)
1. **菜单栏图标检测** - 识别当前所有菜单栏图标
2. **图标隐藏/显示** - 允许用户选择隐藏特定图标
3. **"更多"按钮** - 在菜单栏显示一个按钮，点击展开隐藏的图标列表
4. **配置持久化** - 保存用户的隐藏配置

### 后续功能
- 图标拖拽排序
- 快捷键支持
- 自动隐藏规则（根据应用使用频率）
- 主题定制

## 技术方案

### 1. 菜单栏图标检测
**挑战**: macOS 不提供直接 API 获取其他应用的菜单栏图标

**方案**:
- 使用 `NSStatusBar` 管理自己的图标
- 通过 Accessibility API 检测其他应用的菜单栏项
- 需要用户授予辅助功能权限

**关键 API**:
```swift
// 获取菜单栏区域
AXUIElementCreateSystemWide()
AXUIElementCopyAttributeValue(element, kAXChildrenAttribute, ...)

// 过滤菜单栏项
kAXMenuBarRole
```

### 2. 图标隐藏机制
**方案 A**: 通过 Accessibility API 操作其他应用的菜单栏项
- 优点: 真正隐藏图标，释放空间
- 缺点: 需要深度权限，可能不稳定

**方案 B**: 创建遮罩层覆盖图标
- 优点: 实现简单
- 缺点: 图标仍占用空间，治标不治本

**推荐**: 先实现方案 A，如果遇到技术障碍再降级到方案 B

### 3. "更多"按钮
使用 `NSStatusItem` 创建菜单栏按钮:
```swift
let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
statusItem.button?.image = NSImage(systemSymbolName: "ellipsis.circle", accessibilityDescription: "More")
```

点击后显示 `NSMenu` 或 `NSPopover`，列出隐藏的图标

### 4. 配置存储
使用 `UserDefaults` 或 JSON 文件存储:
```swift
struct Config: Codable {
    var hiddenApps: [String] // Bundle identifiers
    var iconOrder: [String]
}
```

## 项目结构

```
NotchFix/
├── NotchFix.xcodeproj
├── NotchFix/
│   ├── App/
│   │   ├── NotchFixApp.swift          # App 入口
│   │   └── AppDelegate.swift          # 菜单栏管理
│   ├── Views/
│   │   ├── SettingsView.swift         # 设置界面
│   │   └── IconListView.swift         # 图标列表
│   ├── Models/
│   │   ├── MenuBarIcon.swift          # 图标数据模型
│   │   └── Config.swift               # 配置模型
│   ├── Services/
│   │   ├── MenuBarScanner.swift       # 扫描菜单栏图标
│   │   ├── IconManager.swift          # 隐藏/显示逻辑
│   │   └── ConfigManager.swift        # 配置读写
│   └── Resources/
│       └── Assets.xcassets
├── README.md
├── PLAN.md
└── .gitignore
```

## 开发路线图

### Phase 1: 基础框架 (1-2 天)
- [x] 创建 Xcode 项目
- [ ] 实现菜单栏按钮
- [ ] 创建设置窗口
- [ ] 配置权限请求（Accessibility）

### Phase 2: 核心功能 (3-5 天)
- [ ] 实现菜单栏图标扫描
- [ ] 实现图标隐藏/显示
- [ ] 实现"更多"菜单
- [ ] 配置持久化

### Phase 3: 优化 (2-3 天)
- [ ] UI 优化
- [ ] 性能优化
- [ ] 错误处理
- [ ] 用户引导

### Phase 4: 发布 (1-2 天)
- [ ] 打包签名
- [ ] 编写文档
- [ ] 发布到 GitHub

## 技术难点

### 1. Accessibility API 权限
- 需要用户手动授予
- 提供清晰的引导流程

### 2. 菜单栏图标识别
- 不同应用的图标结构可能不同
- 需要兼容性测试

### 3. 图标隐藏的稳定性
- macOS 系统更新可能影响 API
- 需要版本兼容性处理

## 参考项目

- [Bartender](https://www.macbartender.com/) - 商业产品，功能完善
- [Hidden Bar](https://github.com/dwarvesf/hidden) - 开源替代品
- [Dozer](https://github.com/Mortennn/Dozer) - 简化版实现

## 下一步

1. 创建 Xcode 项目
2. 实现基础的菜单栏按钮
3. 测试 Accessibility API 可行性
