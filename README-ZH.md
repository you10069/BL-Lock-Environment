# BL Lock Environment

## 模块说明

本模块通过 resetprop 修改 Android userspace property，
模拟 Bootloader Locked / Verified Boot Green / Production Build 环境。

## 限制

不会：
- 重新锁定真实 Bootloader
- 修改 AVB/vbmeta 分区
- 修改 TEE
- 修改 Key Attestation

## 工作方式

启动阶段读取配置文件，
检测当前property，
显示当前值和配置值，
然后执行修改。
