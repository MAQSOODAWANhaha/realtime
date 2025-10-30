# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是智谱AI Realtime API的前端应用样例，实现了三种交互形态：语音、语音视频、语音屏幕。项目基于Vue 3 + Vite + Element Plus构建，专注于实时音视频交互体验。

## 常用开发命令

```bash
# 安装依赖
pnpm install

# 开发服务器（默认端口5173）
pnpm run dev

# 生产构建
pnpm run build:prod

# 预览构建结果
pnpm run preview

# 多环境构建
pnpm run build:stage  # 预发布环境
pnpm run build:pre    # 生产预发布环境
pnpm run build:prod   # 生产环境
```

## 核心架构

### 音视频处理架构
- **SoundVadClass** (`src/utils/soundVad.js`) - 核心语音活动检测实现
  - 支持客户端和服务端两种VAD模式
  - 实时音频数据缓存和PCM到WAV转换
  - 自适应阈值算法，支持不同环境噪声
  - 基于Web Audio API的毫秒级响应

### 实时通信架构
- **WebSocket** - 实时音视频数据传输
- **HTTP** - 配置获取和模型调用
- **流式处理** - FixedQueue队列避免内存溢出

### 组件化架构
- **容器组件** - 管理状态和业务逻辑（如 `AudioVideoCall/Index.vue`）
- **展示组件** - 负责UI展示（如 `AudioBox.vue`, `VideoBox.vue`）
- **工具组件** - 可复用功能组件（如 `Loading.vue`, `OutputAudio.vue`）

### 状态管理
- **mitt事件总线** (`src/utils/event.js`) - 组件间通信
- **Vue 3响应式** - ref/reactive状态管理
- **Props/Emits** - 父子组件通信

## 重要配置文件

### 常量管理
- `src/constants/index.js` - 动态导入合并所有常量模块
- `src/constants/modules/audioVideoCall.js` - 音视频相关常量

### 构建配置
- `vite.config.js` - Vite构建配置，支持多环境构建
- `package.json` - 项目依赖和脚本配置

## 关键技术特点

### 语音活动检测(VAD)
- 实时监听音频流变化
- 智能阈值调整机制
- 支持多种音频格式处理
- 优化的音频缓冲区管理

### 多模态交互
- **语音模式** - 纯音频交互
- **视频模式** - 音频+视频交互
- **屏幕模式** - 音频+屏幕共享交互

### 性能优化
- Web Audio资源及时释放
- 音频数据智能缓存
- 组件懒加载
- ES模块tree-shaking

## 开发注意事项

### 音频处理
- 使用 `src/utils/soundVad.js` 中的 `SoundVadClass` 进行语音活动检测
- 注意及时释放Web Audio API资源避免内存泄漏
- 音频流处理使用 `FixedQueue` 控制内存使用

### 组件开发
- 遵循Vue 3组合式API最佳实践
- 使用TypeScript类型注解（虽然当前是JS项目）
- 组件职责分离，保持单一职责原则

### 事件处理
- 使用 `src/utils/event.js` 事件总线进行组件间通信
- 避免直接操作DOM，优先使用Vue响应式系统

### 样式管理
- 使用Less预处理器，样式文件位于 `src/assets/style/`
- 遵循BEM命名规范
- 全局样式在 `global.less` 中定义

## 核心文件说明

- `src/utils/soundVad.js` - 核心VAD算法实现，包含音频分析和检测逻辑
- `src/utils/stream.js` - 流数据处理工具
- `src/components/ModelParams/` - 模型参数配置组件
- `src/views/AudioVideoCall/Index.vue` - 主要交互页面
- `src/constants/modules/audioVideoCall.js` - 音视频相关配置常量