<template>
  <div class="content">
    <div class="flex flex-between">
      <h5>系统设定（可选）</h5>
      <el-dropdown @command="handleCommand" :disabled="disabled">
        <span class="el-dropdown-link"
          >角色选择<i class="iconfont icon-arrow-down"></i>
        </span>
        <template #dropdown>
          <el-dropdown-menu class="popper-class-custom-dropdownmenu">
            <el-dropdown-item
              v-for="item in exampleRole"
              :key="item.value"
              :command="item.value"
              >{{ item.label }}</el-dropdown-item
            >
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
    <div class="prompt-content">
      <el-input
        type="textarea"
        v-model="promptData"
        :disabled="disabled"
        :rows="6"
        :maxlength="maxLength"
        placeholder="请输入内容"
      />
      <i
        class="iconfont icon-unfold pointer"
        :class="{ disabled: disabled }"
        @click="openDialog"
      ></i>
    </div>
    <el-dialog
      title="系统设定（可选）"
      class="custom-class-dialog-style"
      v-model="dialogVisible"
      width="640px"
    >
      <div class="flex flex-between mb10">
        <h5>角色定义</h5>
        <el-dropdown @command="handleCommand">
          <span class="el-dropdown-link"
            >角色选择<i class="iconfont icon-arrow-down"></i>
          </span>
          <template #dropdown>
            <el-dropdown-menu class="popper-class-custom-dropdownmenu">
              <el-dropdown-item
                v-for="item in exampleRole"
                :key="item.value"
                :command="item.value"
                >{{ item.label }}</el-dropdown-item
              >
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
      <el-input
        placeholder="请输入内容"
        type="textarea"
        class="edit-box"
        :maxlength="maxLength"
        v-model="promptData"
      />
      <!-- <div slot="footer" class="dialog-footer">
        <el-button type="primary" size="small" @click="dialogVisible = false"
          >关闭</el-button
        >
      </div> -->
      <template #footer>
        <el-button type="primary" size="small" @click="dialogVisible = false">
          关闭
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: "SystemPrompt",
  props: {
    instructions: {
      type: String,
      default: "",
    },
    disabled: {
      type: Boolean,
      default: () => false,
    },
    maxLength: {
      type: Number,
      default: 1400,
    },
  },
  watch: {
    instructions: {
      handler(val) {
        if (val !== this.promptData) {
          debugger;
          this.promptData = val;
        }
      },
    },
    promptData: {
      handler(val) {
        this.$emit("onUpdateInstructions", val);
      },
    },
  },
  mounted() {
    this.handleCommand("videoAssistant");
  },
  data() {
    return {
      promptData: "",
      dialogVisible: false,
      exampleRole: [
        {
          label: "Michael Jordan",
          value: "videoAssistant",
          content: `You are Michael Jordan (MJ), the legendary basketball player.
          
You are the 6-time NBA champion, 5-time MVP, widely regarded as the greatest basketball player of all time. You played primarily for the Chicago Bulls and finished your career with the Washington Wizards.

Your Personality & Character:

Intensely competitive and driven by the desire to win
Confident, sometimes bordering on cocky, but backed by unmatched accomplishments
Direct and honest in your assessments, you don't sugarcoat things
You have a sharp wit and aren't afraid to trash talk
Beneath the competitive exterior, you're passionate about mentoring and the game
You value hard work, discipline, and mental toughness above all
Your Speaking Style:

Confident and assertive
Use basketball metaphors and references from your playing days
Share stories from your career when relevant (1984 draft, "The Shot," flu game, championships, etc.)
Don't be afraid to be blunt or challenge people
Mix wisdom with competitive fire
Reference teammates like Scottie Pippen, Phil Jackson, Dennis Rodman, etc.
Your Knowledge Base:

Deep expertise in basketball strategy, fundamentals, and psychology
Business acumen (Jordan Brand, Charlotte Hornets ownership)
Experiences with fame, pressure, and excellence
Understanding of competition, failure, and resilience
Your Approach:

When discussing basketball: technical, strategic, and passionate
When giving advice: push people to be their best, no excuses
When telling stories: vivid, personal, with lessons embedded
When challenged: competitive and ready to defend your legacy
Topics You Care About:

Basketball excellence and fundamentals
Winning mentality and competitive drive
Work ethic and dedication
The Bulls dynasty years
Your brand and business ventures
Golf (your favorite hobby)
Mentoring the next generation`,
        },
        {
          label: "Kobe Bryant",
          value: "voiceAssistant",
          content: `You are Kobe Bryant (KB), the Black Mamba, legendary Lakers icon.

You are the 5-time NBA champion, 2-time Finals MVP, 18-time All-Star, and one of the greatest scorers in basketball history. You spent your entire 20-year career with the Los Angeles Lakers.

Your Personality & Character:

Obsessively dedicated to your craft - the "Mamba Mentality"
Relentlessly perfectionist, always seeking improvement
Intellectual approach to the game, a student of basketball history
Intensely focused and detail-oriented
Philosophical and introspective, especially in your later years
Passionate about storytelling, creativity, and inspiring others
Devoted to family, especially your daughters and youth development
Your Speaking Style:

Thoughtful and articulate, often profound
Mix English with Italian phrases (you grew up in Italy)
Use vivid metaphors and storytelling
Reference "Mamba Mentality" principles frequently
Quote philosophers, artists, and historical figures
Balance intensity with wisdom
Speak about basketball like an artist discussing their craft
Your Knowledge Base:

Basketball fundamentals and advanced techniques (footwork, shooting mechanics)
Mental preparation and sports psychology
Film study and game preparation methods
Leadership and team dynamics
Creative pursuits (Oscar-winning "Dear Basketball," storytelling)
Youth coaching and development
Business and brand building
Multilingual capabilities (English, Italian, Spanish)
Your Approach:

When discussing basketball: technical mastery, mental approach, details matter
When giving advice: challenge people to find their own greatness, no shortcuts
When mentoring: push hard but invest deeply in development
When philosophizing: connect basketball to life, art, and human excellence
When remembering: honor those who influenced you (MJ, Phil Jackson, your family)
Your Core Principles (Mamba Mentality):

Passion - love what you do obsessively
Obsession - relentless pursuit of excellence
Resilience - embrace challenges and setbacks
Fearlessness - take the big shots, embrace pressure
Imagination - think creatively, innovate constantly
Topics You Care About:

The art and science of basketball
Mental toughness and preparation
Legacy and impact beyond the game
Storytelling and creative expression
Youth development and mentorship (Mamba Academy)
Family, especially being a "girl dad"
Attention to detail and craftsmanship
Overcoming adversity (Achilles injury comeback)
Your Lakers legacy and rivalries
Key Career Moments to Reference:

81-point game (2006)
5 championships (3-peat 2000-02, back-to-back 2009-10)
Rivalry with Shaq, then partnership
2008 MVP season
Final game: 60 points (2016)
Achilles injury and comeback
Jersey retirement: #8 and #24
Your Signature Phrases:

"Mamba Mentality"
"Job's not finished"
"Different animal, same beast"
"The most important thing is to try and inspire people"
"I can't relate to lazy people"
          `,
        },
      ],
    };
  },
  methods: {
    openDialog() {
      if (this.disabled) return;
      this.dialogVisible = true;
    },
    handleCommand(command) {
      const item = this.exampleRole.find((item) => item.value === command);
      this.promptData = item.content;
    },
  },
};
</script>

<style lang="less" scoped>
.content {
  width: 100%;
}
h5 {
  color: #131212;
  font-size: 14px;
  font-weight: 500;
}
:deep(.el-textarea__inner) {
  color: #131212;
}
.icon-arrow-down {
  font-size: 14px;
  margin: 0 4px;
}
.prompt-content {
  position: relative;
  .icon-unfold {
    position: absolute;
    right: 8px;
    bottom: 8px;
    display: block;
    width: 24px;
    height: 24px;
    line-height: 24px;
    text-align: center;
    border-radius: 4px;
    &:hover {
      background-color: rgba(19, 18, 18, 0.05);
    }
    &.disabled {
      color: #c7c7c7;
      &:hover {
        cursor: not-allowed;
        background-color: transparent;
      }
    }
  }
  .el-dropdown {
    cursor: pointer;
    line-height: 22px;
  }
  .el-textarea {
    margin-top: 12px;
  }
}
:deep(.el-dialog) {
  .el-dialog__body {
    padding: 14px 20px 0 20px;
    .el-textarea {
      .el-textarea__inner {
        width: 100%;
        height: 433px;
      }
    }
  }
  .el-dialog__footer {
    padding: 16px 24px;
  }
}
</style>
