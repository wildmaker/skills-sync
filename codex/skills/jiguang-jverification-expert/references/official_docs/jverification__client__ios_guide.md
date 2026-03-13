# 极光安全认证_iOS SDK 集成指南 - 极光文档

- Source: https://docs.jiguang.cn/jverification/client/ios_guide
- Fetched at (UTC): 2026-02-28 13:45:04Z

## Snapshot Text

极光文档
>
极光安全认证
>
客户端 SDK
>
iOS SDK
>
iOS SDK 集成指南
iOS SDK 集成指南
最近更新：2024-06-17
本页目录
SDK 说明
资源文件
DEMO 使用
使用提示
产品说明
主要场景
获取应用信息
iOS SDK 版本
接入配置
IDFA
添加 SDK 到工程中
工程配置
配置资源
接入代码
更多 API
运行 Demo
技术支持
展开全部
iOS SDK 集成指南
SDK 说明
资源文件
包名为 jverification-ios-{版本号}-release
Libs 文件夹：包含 jverification-ios-x.x.x.xcframework，jcore-ios-x.x.x.xcframework，OAuth.xcframework，TYRZUISDK.xcframework，EAccountApiSDK.xcframework（请注意：模拟器不支持 APNs）
Libs-noidfa 文件夹：包含静态库文件 jcore-noidfa-ios-x.x.x.xcframework
JiguangDemo 文件夹：示例
(Libs文件夹中还有老版本的JVERIFICATIONService.h和jverification-ios-x.x.x.a文件，这两个文件不要和 jverification-ios-x.x.x.xcframework一起导入工程，二选一即可，后续demo包中将不再提供.a包)
DEMO 使用
进入到 JiguangDemo 目录下，执行 pod install 命令安装 sdk，打开 JiguangDemo.xcworkspace 运行即可。
JiguangDemo 为多个 SDK 拼接组装而成的 Demo，使用 cocoapods 进行管理，如需手动集成请参考 [手动导入] 部分。
JiguangDemo 为多个 SDK 拼接组装而成的 Demo，使用 cocoapods 进行管理，如需手动集成请参考
[手动导入]
部分。
此代码块在浮窗中显示
使用提示
本文是 JVerification iOS SDK 标准的集成指南文档。
匹配的 SDK 版本为：v2.0.0 及以后版本。
如果您想要快速地测试、请参考本文在几分钟内跑通 Demo。
极光认证文档网站上，有相关的所有指南、API、教程等全部的文档。包括本文档的更新版本，都会及时地发布到该网站上。
产品说明
极光安全认证整合了三大运营商的网关认证能力，为开发者提供了一键登录、号码认证、业务风险功能，优化用户注册 / 登录、号码验证体验，提高安全性。
主要场景
注册
登陆
二次验证
获取应用信息
在控制台上
创建应用
后，可以进入【认证设置】-【集成设置】页面获取用以标识应用的 AppKey。
iOS SDK 版本
目前 SDK 只支持 iOS 8 以上版本的手机系统。
接入配置
IDFA
从 JVerification v2.5.0 开始，极光提供 idfa 和 noidfa 两个版本，请注意选择版本集成。 idfa 版本是标准版，默认自动采集 IDFA 数据， noidfa 版本不自动采集。极光建议开发者使 idfa 版本。当然，如果开发者不想使⽤ IDFA 或者担忧采集 IDFA 而未集成任何广告服务遭到 Apple 拒绝，请使用 noidfa 版本。
注意事项
App 在提交苹果审核时，对“此 App 是否使用广告标识符 (IDFA)？”，需要选择“是”，并且需要根据 App 使用广告情况，勾选以下选项：
在 App 内投放广告 -- 确认是的话需要勾选
标明此 App 安装来自先前投放的特定广告 -- 确认是的话需要勾选
标明此 App 中发生的操作来自先前投放的广告 -- 确认是的话需要勾选
添加 SDK 到工程中
选择 1: Cocoapods 导入 2.9.3
如果使用标准版本 (从 2.5.0 版本开始默认采集 IDFA)
pod 'JCore' // 可选项，也可由 pod 'JVerification' 自动获取
pod 'JVerification' // 必选项
pod
'JCore'
// 可选项，也可由 pod 'JVerification' 自动获取
pod
'JVerification'
// 必选项
此代码块在浮窗中显示
注：如果无法导入最新版本，请执行 pod repo update master 这个命令来升级本机的 pod 库，然后重新 pod 'JVerification'
如果需要安装指定版本则使用以下方式（以 2.9.3 版本为例）：
pod 'JCore', '3.2.9' // 可选项，也可由 pod 'JVerification' 自动获取
pod 'JVerification', '2.9.3' // 必选项
pod
'JCore'
,
'3.2.9'
// 可选项，也可由 pod 'JVerification' 自动获取
pod
'JVerification'
,
'2.9.3'
// 必选项
此代码块在浮窗中显示
如果使用无 IDFA 版本
如果使用 JCore 2.1.4 及以上版本，使用方式如下（以 JVerification 2.9.3 版本为例，需严格遵循代码顺序）：
pod 'JCore', '3.2.9-noidfa' // 必选项
pod 'JVerification', '2.9.3' // 必选项
pod
'JCore'
,
'3.2.9-noidfa'
// 必选项
pod
'JVerification'
,
'2.9.3'
// 必选项
此代码块在浮窗中显示
如果使用 JCore 2.1.4 以下版本，使用方式如下（以 JVerification 2.7.1 版本为例，需严格遵循代码顺序）：
pod 'JCore', '2.1.2' // 必选项
pod 'JVerification', '2.7.1' // 必选项
pod
'JCore'
,
'2.1.2'
// 必选项
pod
'JVerification'
,
'2.7.1'
// 必选项
此代码块在浮窗中显示
选择 2：手动导入
在极光官网下载最新 SDK
为工程添加相应的 Frameworks，需要为项目添加的 Frameworks 如下
AdSupport.framework（获取 IDFA 需要；如果不使用 IDFA，请不要添加）
CoreLocation.framework
CFNetwork.framework
CoreFoundation.framework
libresolv.tbd
libz.tbd
libc++.1.tbd
CoreTelephony.framework
SystemConfiguration.framework
Security.framework
CoreGraphics.framework
libsqlite3.tbd
MobileCoreServices.framework
AVFoundation.framework
jcore-ios-x.x.x.xcframework jcore 版本 2.1.6 及其以上
jverification-ios-x.x.x.xcframework
TYRZUISDK.xcframework
OAuth.xcframework
EAccountApiSDK.xcframework
说明：
jcore-ios-x.x.x.xcframework 、jverification-ios-x.x.x.xcframework 、OAuth.xcframework，TYRZUISDK.xcframework 和 EAccountApiSDK.xcframework 在 Libs 文件夹下
​
iOS12 以下需要支持 HTTPS 取号，需要添加 Network 库，添加方式如下：
如需支持 iOS12 以下系统，需要添加依赖库，在项目设置 target -> 选项卡 Build Phase -> Linked Binary with Libraries 添加如下依赖库：Network.framework，并将 status 设置为 Optional.
工程配置
配置 -ObjC
设置工程 TARGETS -> Build Settings -> Other Links Flags， 设置 -ObjC
配置支持 Http 传输
右键打开工程 plist 文件，加入以下代码
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
<
key
>
NSAppTransportSecurity
</
key
>
<
dict
>
<
key
>
NSAllowsArbitraryLoads
</
key
>
<
true
/>
</
dict
>
此代码块在浮窗中显示
配置资源
请将 JiguangDemo 中 Resource 目录下，认证使用的图片资源添加自己的工程目录下。
接入代码
Objective-C 接入
请将以下代码添加到引用 JVERIFICATIONService.h 头文件的的相关类中
// 引入 JVERIFICATIONService.h 头文件
#import "JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
// 引入 JVERIFICATIONService.h 头文件
#import
"JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import
<AdSupport/AdSupport.h>
此代码块在浮窗中显示
接入 JVerification SDK 的应用，必须先初始化 JVERIFICATIONService，否则将会无法正常使用，请将以下代码添加到合适的位置
// 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingId
NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
JVAuthConfig *config = [[JVAuthConfig alloc] init];
config.appKey = @"your appkey";
config.advertisingId = idfaStr;
[JVERIFICATIONService setupWithConfig:config];
// 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingId
NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
JVAuthConfig *config = [[JVAuthConfig alloc]
init
];
config.appKey =
@"your appkey"
;
config.advertisingId = idfaStr;
[
JVERIFICATIONService setupWithConfig:config
];
此代码块在浮窗中显示
Swift 接入
创建桥接头文件
如果你的 Swift 工程还未引入过 Objective-C 文件，需要创建一个以
工程名称 -Bridging-Header.h
文件
配置路径
设置工程 TARGETS -> Build Settings -> Objective-C Bridging Header， 设置桥接文件
工程名称 -Bridging-Header.h
的相对路径
引入头文件
在
工程名称 -Bridging-Header.h
文件中引入头文件
// 引入 JVERIFICATIONService.h 头文件
# import "JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
# import <AdSupport/AdSupport.h>
// 引入 JVERIFICATIONService.h 头文件
# import
"JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
# import
<AdSupport/AdSupport.h>
此代码块在浮窗中显示
接入 sdk
在需要用到 sdk 的位置，初始化 JVERIFICATIONService
let adString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
let config = JVAuthConfig()
config.appKey = "your appkey"
JVERIFICATIONService.setup(with: config)
let
adString = ASIdentifierManager.
shared
().advertisingIdentifier.uuidString
let
config = JVAuthConfig()
config.appKey =
"your appkey"
JVERIFICATIONService.setup(
with
: config)
此代码块在浮窗中显示
更多 API
其他 API 的使用方法请参考接口文档：
iOS SDK API
运行 Demo
压缩包附带的 JiguangDemo 是一个 API 演示例子。
Swift Demo 下载：
Swift Demo
技术支持
邮件联系：
support@jiguang.cn
文档内容是否对您有帮助？
提交评分
本页目录
SDK 说明
资源文件
DEMO 使用
使用提示
产品说明
主要场景
获取应用信息
iOS SDK 版本
接入配置
IDFA
添加 SDK 到工程中
工程配置
配置资源
接入代码
更多 API
运行 Demo
技术支持
代码浮窗
