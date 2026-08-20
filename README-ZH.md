# BL Lock Environment

## 一、模块介绍

### 1.1 模块目的

BL Lock Environment 是一个 Android Property Environment 模拟模块。

本模块通过 `resetprop` 修改 Android userspace
中可读取的系统属性，使已经解锁 Bootloader 的设备，在 Android
系统层面表现为：

-   Bootloader Locked
-   Verified Boot Green
-   Production Build

适用于：

-   Magisk Root 环境
-   KernelSU Root 环境
-   Custom ROM 环境
-   官方 ROM 解锁 Bootloader 环境

### 1.2 模块定位

本模块只负责：

-   Bootloader 状态属性模拟
-   AVB / Verified Boot 状态模拟
-   Build 身份模拟
-   Security 环境模拟
-   OEM 锁状态模拟
-   部分厂商 Boot 状态属性模拟

本模块不负责：

-   重新锁定真实 Bootloader
-   修改 Bootloader 分区
-   修改 vbmeta 分区
-   修改 TEE
-   修改 Key Attestation
-   修改 Play Integrity
-   修改 Keybox

------------------------------------------------------------------------

# 二、工作原理

## 2.1 Android 属性机制

Android 启动过程中：

Bootloader

↓

Kernel

↓

init

↓

Property Service

↓

Framework / Application

设备真实状态会通过 `ro.boot.*`、`ro.build.*` 等 Property 暴露给
Android。

例如：

解锁设备：

    ro.boot.flash.locked=0

    ro.boot.verifiedbootstate=orange

    ro.build.tags=test-keys

模块运行后：

    ro.boot.flash.locked=1

    ro.boot.verifiedbootstate=green

    ro.build.tags=release-keys

Android userspace 读取到的是修改后的结果。

------------------------------------------------------------------------

## 2.2 修改方式

模块使用：

    resetprop

修改 Android 运行时 Property。

执行阶段：

    Magisk/KSU service阶段

    ↓

    读取配置文件

    ↓

    备份原始值

    ↓

    检测当前值

    ↓

    执行Property修改

    ↓

    记录日志

------------------------------------------------------------------------

# 三、模块结构

    BL-Lock-Environment/

    ├── module.prop

    ├── service.sh

    ├── config/

    │   └── bl_lock.conf

    ├── scripts/

    │   ├── audit_props.sh

    │   ├── apply_props.sh

    │   ├── backup_props.sh

    │   └── restore_props.sh

    └── README-ZH.md

------------------------------------------------------------------------

# 四、配置文件说明

配置文件：

    config/bl_lock.conf

格式：

    property=value

每个参数下面包含中文注释：

例如：

    ro.boot.flash.locked=1

    # Bootloader锁定状态属性。
    #
    # 解锁设备通常：
    # ro.boot.flash.locked=0
    #
    # 修改后：
    # Android userspace读取结果显示Bootloader已锁定。
    #
    # 注意：
    # 不会真正重新锁定Bootloader。

------------------------------------------------------------------------

# 五、属性详细说明

## 5.1 Bootloader / AVB 属性

## ro.boot.flash.locked

配置：

    ro.boot.flash.locked=1

说明：

Bootloader 锁定状态属性。

常见值：

    0:
    Bootloader unlocked


    1:
    Bootloader locked

模块作用：

让 Android userspace 判断 Bootloader 为 locked。

不会影响：

-   fastboot真实状态
-   Bootloader硬件状态

------------------------------------------------------------------------

## ro.boot.vbmeta.device_state

配置：

    ro.boot.vbmeta.device_state=locked

说明：

AVB vbmeta 设备状态。

常见值：

    unlocked:
    Bootloader解锁


    locked:
    Bootloader锁定

模块作用：

模拟 AVB locked 环境。

不会修改：

-   vbmeta分区
-   AVB签名

------------------------------------------------------------------------

## ro.boot.verifiedbootstate

配置：

    ro.boot.verifiedbootstate=green

说明：

