---
name: unit-test-report
description: 为某个功能生成“AI 先筛问题、人工再聚焦确认”的测试审查报告。适用于用户要求“review 这批 unit/integration test 的质量与覆盖”“输出 test review report 并标出人工重点”“把测试审查结果写成 Obsidian 友好的 Markdown 文档”“为复杂测试逻辑补 Mermaid / JSON Canvas 可视化”等场景。
---

# Unit Test Report

## 用法

用户给出一个明确的功能范围即可，例如：

- “帮我 review 素材导入功能的 unit test，并输出 test review report”
- “把 `AssetStoreCLI` 相关测试整理成可人工审核的报告”
- “我想审核 prompt search 这一块的 unit test 和 integration test 覆盖情况”

默认行为不是只罗列 test case，而是先做一轮 AI test review，再把真正需要人类注意的问题高亮出来。

## 核心目标

产出一份适合人工快速审阅的测试审查文档，而不是一份冗长的测试目录。

最终报告必须满足：

- AI 先对测试质量、覆盖面、断言强度、测试分层、可维护性做一轮自审
- 把真正需要人工关注的点放在最前面，并用 Obsidian 友好的高亮方式标记
- 每次 review 后都输出 Markdown 文档到目标仓库的 `docs/` 下
- 写完文档后自动尝试用 Obsidian 打开该文档
- 对复杂逻辑、跨层协作、测试矩阵优先使用 Mermaid；在空间布局或多节点梳理更清晰时补 `.canvas`
- test case 清单保留，但放到后半部分或折叠附录，不能让主阅读路径淹没在大表里

## 输出契约

### 文档位置

- 优先复用目标仓库现有的测试审查目录命名
- 若没有既有约定，默认输出到：`docs/test-review/`
- 文件名默认：
  - Markdown: `<feature-slug>.test-review.<YYYY-MM-DD>.md`
  - Canvas: `<feature-slug>.test-review.<YYYY-MM-DD>.canvas`
- 若同名文件已存在，追加更细粒度时间戳，避免覆盖

### 文档结构

最终 Markdown 报告必须遵循 `references/report-template.md` 的结构意图，顺序上优先保证：

1. AI 结论
2. 人工优先审查队列
3. 覆盖热力图 / 风险分层
4. 关键 findings
5. 复杂逻辑可视化
6. 补测建议
7. 详细 test case 附录

### Obsidian 友好格式

报告主文档必须优先使用：

- YAML frontmatter
- Obsidian callouts，例如 `> [!danger]`、`> [!warning]`、`> [!note]`、`> [!tip]`
- `==高亮==` 标记人工必须关注的短语
- 可折叠 callout，将低优先级明细收起
- wikilink 或相对链接串联 `.md` 与 `.canvas`

不要把主报告写成一整页大表。大表只能出现在附录。

## Review 维度

在生成报告前，必须先从以下维度自动 review 测试：

- 覆盖面：主流程、错误分支、边界条件、参数矩阵、状态切换
- 断言强度：是否只测“被调用过”，还是验证了真正的行为语义
- 分层准确性：unit / integration / contract / e2e 的边界是否符合仓库约定
- 稳定性：是否依赖真实时间、随机数、网络、文件系统、竞态、脆弱快照
- 可维护性：fixture 复杂度、重复 case、命名清晰度、过度 mock、隐式前置条件
- 误报风险：测试可能通过但并不能真正证明目标行为的地方

如果某个判断主要来自代码推断，而非测试显式断言，必须明确标注 `推断`。

## Steps

1. **确认范围**
   - 从用户请求中识别目标功能、模块、类、函数、命令或页面。
   - 若范围偏大，先声明你采用的边界，再开始分析。

2. **理解仓库测试约定**
   - 优先读取 `REPO-ROOT/tests/README.md`。
   - 若不存在，再查找等价测试规范文件，并在报告中说明依据。
   - 先厘清该仓库如何定义 `unit`、`integration`、`contract`、`smoke`、`e2e`。

