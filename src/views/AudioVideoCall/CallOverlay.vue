<template>
  <transition name="call-overlay-fade">
    <div v-if="visible" class="call-overlay">
      <div class="call-overlay__main">
        <div class="call-overlay__avatar">
          <span class="call-overlay__avatar-ring"></span>
          <i :class="['iconfont', typeIcon]"></i>
        </div>
        <div class="call-overlay__type">{{ callTypeLabel }}</div>
        <div class="call-overlay__status">{{ statusDescription }}</div>
        <div v-if="showTimer" class="call-overlay__timer">{{ formattedDuration }}</div>
        <div class="call-overlay__wave">
          <span v-for="bar in 6" :key="bar" :style="{ animationDelay: `${bar * 0.1}s` }"></span>
        </div>
      </div>
      <div class="call-overlay__actions">
        <button
          class="call-overlay__control"
          type="button"
          :class="{ active: enableAudio }"
          @click="handleToggleAudio"
        >
          <i :class="['iconfont', enableAudio ? 'icon-voice1' : 'icon-microphone_closed']"></i>
        </button>
        <button
          v-if="showVideoControl"
          class="call-overlay__control"
          type="button"
          :class="{ active: enableVideo }"
          @click="$emit('onToggleVideo')"
        >
          <i :class="['iconfont', videoIcon]"></i>
        </button>
        <button class="call-overlay__hangup" type="button" @click="$emit('onHangUp')">
          <i class="iconfont icon-disconnect"></i>
        </button>
      </div>
    </div>
  </transition>
</template>

<script>
import { MEDIA_TYPE } from "@/constants/modules/audioVideoCall";

export default {
  name: "CallOverlay",
  props: {
    visible: {
      type: Boolean,
      default: false,
    },
    callType: {
      type: String,
      default: MEDIA_TYPE.AUDIO,
    },
    status: {
      type: String,
      default: "idle",
    },
    duration: {
      type: Number,
      default: 0,
    },
    enableAudio: {
      type: Boolean,
      default: false,
    },
    enableVideo: {
      type: Boolean,
      default: false,
    },
    isConnected: {
      type: Boolean,
      default: false,
    },
  },
  emits: ["onHangUp", "onToggleAudio", "onToggleVideo"],
  watch: {
    enableAudio(newVal) {
      console.log('CallOverlay: enableAudio changed to:', newVal);
    },
    enableVideo(newVal) {
      console.log('CallOverlay: enableVideo changed to:', newVal);
    },
  },
  computed: {
    typeIcon() {
      switch (this.callType) {
        case MEDIA_TYPE.VIDEO:
          return "icon-videocall";
        case MEDIA_TYPE.SCREEN:
          return "icon-sharecall";
        default:
          return "icon-voicecall";
      }
    },
    callTypeLabel() {
      switch (this.callType) {
        case MEDIA_TYPE.VIDEO:
          return "视频通话";
        case MEDIA_TYPE.SCREEN:
          return "屏幕共享";
        default:
          return "语音通话";
      }
    },
    statusDescription() {
      if (this.status === "connecting") {
        return "正在连接...";
      }
      if (this.status === "connected") {
        return this.isConnected ? "通话中" : "通话中...";
      }
      return "准备通话";
    },
    showTimer() {
      return this.status === "connected";
    },
    formattedDuration() {
      return this.formatDuration(this.duration);
    },
    showVideoControl() {
      return this.callType !== MEDIA_TYPE.AUDIO;
    },
    videoIcon() {
      if (this.enableVideo) {
        return this.callType === MEDIA_TYPE.SCREEN ? "icon-sharecall" : "icon-video1";
      }
      return this.callType === MEDIA_TYPE.SCREEN ? "icon-sharecall" : "icon-camera_closed";
    },
  },
  methods: {
    formatDuration(seconds) {
      const safeSeconds = Number.isFinite(seconds) ? seconds : 0;
      const mins = Math.floor(safeSeconds / 60)
        .toString()
        .padStart(2, "0");
      const secs = Math.floor(safeSeconds % 60)
        .toString()
        .padStart(2, "0");
      return `${mins}:${secs}`;
    },
    handleToggleAudio() {
      console.log('CallOverlay: toggleAudio clicked, current enableAudio:', this.enableAudio);
      this.$emit('onToggleAudio');
    },
  },
};
</script>

<style scoped lang="less">
.call-overlay-fade-enter-active,
.call-overlay-fade-leave-active {
  transition: opacity 0.3s ease;
}

.call-overlay-fade-enter-from,
.call-overlay-fade-leave-to {
  opacity: 0;
}

.call-overlay {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 1000;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 48px 24px;
  background: linear-gradient(180deg, #1f2958 0%, #0d152f 100%);
  color: #fff;
}

.call-overlay__main {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 12px;
}

.call-overlay__avatar {
  position: relative;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  background: rgba(255, 255, 255, 0.1);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48px;
}

.call-overlay__avatar-ring {
  position: absolute;
  top: -12px;
  right: -12px;
  bottom: -12px;
  left: -12px;
  border-radius: 50%;
  border: 1px solid rgba(255, 255, 255, 0.22);
  animation: call-overlay-pulse 2.4s ease-in-out infinite;
}

@keyframes call-overlay-pulse {
  0% {
    transform: scale(0.95);
    opacity: 0.4;
  }
  50% {
    transform: scale(1.05);
    opacity: 1;
  }
  100% {
    transform: scale(0.95);
    opacity: 0.4;
  }
}

.call-overlay__type {
  font-size: 18px;
  font-weight: 600;
}

.call-overlay__status {
  font-size: 16px;
  color: rgba(255, 255, 255, 0.8);
}

.call-overlay__timer {
  font-size: 24px;
  font-variant-numeric: tabular-nums;
  letter-spacing: 1px;
}

.call-overlay__wave {
  display: flex;
  align-items: flex-end;
  justify-content: center;
  gap: 6px;
  height: 48px;
  margin-top: 8px;
}

.call-overlay__wave span {
  display: block;
  width: 6px;
  height: 20px;
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.35);
  animation: call-overlay-bar 1.2s ease-in-out infinite;
}

@keyframes call-overlay-bar {
  0%,
  100% {
    transform: scaleY(0.4);
  }
  50% {
    transform: scaleY(1.1);
  }
}

.call-overlay__actions {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 48px;
}

.call-overlay__control {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  border: none;
  background: rgba(255, 255, 255, 0.15);
  color: #fff;
  font-size: 28px;
  cursor: pointer;
  transition: background 0.2s ease;
}

.call-overlay__control.active {
  background: rgba(255, 255, 255, 0.35);
}

.call-overlay__control:hover {
  background: rgba(255, 255, 255, 0.25);
}

.call-overlay__hangup {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  border: none;
  background: #ff4d4f;
  color: #fff;
  font-size: 28px;
  cursor: pointer;
  box-shadow: 0 12px 24px rgba(255, 77, 79, 0.35);
  transition: transform 0.2s ease;
}

.call-overlay__hangup:hover {
  transform: scale(1.05);
}

@media screen and (max-width: 768px) {
  .call-overlay {
    padding: 24px 16px 32px;
  }

  .call-overlay__actions {
    gap: 16px;
  }

  .call-overlay__control {
    width: 56px;
    height: 56px;
    font-size: 24px;
  }

  .call-overlay__hangup {
    width: 56px;
    height: 56px;
    font-size: 24px;
  }
}
</style>
