# 系统整体设计方案（施工蓝图）

## 目标与范围
- 以 Spec 作为系统唯一真源（Single Source of Truth）
- 建立可审计、可传播、可控升级的 Spec 生命周期
- 支撑 agent 在不破坏本地配置的前提下惰性拉取与安全更新

不在本方案范围内：
- 具体业务能力的 Spec 内容细节
- 具体工具接入与运行时实现细节

## 宪法级原则（不可妥协）
1. Spec 永远是事实而非建议
2. agent 私有 skill 不允许直接修改 Spec
3. 所有 Spec 修改必须：
   - 更新 Spec 内容
   - 生成新 version
   - 记录 change_type

## Spec 元模型
### Spec 元数据（头部字段）
```
spec_ref: refactor_service
version: 1.3.0
change_type: semantic | behavioral | execution | doc
breaking: false
summary: "Clarify OCR pipeline page-index contract"
updated_at: 2026-01-22
```

### Spec 内容范围（建议结构）
- capability: 能力边界与定义
- contract: 输入/输出语义与约束
- rules: 业务规则、边界条件
- workflows: 推荐流程与执行顺序
- tools: 推荐工具与限制条件

## 变更语义分级（关键机制）
### change_type 语义
- doc：文档补充，行为不变
- execution：执行顺序/工具建议变化，产出不变
- behavioral：输入/输出语义变化
- semantic + breaking：能力定义变化，存在破坏性风险

### 变更等级决定传播策略
- doc/execution：可自动合并
- behavioral：需要重新生成 adapter
- breaking：需要显式确认（ack）

## 系统架构与组件
### 组件划分
- Spec Registry（唯一真源）
  - 版本化 Spec 存储
  - 变更记录与索引
- Change Manager
  - 版本递增与 change_type 校验
  - 变更审计与发布
- Adapter Generator
  - 基于 Spec 生成 agent adapter 或桥接层
- Agent Runtime
  - 本地缓存 spec_ref/spec_version
  - 变更检测与惰性拉取
- Local Lock
  - 本地锁定策略与 override 配置

### 典型数据流
1. 变更提交 -> Spec Registry 生成新版本与变更记录
2. 发布索引更新 -> Agent 下次使用时触发惰性拉取
3. Agent 根据 change_type 决定动作

## 版本与发布流程
1. 发起变更：只允许修改 Spec 源文件
2. 版本递增：必须生成新 version
3. 标注变更：change_type + breaking + summary
4. 发布索引：更新最新版本索引
5. 审计留痕：记录变更人、时间、摘要

## Agent 侧惰性拉取与本地锁定
### 本地 skill 描述示例
```
spec_ref: refactor_service
spec_version: 1.2.0
local_overrides:
  tone: codex-assertive
  tools: [git, shell]
```

### 调用时策略（关键逻辑）
```
if spec.version > local.spec_version:
    if change_type in [doc, execution]:
        auto-merge
    if change_type == behavioral:
        regenerate adapter
    if breaking:
        require explicit acknowledge
```

### 核心要点
- 不因检测到新版本而强制更新
- 只根据变更语义决定动作
- local_overrides 永远不被 Spec 覆盖

## 存储与目录建议
```
specs/
  refactor_service/
    spec.yaml
    versions/
      1.2.0.yaml
      1.3.0.yaml
index.yaml
changes/
  2026-01-22-refactor_service-1.3.0.md
```

## 风险控制与质量保障
- 变更合并前执行 change_type 校验
- breaking 变更需要显式确认记录
- 发布索引只指向已验证版本
- Agent 侧保留本地锁定与回滚能力

## 实施里程碑（蓝图）
1. Spec Registry 与版本索引机制落地
2. 变更审计与 change_type 校验流程上线
3. Adapter Generator 与 Agent 惰性拉取逻辑落地
4. breaking 变更确认与回滚策略完善