Verified Boot 验证状态。

常见状态：

    green:
    验证通过


    yellow:
    用户Key


    orange:
    Bootloader解锁


    red:
    验证失败

模块作用：

模拟 Verified Boot 正常状态。

------------------------------------------------------------------------

# 六、Build Identity 属性

## ro.build.type

配置：

    ro.build.type=user

说明：

Android Build 类型。

常见值：

    eng:
    工程版本


    userdebug:
    调试版本


    user:
    正式版本

作用：

模拟正式商业系统。

------------------------------------------------------------------------

## ro.build.tags

配置：

    ro.build.tags=release-keys

说明：

Android Build 签名标签。

常见值：

    test-keys:
    测试编译


    release-keys:
    正式发布

作用：

模拟厂商正式系统签名环境。

------------------------------------------------------------------------

# 七、安全环境属性

## ro.debuggable

配置：

    ro.debuggable=0

说明：

Android Debug 状态。

    1:
    调试模式


    0:
    正式模式

作用：

模拟 Production Build。

------------------------------------------------------------------------

## ro.secure

配置：

    ro.secure=1

说明：

Android 安全模式标识。

作用：

模拟正式系统安全状态。

------------------------------------------------------------------------

# 八、安装检测说明

安装时模块会检测每个目标属性。

显示格式：

    ro.boot.flash.locked
    说明：Bootloader锁定状态
    当前值：0
    配置值：1
    动作：MODIFY

动作说明：

## MODIFY

当前值与配置值不同。

模块将执行修改。

## KEEP

当前值已经符合配置。

无需修改。

## SKIP

属性不存在或者设备不适用。

------------------------------------------------------------------------

# 九、备份与恢复

模块首次运行会保存原始 Property。

保存位置：

    /data/adb/bl_lock_env/

用途：

-   卸载模块恢复
-   问题排查
-   查看修改前状态

------------------------------------------------------------------------

# 十、兼容性设计

模块采用通用 Property 处理方式。

对于不存在的厂商属性：

自动跳过。

例如：

Xiaomi 专用：

    ro.secureboot.lockstate

如果设备不存在：

不会强制创建。

------------------------------------------------------------------------

# 十一、限制说明

本模块属于：

userspace Property Simulation。

它可以改变：

Android读取结果。

它不能改变：

-   Bootloader真实锁定状态
-   Fastboot显示状态
-   硬件Fuse状态
-   TEE状态
-   Key Attestation结果


# Phase 3 Revision 2

增加属性检测说明解析、修改结果验证、备份恢复安全判断。


# 配置文件分类结构

config/bl_lock.conf 按以下区域组织：

1. Bootloader / AVB Environment

2. Build Identity

3. Security Environment

4. OEM Unlock State

5. Warranty / Tamper State

6. OEM Specific

配置文件中每个属性后紧跟中文说明。


# Phase 3 Revision 4

本阶段增加：

- Bootloader / AVB 属性分类完善；
- Vendor AVB 属性说明；
- Security 属性说明完善；
- 配置文件分区结构说明。


# Phase 3 Revision 5

本阶段增加：

- 安装检测分类显示；
- apply.log时间记录；
- backup.log备份记录；
- 配置分类与输出结构关联。


# Phase 3 Revision 6

本阶段增加：

- 运行日志目录预留；
- logs目录结构；
- 运行时日志文件说明。

模块包内仅保留空日志目录占位文件，
实际日志文件由模块运行后生成。


# Phase 3 Revision 7

本阶段增加：

- 安装阶段五步流程；
- verify_props.sh验证脚本；
- summary.sh安装结果统计；
- customize.sh安装界面流程。


# Phase 3 Revision 8

本阶段增加：

- 环境检查脚本；
- 卸载恢复日志；
- 恢复流程保护；
- 安装前置检查。


# Phase 4 Revision 1

本阶段增加：

- Root环境检测；
- Magisk / KernelSU / APatch环境识别；
- Property操作抽象层；
- 后续兼容扩展基础。
