# POCO F8 Pro (annibale) Android 17 / uwuAOSP 补丁清单与交付说明

本补丁集汇总了自底座搭建以来为适配 `annibale`（Xiaomi 15 系列 / SM8750）在 Android 17 (uwuAOSP 17.0 / LineageOS 24.0) 上所研发的所有修复与功能补丁。

---

## 补丁分类与保留建议

| 编号 | 补丁文件名 | 作用目标仓库 | 核心功能说明 | 建议保留属性 |
| :--- | :--- | :--- | :--- | :--- |
| **01** | `01-fix-sepolicy-duplicate-qcom-battery.patch` | `device/qcom/sepolicy_vndr/sm8750` | 修复高通平台与设备树重复定义 `/sys/class/qcom-battery` 导致的 SELinux 冲突 | **必须保留**（基础编译修复） |
| **02** | `02-fix-16k-pagesize-protobuf-prebuilts.patch` | `hardware/lineage/compat` | 修复兼容层旧版 protobuf 预编译动态库在 16KB 页对齐检查时的 ELF 报错 | **必须保留**（基础编译修复） |
| **05** | `05-fix-virt-missing-bootloader-prebuilts.patch` | `packages/modules/Virtualization` | 修复 AOSP 虚拟化模块缺少对应体系 bootloader 预编译依赖导致的构建中断 | **必须保留**（系统模块构建） |
| **07** | `07-fix-build-broken-missing-required-modules.patch` | `device/xiaomi/annibale` | 移除设备树中引用的冗余/废弃模块定义，防止 Kati 阶段强校验失败 | **必须保留**（设备树必要修复） |
| **08** | `08-enable-wechat-alipay-fingerprint-payment.patch` | `device/xiaomi/annibale` | 启用微信 Soter 与支付宝 IFAA 指纹底层属性及初始 sepolicy 权限 | **可并入 11**（提供 persist.vendor.sys.pay.* 属性声明） |
| **09** | `09-vendor-import-soterservice.patch` | `vendor/xiaomi/annibale` | 在 vendor 蓝图中引入微信支付核心预编译服务 `SoterService.apk` | **必须保留**（微信指纹支付必要组件） |
| **10** | `10-hardware-lineage-compat-16k.patch` | `hardware/lineage/compat` | 补充 protobuf 21.12 等多库的 `ignore_max_page_size: true`，彻底消除 16KB ELF 校验阻断 | **必须保留**（消除 16K ELF 阻断） |
| **11** | `11-ifaa-official-aidl-and-sepolicy.patch` | `hardware/xiaomi/packages/IFAAService`<br>`vendor/xiaomi/annibale`<br>`device/xiaomi/annibale` | 导入 HyperOS 官方 AIDL 原厂 `IFAAService.apk`，并赋予 `platform_app_36` 和 `system_app` 访问 `hal_mlipay_service` 权限 | **必须保留**（支付宝指纹支付核心闭环） |
| **12** | `12-status-bar-double-tap-to-sleep.patch` | `frameworks/base`<br>`packages/apps/Settings` | 在 `PhoneStatusBarView.java` 中原生实现双击手势捕获直通电源管理，并将设置默认值设为开启 | **强烈推荐保留**（核心 UX 体验修复） |
| **13** | `13-enable-dolby-atmos.patch` | `device/xiaomi/annibale` | 在 `device.mk` 中解开 `DolbyAtmos` 控制面板包定义 | **强烈推荐保留**（杜比音效 UI 载体） |
| **14** | `14-fix-bt-audio-drop-and-live-caption.patch` | `device/xiaomi/annibale` | 1. 设置 `aaudio.mmap_policy=1` 避免游戏独占 MMAP 句柄崩溃<br>2. 挂载 Google 实时字幕（Live Caption）核心服务 overlay | **强烈推荐保留**（音频稳定与实时字幕） |

---

## 依赖的私有预编译 APK

本补丁集中有两项支付功能依赖从官方 HyperOS 固件提取的私有签名 APK：
1. **`SoterService.apk`**（微信指纹支付服务）：
   - 目标路径：`vendor/xiaomi/annibale/proprietary/product/app/SoterService/SoterService.apk`
   - 配套补丁：`09-vendor-import-soterservice.patch`
2. **`IFAAService.apk`**（官方 AIDL 支付宝/淘宝指纹支付服务）：
   - 目标路径：`vendor/xiaomi/annibale/proprietary/product/app/IFAAService/IFAAService.apk`
   - 配套补丁：`11-ifaa-official-aidl-and-sepolicy.patch`

---

## 针对外部开发者的合入建议（合并与精简版）

如果交付给其他维护者或直接向上游 LineageOS / 设备树提 PR，建议按以下逻辑拆分为 4 个干净的 Topic 提交：
1. **基础构建修复组**：补丁 01, 02, 05, 07, 10（直接消除编译断点与 16K ELF 报错）。
2. **生物识别双支付组**：补丁 08, 09, 11 + 配套两个 APK（解决国内微信与支付宝指纹支付）。
3. **系统交互与音效组**：补丁 12, 13（双击状态栏锁屏与杜比音效）。
4. **音频稳定与特性组**：补丁 14（游戏切后台音频管道安全回退与实时字幕）。
