---
name: create-e2e-test
description: 按项目规范创建、更新和维护 E2E 场景文档与自动化测试文件；适用于用户要求新增 E2E 测试、补齐场景覆盖、审查 scenario 到 test 的映射、维护 e2e/scenarios 与 e2e/automation/scenarios 时使用。
version: 0.1.0
---

# Skill: create-e2e-test

## Trigger
- 用户要求“创建 E2E 测试”“补一个端到端测试”“更新 E2E 场景”“维护 e2e 测试文件”。
- 需要把业务验收场景转成自动化测试。
- 需要审查 `e2e/scenarios/*.md` 与 `e2e/automation/scenarios/test_*.py`、Playwright、Cypress 或其他 E2E 文件的覆盖关系。

## What this skill does
- 建立“场景定义 -> 自动化实现”的可审查映射。
- 为每个 E2E 测试文件补齐顶部业务说明，降低人工审核门槛。
- 创建或更新测试代码，让业务步骤、代码执行和关键断言一一对应。
- 明确当前未覆盖项，避免测试看起来很忙但没有证明核心业务。

## Core rule
默认采用最容易审核的结构：

```text
一个场景文档
  -> 管理一条业务能力的完整验收集
一个编号 Scenario
  -> 一个 test_xx 文件
  -> 文件里一个主测试函数
```

允许例外，但必须在场景文档或测试文件顶部说明原因：
- 一个 Scenario 可拆成多个测试文件：当同一业务场景有多个重要边界分支。
- 多个小 Scenario 可放进一个测试文件：当场景很小且共享 setup 很多。

## Inputs
- `<scenario-doc>`: 业务场景文档，例如 `e2e/scenarios/document-upload-workbench.md`。
- `<scenario-number>`: 要实现或更新的 Scenario 编号。
- `<test-file>`: 对应自动化测试文件，例如 `e2e/automation/scenarios/test_01_single_file_success.py`。
- `<fixtures>`: E2E 所需测试数据、文件、账号、服务或环境变量。

## Outputs
- 更新后的场景文档（如需要）。
- 一个或多个自动化测试文件。
- 测试文件顶部中文业务说明。
- 覆盖关系和未覆盖项摘要。

## Workflow
1. 定位项目 E2E 约定：
   - 查找 `e2e/scenarios/`、`e2e/automation/scenarios/`、`tests/e2e/`、`playwright.config.*`、`cypress.config.*` 或项目文档。
   - 阅读相邻场景文档和已有测试文件，复用命名、fixture、helper、断言风格。
2. 建立 Scenario 映射：
   - 在场景文档中找出目标 Scenario 的标题、业务目标、业务步骤、预期结果。
   - 找到或创建对应测试文件，优先命名为 `test_<scenario-number>_<short_slug>.<ext>`。
   - 先用一句话审查映射：`Scenario N 的每个业务步骤，test_xx 是否都有对应代码执行？`
3. 更新场景文档：
   - 若新增 Scenario，写清业务目标、前置条件、步骤、预期结果和自动化测试文件路径。
   - 若测试文件已存在但文档没有来源，补回对应 Scenario 或标记为缺少业务来源。
4. 创建或更新测试文件：
   - 文件顶部必须有中文业务说明，使用下面的模板。
   - 一个主测试函数覆盖一个主业务场景；分支很多时拆出多个测试并在顶部说明覆盖边界。
   - 测试必须通过用户/外部可观察入口进入系统，除非 Scenario 明确允许内部接口。
   - 异步处理必须等待真实终态，不能用固定 sleep 伪造通过。
   - 关键业务结果必须有明确 assert，不能只检查“请求成功”或“页面没报错”。
5. 对齐代码与说明：
   - 顶部“测试流程”写了几步，代码中就必须有对应执行。
   - “关键断言”列出的内容必须真的 assert。
   - “当前已知边界 / 未覆盖项”必须诚实描述未测分支。
6. 运行最小验证：
   - 按项目约定运行目标 E2E 或相关测试。
   - 若环境缺失，说明缺少的变量、服务或 fixture，并保留静态审查结论。
7. 输出结果：
   - 说明新增/更新了哪个 Scenario 和哪个测试文件。
   - 说明是否实现一一对应、还有哪些未覆盖项、运行了什么验证。

## Test file header template
每个 E2E 测试文件顶部放在模块 docstring 或文件注释中，按项目语言调整语法：

```text
Scenario <N>: <中文场景名>。

业务目标：
<验证这个端到端场景要证明的业务事实。>

测试流程：
1. <从真实入口执行的第 1 步。>
2. <第 2 步。>
3. <等待异步终态或观察业务结果。>

关键断言：
- <必须证明的状态、数据、页面、文件、消息或副作用。>
- <必须证明没有发生的泄漏、越权、重复处理或错误状态。>

人工审核重点：
- <哪些地方最容易写成假 E2E 或绕过真实业务链路。>
- <哪些 helper/API 可以用，哪些 internal shortcut 不允许用。>

当前已知边界 / 未覆盖项：
- <明确未覆盖的边界、分支或后续应补测试。>
```

## Scenario document checklist
- 每个 Scenario 有编号、中文名、业务目标、前置条件、步骤、预期结果。
- 每个 Scenario 标出对应自动化测试文件路径。
- 文档定义但无测试文件：标记为“未自动化覆盖”。
- 测试文件存在但文档无 Scenario：标记为“测试缺少业务来源”。
- 一个 Scenario 对多个测试文件时，列出每个测试覆盖的分支。

## Implementation checklist
- 测试从真实 public API、UI、CLI 或用户可达入口进入系统。
- Fixture 真实参与流程；不要只 mock 掉核心业务路径。
- 异步任务使用轮询或项目 helper 等待终态，并设置合理超时。
- 对最终业务状态、关键中间状态和安全/隐私边界做 assert。
- 失败时保留足够定位信息：响应体、页面状态、日志路径或截图。
- 测试名、Scenario 编号、文件名保持可追踪。

## Review checklist
审查 E2E 的第一层能力是映射审查：

```text
Scenario N 的每个业务步骤，test_xx 是否都有对应代码执行？
```

逐项检查：
- 场景步骤是否在测试代码中真实执行。
- 预期结果是否有明确断言。
- 顶部说明是否与代码一致。
- 未覆盖项是否诚实记录。
- 是否存在绕过核心业务链路的内部调用、过度 mock 或只测 happy-path 请求成功。

## Allowed commands
- `rg`
- `pytest`
- `npm`
- `pnpm`
- `yarn`
- `npx playwright`
- `npx cypress`
- 项目文档中已有的 E2E 命令

## Exit criteria
- Scenario 文档与自动化测试文件存在双向映射。
- 测试文件顶部业务说明完整。
- 业务步骤、代码执行、关键断言三者对齐。
- 目标测试已运行通过，或明确说明因环境缺失未运行以及缺失项。
