本篇文档记录的是我搭建自动化开发基础设施的需求和想法。

# 目标
自动化的开发、测试功能，提升写代码交付的效率

# Happy Path

1. 我于 agent 在工具内对话，确定 Plan。
2. 根据 Plan 的复杂程度，拆分为 1 个或多个 story。
3. 通过 linear 创建 story 的 Task。
4. linear 通过Symphony 安排指定的 agent 开工。
5. 每个 agent 执行 SDD 工作流。

# 功能清单
* 根据 label 自动指定对应的 agent 
* 支持 amp 等多 agent
* 根据任务的 label 选择不同的工作流，比如 feature ,bugfix 


# 路线图

1. 能在本地完成# Happy Path
2. 开发机能始终在线接活，我在远程创建 linear 可以自动接活、开工