# Flutter 登录系统

这个Flutter应用现在包含了一个完整的登录系统，具有以下功能：

## 功能特性

### 1. 登录页面 (`lib/screens/login_screen.dart`)
- 用户名和密码输入框
- "记住当前用户"选项
- 登录验证和错误提示
- 美观的UI设计

### 2. 用户认证服务 (`lib/services/auth_service.dart`)
- 使用 `flutter_secure_storage` 安全存储用户信息
- 支持记住用户功能
- 登录状态管理
- 登出功能

### 3. 主页面导航 (`lib/screens/main_navigation_screen.dart`)
- 底部导航栏，包含4个页面
- 页面切换功能
- 保持页面状态

### 4. 各个页面
- **首页** (`lib/screens/home_page.dart`): 显示欢迎信息、计数器和功能按钮
- **测试页面** (`lib/screens/screen_test.dart`): 原有的测试功能（电话拨打）
- **个人页面** (`lib/screens/profile_page.dart`): 用户信息显示和设置
- **设置页面** (`lib/screens/settings_page.dart`): 应用设置和配置

## 使用方法

1. **启动应用**: 应用会自动检查登录状态
2. **首次使用**: 显示登录页面
3. **登录**: 输入任意用户名和密码即可登录
4. **记住用户**: 勾选"记住当前用户"选项，下次启动会自动填充用户名和密码
5. **页面导航**: 登录后可以通过底部导航栏切换不同页面
6. **退出登录**: 在个人页面点击"退出登录"按钮

## 技术实现

- **状态管理**: 使用Flutter内置的StatefulWidget
- **数据存储**: 使用flutter_secure_storage进行安全存储
- **导航**: 使用Navigator进行页面跳转
- **UI组件**: 使用Material Design组件

## 项目结构

```
lib/
├── main.dart                          # 应用入口
├── services/
│   └── auth_service.dart              # 用户认证服务
└── screens/
    ├── login_screen.dart              # 登录页面
    ├── main_navigation_screen.dart    # 主导航页面
    ├── home_page.dart                 # 首页
    ├── profile_page.dart              # 个人页面
    ├── settings_page.dart             # 设置页面
    └── screen_test.dart               # 测试页面
```

## 运行应用

```bash
flutter run
```

应用会自动检查登录状态，未登录时显示登录页面，已登录时直接进入主页面。
