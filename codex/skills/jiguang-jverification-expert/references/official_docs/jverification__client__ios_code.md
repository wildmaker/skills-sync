# 极光安全认证_iOS SDK 错误码 - 极光文档

- Source: https://docs.jiguang.cn/jverification/client/ios_code
- Fetched at (UTC): 2026-02-28 13:45:08Z

## Snapshot Text

极光文档
>
极光安全认证
>
客户端 SDK
>
iOS SDK
>
iOS SDK 错误码
iOS SDK 错误码
最近更新：2022-11-15
本页目录
认证错误码列表
iOS SDK 错误码
内层错误码详见
运营商错误码
。
认证错误码列表
code
描述
备注
1000
verify consistent
手机号验证一致
1001
verify not consistent
手机号验证不一致
1002
unknown result
未知结果
1003
token expired
token 失效
1004
sdk verify has been closed
SDK 发起认证未开启
1005
AppKey 不存在
请到官网检查 Appkey 对应的应用是否已被删除
1006
frequency of verifying single number is beyond the maximum limit
同一号码自然日内认证消耗超过限制
1007
beyond daily frequency limit
appKey 自然日认证消耗超过限制
1008
AppKey 非法
请到官网检查此应用详情中的 Appkey，确认无误
1009
当前的 Appkey 下没有创建 iOS 应用；你所使用的 JCore 版本过低
请到官网检查此应用的应用详情；更新应用中集成的 JCore 至最新。
1010
verify interval is less than the minimum limit
同一号码连续两次提交认证间隔过短
2000
token request success
获取 token 成功
2001
fetch token error
获取 token 失败
2002
sdk init failed
sdk 初始化失败
2003
netwrok not reachable
网络连接不通
2004
get uid failed
极光服务注册失败
2005
request timeout
请求超时
2006
fetch config failed
获取配置失败
2008
Token requesting, please wait
正在获取 token 中，稍后再试
2009
verifying, please try again later
正在认证中，稍后再试
2014
internal error while requesting token
请求 token 时发生内部错误
2015
rsa encode failed
rsa 加密失败
2016
network type not supported
当前网络环境不支持认证
2017
carrier config invalid
运营商配置无效
2018
Local unsupported operator,operator sdk don't exist
本地运营商 sdk 不存在
3000
get code sucess.
获取 uuid 成功
3001
SDK is not initial yet
没有初始化
3002
invalided phone number
无效电话号码
3003
request frequent in Minimum Time Interval
两次请求超过最小设置的时间间隔
3004
-
请求错误, 具体查看错误信息 msg
4001
-
参数错误。请检查参数，比如是否手机号格式不对
4009
-
解密 rsa 失败
4014
appkey is blocked
功能被禁用
4018
-
没有足够的余额
4031
-
不是认证用户
4032
-
获取不到用户配置
4033
Login feature is not available
未开启一键登录
6000
loginToken request success
获取 loginToken 成功
6001
fetch loginToken failed
获取 loginToken 失败
6002
login cancel
用户取消登录
6003
UI load error
UI 加载异常
6004
authorization requesting, please try again later
正在登录中，稍候再试
6006
prelogin scrip expired
预取号信息过期，请重新预取号
7000
preLogin success
预取号成功
7001
preLogin failed
预取号失败
7002
preLogin requesting, please try again later
取号中
8000
init success
初始化成功
8004
init failed
初始化失败
8005
init timeout
初始化超时
文档内容是否对您有帮助？
提交评分
本页目录
认证错误码列表
代码浮窗