3. **定位实现与相关测试**
   - 先找实现入口，再找相关测试。
   - 不要只看文件名；结合实现代码、测试名、`describe` 分组、helper、fixture、mock、命令入口共同判断。
   - 默认主清单优先纳入 unit tests；强相关 integration/contract tests 单独分组呈现，不能混淆层级。

4. **先做 AI review，再整理 test case**
   - 先回答“这些测试是否真的证明了目标行为”。
   - 识别：
     - 明确缺失的分支
     - 断言偏弱的地方
     - 分层不干净的地方
     - 需要人工拍板的 tradeoff
   - 先形成 findings，再开始写 case inventory。

5. **对 findings 做优先级分层**
   - 使用 `P1 / P2 / P3` 或等价优先级。
   - 只把真正需要人工关注的 3-7 个重点放进“人工优先审查队列”。
   - 低价值重复项放到折叠区或附录，不要占据主视野。

6. **建立功能树与覆盖图**
   - 按“主功能 -> 子功能 -> 场景类型”组织。
   - 场景类型优先使用：
     - 正常路径
     - 参数校验
     - 边界条件
     - 错误处理
     - 状态变化
     - 副作用或依赖调用
   - 对每个功能组给出覆盖信号：
     - `Strong`
     - `Adequate`
     - `Weak`
     - `Missing`

7. **决定是否生成可视化**
   - 满足任一条件时，必须生成 Mermaid：
     - 存在跨模块调用链
     - 需要解释测试分层与职责边界
     - 需要展示分支/状态流
     - 需要展示“实现 -> 测试 -> 缺口”的映射
   - 满足任一条件时，额外生成 `.canvas`：
     - 节点较多，Mermaid 会过载
     - 需要空间化表达“模块 / 测试文件 / 风险点 / 补测建议”的关系
     - 用户明确提到 JSON Canvas / Obsidian Canvas

8. **生成主报告**
   - 主报告必须先给 AI verdict 和人工待看项，再给覆盖图，再给 findings。
   - 所有高优先级问题都要附证据：
     - 文件
     - 行号
     - 对应测试或实现片段
     - 为什么这件事值得人工确认
   - test case 明细作为后置附录，不可抢占主阅读路径。

9. **写入文档**
   - 将最终报告写入目标仓库 `docs/` 下合适位置。
   - 若生成 Mermaid，直接内嵌在 `.md` 中。
   - 若生成 `.canvas`，将其写到同目录，并在 `.md` 中加入可点击引用。

10. **打开预览**
    - 写入后，优先尝试使用 Obsidian 打开生成的 Markdown 文档。
    - macOS 下优先使用：`open -a Obsidian "<report-path>"`
    - 若 Obsidian 不可用，再退回系统默认打开方式，并在最终说明中告知。

## 详细 case 记录要求

详细 test case 仍然需要保留，但放在附录或折叠块中。每条至少包含：

- `Case ID`
- `功能分组`
- `测试名称`
- `描述/目的`
- `期望输入`
- `期望输出`
- `具体例子`
- `来源`

其中：

- `描述/目的` 必须回答“这个 case 想证明什么”
- `期望输入` 包括参数、前置状态、mock 条件、触发动作
- `期望输出` 包括返回值、状态变化、依赖调用、错误、日志或其他副作用
- `具体例子` 优先写业务可读的输入输出实例

## 判断标准

一份合格的报告应满足：

- 用户先看前 1 屏，就知道“哪里值得人工 review”
- 用户不必重新通读所有测试，也能理解覆盖轮廓和主要风险
- 用户能区分“明确缺失”“断言偏弱”“分层不准”“只是低优先级建议”
- 用户能快速跳到证据位置
- 用户能通过 Mermaid / Canvas 看懂复杂关系，而不是只靠长文本
- 用户打开 Obsidian 后，文档可以直接作为审阅入口，而不是再加工原料

## Resources

### `references/report-template.md`

最终 Markdown 报告模板。主结构、callout 风格、人工审阅优先级、附录布局都应优先遵循该模板。

### `references/example-human-first-report.md`

一个“先给 AI 结论和人工重点，再给证据和附录”的成品示例。生成最终报告时，应更接近这个阅读体验，而不是传统的平铺清单。
