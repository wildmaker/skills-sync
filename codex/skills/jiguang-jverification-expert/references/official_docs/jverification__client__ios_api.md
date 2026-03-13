# 极光安全认证_iOS SDK API - 极光文档

- Source: https://docs.jiguang.cn/jverification/client/ios_api
- Fetched at (UTC): 2026-02-28 13:45:06Z

## Snapshot Text

极光文档
>
极光安全认证
>
客户端 SDK
>
iOS SDK
>
iOS SDK API
iOS SDK API
最近更新：2024-06-07
本页目录
SDK 接口说明
设置 Debug 模式
SDK 初始化
支持回调参数
获取 SDK 初始化状态
判断网络环境是否支持
判断网络环境是否支持 （支持移动香港卡）
校验预取号缓存是否有效
是否获取地理位置信息
一键登录
初始化
判断网络环境是否支持
预取号
清除预取号缓存
拉起授权页面
拉起授权页面
关闭授权页面
自定义授权页面 UI 样式
授权页面添加自定义控件
创建 JVLayoutConstraint 布局对象
JVLayoutItem 枚举
JVLayoutConstraint 类
JVAuthConfig 类
JVUIConfig 类
SDK 请求授权一键登录（旧）
SDK 请求授权一键登录（旧）
号码认证
初始化
判断网络环境是否支持
获取号码认证 token
获取号码认证 token（新）
短信登录
SDK 短信登录
验证码
SDK 获取验证码
设置前后两次获取验证码的时间间隔
扩展业务相关设置
可选个人信息设置
安全风控接口
展开全部
iOS SDK API
SDK 接口说明
JVERIFICATIONService，包含 SDK 所有接口
JVAuthConfig 类，应用配置信息类
JVLayoutConstraint 类, 认证界面控件布局类
JVLayoutItem, 布局参照枚举
JVUIConfig 类，登录界面 UI 配置基类
JVMobileUIConfig 类，移动登录界面 UI 配置类，JVUIConfig 的子类
JVUnicomUIConfig 类，联通登录界面 UI 配置类，JVUIConfig 的子类
VTelecomUIConfig 类，电信登录界面 UI 配置类，JVUIConfig 的子类
JVCollectControl 类，合规采集配置类
设置 Debug 模式
支持的版本
开始支持的版本 1.0.0
接口定义
+ (void)setDebug:(BOOL)enable;
接口说明:
开启 debug 模式
参数说明
enable 是否开启 debug 模式
SDK 初始化
支持回调参数
支持的版本
开始支持的版本 2.3.6
接口定义
+ setupWithConfig:(JVAuthConfig *)config;
接口说明:
初始化接口
参数说明
config 配置类
调用示例:
OC
// 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingId
NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
JVAuthConfig *config = [[JVAuthConfig alloc] init];
config.appKey = @"AppKey copied from JiGuang Portal application";
config.advertisingId = idfaStr;
config.authBlock = ^(NSDictionary *result) {NSLog(@"初始化结果 result:%@", result);
};
[JVERIFICATIONService setupWithConfig:config];
Swift
let adString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
let config = JVAuthConfig()
config.appKey = "a0e6ace8d5b3e0247e3f58db"
config.authBlock = {(result) -> Void in
if let result = result {if let code = result["code"], let content = result["content"] {print("初始化结果 result: code = \(code), content = \(content)")}}
}
JVERIFICATIONService.setup(with: config)
OC
// 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingId
NSString
*
idfaStr
=
[[[
ASIdentifierManager
sharedManager] advertisingIdentifier]
UUIDString
];
JVAuthConfig
*
config
=
[[
JVAuthConfig
alloc]
init
];
config.appKey
=
@
"AppKey copied from JiGuang Portal application"
;
config.advertisingId
=
idfaStr;
config.authBlock
=
^
(
NSDictionary
*
result) {
NSLog
(@
"初始化结果 result:%@"
, result);
};
[
JVERIFICATIONService
setupWithConfig:config];
Swift
let
adString
=
ASIdentifierManager
.shared().advertisingIdentifier.uuidString
let
config
=
JVAuthConfig
()
config.appKey
=
"a0e6ace8d5b3e0247e3f58db"
config.authBlock
=
{(result) ->
Void
in
if
let
result
=
result {
if
let
code
=
result[
"code"
],
let
content
=
result[
"content"
] {
print
(
"初始化结果 result: code =
\(code)
, content =
\(content)
"
)}}
}
JVERIFICATIONService
.setup(with: config)
此代码块在浮窗中显示
获取 SDK 初始化状态
支持的版本
开始支持的版本 2.3.2
接口定义
+ (BOOL)isSetupClient
接口说明:
初始化是否成功
返回值说明
YES 初始化成功
NO 初始化失败
调用示例:
OC
BOOL isSetupClient = [JVERIFICATIONService isSetupClient];
if (isSetupClient) {// 初始化完成，可以进行后续操作}
Swift
let isSetup = JVERIFICATIONService.isSetupClient()
if isSetup {// 初始化完成，可以进行后续操作}
OC
BOOL
isSetupClient
=
[JVERIFICATIONService isSetupClient];
if
(isSetupClient) {
// 初始化完成，可以进行后续操作}
Swift
let
isSetup
=
JVERIFICATIONService.isSetupClient()
if
isSetup {
// 初始化完成，可以进行后续操作}
此代码块在浮窗中显示
判断网络环境是否支持
支持的版本
开始支持的版本 1.1.2
接口定义
+ (BOOL)checkVerifyEnable;
接口说明:
判断当前网络环境是否可以发起认证
返回值说明
YES 可以认证
NO 不可以认证
调用示例:
OC
if(![JVERIFICATIONService checkVerifyEnable]) {NSLog(@"当前网络环境不支持认证！");
return;
}
// 继续获取 token 操作
...
Swift
if !JVERIFICATIONService.checkVerifyEnable() {print("当前网络环境不支持认证！")
return
}
// 继续获取 token 操作
...
OC
if
(![JVERIFICATIONService checkVerifyEnable]) {
NSLog
(@"当前网络环境不支持认证！");
return;
}
// 继续获取 token 操作
...
Swift
if !JVERIFICATIONService
.checkVerifyEnable
() {
print
("当前网络环境不支持认证！")
return
}
// 继续获取 token 操作
...
此代码块在浮窗中显示
判断网络环境是否支持 （支持移动香港卡）
如需要支持移动香港卡，需要在预取号、一键登录、号码认证接口之前先调用该接口判断是否支持，若支持再继续预取号、一键登录或号码认证操作。
支持的版本
开始支持的版本 3.2.7
接口定义
***+ (void)checkVerifyEnable:(void(^)(BOOL isSupport, NSString
operatorType))completion;
**
接口说明:
判断当前网络环境是否可以发起认证 （支持移动香港卡）
返回值说明
completion 结果回调
completion：isSupport：YES 支持, NO 不支持
completion：operatorType：UNKNOW-未知；CM-移动；CU-联通；CT- 电信；CMHK-中国移动香港
调用示例:
OC
[JVERIFICATIONService checkVerifyEnable:^(BOOL isSupport, NSString * _Nonnull operatorType) {
NSLog(@"isSupport: %d -- operatorType: %@", isSupport, operatorType);
if (isSupport) {
[JVERIFICATIONService preLogin:5000 completion:^(NSDictionary *result) {
NSLog(@"预取号 result:%@", result);
}];
}
}];
...
Swift
JVERIFICATIONService.checkVerifyEnable { isSupport, operatorType in
if (isSupport) {
// 继续获取 预取号 or 一键登录 or 号码认证 操作
JVERIFICATIONService.preLogin(5000) {(result) in
if let result = result {if let code = result["code"], let message = result["message"] {print("preLogin result: code = \(code), message = \(message)")}}
}
}
}
...
OC
[
JVERIFICATIONService
checkVerifyEnable:
^
(
BOOL
isSupport,
NSString
*
_Nonnull operatorType) {
NSLog
(@
"isSupport: %d -- operatorType: %@"
, isSupport, operatorType);
if
(isSupport) {
[
JVERIFICATIONService
preLogin:
5000
completion:
^
(
NSDictionary
*
result) {
NSLog
(@
"预取号 result:%@"
, result);
}];
}
}];
...
Swift
JVERIFICATIONService
.checkVerifyEnable { isSupport, operatorType
in
if
(isSupport) {
// 继续获取 预取号 or 一键登录 or 号码认证 操作
JVERIFICATIONService
.preLogin(
5000
) {(result)
in
if
let
result
=
result {
if
let
code
=
result[
"code"
],
let
message
=
result[
"message"
] {
print
(
"preLogin result: code =
\(code)
, message =
\(message)
"
)}}
}
}
}
...
此代码块在浮窗中显示
校验预取号缓存是否有效
支持的版本
开始支持的版本 3.1.8
接口定义
+ (BOOL)validePreloginCache;
接口说明:
校验预取号缓存是否有效
返回值说明
YES 有效
NO 无效
调用示例:
OC
if(![JVERIFICATIONService validePreloginCache]) {NSLog(@"预取号缓存无效");
// 预取号 操作
}
...
Swift
if !JVERIFICATIONService.validePreloginCache() {print("预取号缓存无效")
// 预取号 操作
}
...
OC
if
(![JVERIFICATIONService validePreloginCache]) {
NSLog
(@"预取号缓存无效");
// 预取号 操作
}
...
Swift
if !JVERIFICATIONService
.validePreloginCache
() {
print
("预取号缓存无效")
// 预取号 操作
}
...
此代码块在浮窗中显示
是否获取地理位置信息
支持的版本
开始支持的版本 1.1.2
开始失效的版本 3.2.2
注意：该接口在 3.2.2 版本中被删除。
接口定义
+ (void)setLocationEanable:(BOOL)isEanble;
接口说明:
设置SDK地理位置权限开关，YES为开启，NO为关闭，默认为开启。
关闭地理位置之后，pushSDK地理围栏的相关功能将受到影响。
调用示例:
[JVERIFICATIONService setLocationEanable:NO];
[JVERIFICATIONService setLocationEanable:NO]
;
此代码块在浮窗中显示
一键登录
初始化
调用 SDK 其他流程方法前，请确保已调用过初始化，否则会返回未初始化，详情参考
SDK 初始化 API
。初始化后，如您调用如下功能接口，视为您同意开启极光安全认证相关业务功能，我们会收集业务功能必要的个人信息并上报。
判断网络环境是否支持
判断当前的手机网络环境是否可以使用一键登录，若网络支持，再调用一键登录 API，否则请调用其他登录方式的 API，详情参考
判断网络环境是否支持 API
。
预取号
支持的版本
开始支持的版本 2.2.0
接口定义
+ (void)preLogin:(NSTimeInterval)timeout completion:(void (^)(NSDictionary *result))completion
接口说明:
验证当前运营商网络是否可以进行一键登录操作，该方法会缓存取号信息，提高一键登录效率。建议发起一键登录前先调用此方法。
参数说明:
completion 预取号结果
result 字典 key 为 code 和 message 两个字段
timeout 超时时间（毫秒）, 有效取值范围(0,10000]. 为保证获取 token 的成功率，建议设置为 3000-5000ms.
调用示例:
OC
[JVERIFICATIONService preLogin:5000 completion:^(NSDictionary *result) {NSLog(@"登录预取号 result:%@", result);
}];
Swift
JVERIFICATIONService.preLogin(5000) {(result) in
if let result = result {if let code = result["code"], let message = result["message"] {print("preLogin result: code = \(code), message = \(message)")}}
}
OC
[
JVERIFICATIONService
preLogin:
5000
completion:
^
(
NSDictionary
*
result) {
NSLog
(@
"登录预取号 result:%@"
, result);
}];
Swift
JVERIFICATIONService
.preLogin(
5000
) {(result)
in
if
let
result
=
result {
if
let
code
=
result[
"code"
],
let
message
=
result[
"message"
] {
print
(
"preLogin result: code =
\(code)
, message =
\(message)
"
)}}
}
此代码块在浮窗中显示
清除预取号缓存
+ (BOOL)clearPreLoginCache;
接口说明:
清除预取号缓存
调用示例:
OC
[JVERIFICATIONService clearPreLoginCache];
Swift
JVERIFICATIONService.clearPreLoginCache()
OC
[JVERIFICATIONService clearPreLoginCache]
;
Swift
JVERIFICATIONService
.clearPreLoginCache
()
此代码块在浮窗中显示
拉起授权页面
支持的版本
开始支持的版本 2.5.2
接口定义
+ (void)getAuthorizationWithController:(UIViewController *)vc hide:(BOOL)hide animated:(BOOL)animationFlag timeout:(NSTimeInterval)timeoutcompletion:(void (^)(NSDictionary *result))completion actionBlock:(void(^)(NSInteger type, NSString *content))actionBlock
接口说明:
授权登录
参数说明:
completion 登录结果
result 字典 获取到 token 时 key 有 operator、code、loginToken 字段，获取不到 token 是 key 为 code 和 content 字段
vc 当前控制器
hide 完成后是否自动隐藏授权页。
animationFlag 拉起授权页时是否需要动画效果，默认 YES
timeout 超时。单位毫秒，合法范围是(0,30000]，默认值为 10000。此参数同时作用于拉起授权页超时，以及点击授权页登录按钮获取 LoginToken 超时
actionBlock 授权页事件触发回调。包含type和content两个参数，type为事件类型，content为事件描述。 type = 1,授权页被关闭;type=2,授权页面被拉起；type=3,协议被点击；type=4,获取验证码按钮被点击；type=6,checkBox变为选中；type=7,checkBox变为未选中；type=8,登录按钮被点击
调用示例:
OC
[JVERIFICATIONService getAuthorizationWithController:self hide:NO animated:YES timeout:5*1000 completion:^(NSDictionary *result) {NSLog(@"一键登录 result:%@", result);
} actionBlock:^(NSInteger type, NSString *content) {NSLog(@"一键登录 actionBlock :%ld %@", (long)type , content);}];
Swift
JVERIFICATIONService.getAuthorizationWith(self, hide: true, animated: true, timeout: 5*1000, completion: { (result) in
if let result = result {if let token = result["loginToken"] {if let code = result["code"], let op = result["operator"] {print("一键登录 result: code = \(code), operator = \(op), loginToken = \(token)")}}else if let code = result["code"], let content = result["content"] {print("一键登录 result: code = \(code), content = \(content)")}}
}){ (type, content) in
if let content = content {print("一键登录 actionBlock :type = \(type), content = \(content)")}}
OC
[
JVERIFICATIONService
getAuthorizationWithController:
self
hide:
NO
animated:
YES
timeout:
5
*
1000
completion:
^
(
NSDictionary
*
result) {
NSLog
(@
"一键登录 result:%@"
, result);
} actionBlock:
^
(
NSInteger
type,
NSString
*
content) {
NSLog
(@
"一键登录 actionBlock :%ld %@"
, (long)type , content);}];
Swift
JVERIFICATIONService
.getAuthorizationWith(
self
, hide:
true
, animated:
true
, timeout:
5
*
1000
, completion: { (result)
in
if
let
result
=
result {
if
let
token
=
result[
"loginToken"
] {
if
let
code
=
result[
"code"
],
let
op
=
result[
"operator"
] {
print
(
"一键登录 result: code =
\(code)
, operator =
\(op)
, loginToken =
\(token)
"
)}}
else
if
let
code
=
result[
"code"
],
let
content
=
result[
"content"
] {
print
(
"一键登录 result: code =
\(code)
, content =
\(content)
"
)}}
}){ (type, content)
in
if
let
content
=
content {
print
(
"一键登录 actionBlock :type =
\(type)
, content =
\(content)
"
)}}
此代码块在浮窗中显示
说明
：获取到一键登录的 loginToken 后，将其返回给应用服务端，从服务端调用
REST API
来获取手机号码。
拉起授权页面
支持的版本
开始支持的版本 3.1.0
接口定义
+ (void)getAuthorizationWithController:(UIViewController *)vc enableSms:(BOOL)enableSms hide:(BOOL)hide animated:(BOOL)animationFlag timeout:(NSTimeInterval)timeoutcompletion:(void (^)(NSDictionary *result))completion actionBlock:(void(^)(NSInteger type, NSString *content))actionBlock
接口说明:
授权登录
参数说明:
completion 登录结果
result 字典 获取到 token 时 key 有 operator、code、loginToken 字段，获取不到 token 是 key 为 code 和 content 字段
vc 当前控制器
enableSms 是否开启短信登录切换服务，开启时在授权登录失败时拉起短信登录页面。
hide 完成后是否自动隐藏授权页。
animationFlag 拉起授权页时是否需要动画效果，默认 YES
timeout 超时。单位毫秒，合法范围是(0,30000]，默认值为 10000。此参数同时作用于拉起授权页超时，以及点击授权页登录按钮获取 LoginToken 超时
actionBlock 授权页事件触发回调。包含type和content两个参数，type为事件类型，content为事件描述。 type = 1,授权页被关闭;type=2,授权页面被拉起；type=3,协议被点击；type=4,获取验证码按钮被点击；type=6,checkBox变为选中；type=7,checkBox变为未选中；type=8,登录按钮被点击
调用示例:
OC
[JVERIFICATIONService getAuthorizationWithController:self enableSms:YES hide:YES animated:YES timeout:5*1000 completion:^(NSDictionary * _Nonnull) {
} actionBlock:^(NSInteger, NSString * _Nonnull) {
}];
Swift
JVERIFICATIONService. getAuthorizationWith(self,enableSms:true, hide: true, animated: true, timeout: 5*1000, completion: { (result) in
if let result = result {if let token = result["loginToken"] {if let code = result["code"], let op = result["operator"] {print("一键登录 result: code = \(code), operator = \(op), loginToken = \(token)")}}else if let code = result["code"], let content = result["content"] {print("一键登录 result: code = \(code), content = \(content)")}}
}){ (type, content) in
if let content = content {print("一键登录 actionBlock :type = \(type), content = \(content)")}}
OC
[
JVERIFICATIONService
getAuthorizationWithController:
self
enableSms:
YES
hide:
YES
animated:
YES
timeout:
5
*
1000
completion:
^
(
NSDictionary
*
_Nonnull) {
} actionBlock:
^
(
NSInteger
,
NSString
*
_Nonnull) {
}];
Swift
JVERIFICATIONService
. getAuthorizationWith(
self
,enableSms:
true
, hide:
true
, animated:
true
, timeout:
5
*
1000
, completion: { (result)
in
if
let
result
=
result {
if
let
token
=
result[
"loginToken"
] {
if
let
code
=
result[
"code"
],
let
op
=
result[
"operator"
] {
print
(
"一键登录 result: code =
\(code)
, operator =
\(op)
, loginToken =
\(token)
"
)}}
else
if
let
code
=
result[
"code"
],
let
content
=
result[
"content"
] {
print
(
"一键登录 result: code =
\(code)
, content =
\(content)
"
)}}
}){ (type, content)
in
if
let
content
=
content {
print
(
"一键登录 actionBlock :type =
\(type)
, content =
\(content)
"
)}}
此代码块在浮窗中显示
说明
：获取到一键登录的 loginToken 后，将其返回给应用服务端，从服务端调用
REST API
来获取手机号码。
关闭授权页面
支持的版本
开始支持的版本 2.5.2
接口定义
+ (void)dismissLoginControllerAnimated: (BOOL)flag completion: (void (^)(void))completion;
接口说明:
隐藏登录页. 当授权页被拉起以后，可调用此接口隐藏授权页。当一键登录自动隐藏授权页时，不建议调用此接口
参数说明:
flag 隐藏时是否需要动画
completion 字典授权页隐藏完成后回调
调用示例:
OC
[JVERIFICATIONService dismissLoginControllerAnimated:YES completion:^{// 授权页隐藏完成}];
Swift
JVERIFICATIONService.dismissLoginController(animated: true) {// 授权页隐藏完成}
OC
[
JVERIFICATIONService
dismissLoginControllerAnimated
:
YES
completion
:^{
// 授权页隐藏完成}];
Swift
JVERIFICATIONService
.
dismissLoginController
(
animated:
true
) {
// 授权页隐藏完成}
此代码块在浮窗中显示
支持的版本
开始支持的版本：2.3.0
接口定义
+ (void)dismissLoginController;
接口说明:
关闭授权页，从 2.5.2 版本开始，此接口已废弃
调用示例:
[JVERIFICATIONService dismissLoginController];
[JVERIFICATIONService dismissLoginController]
;
此代码块在浮窗中显示
自定义授权页面 UI 样式
开发者不得通过任何技术手段将授权页面的隐私协议栏、slogan 隐藏或者覆盖，对于接入极光认证 SDK 并上线的应用，我方会对上线的应用授权页面做审查，如果发现未按要求设计授权页面，将关闭应用的一键登录服务。
支持的版本
开始支持的版本 2.0.0
接口定义
+ (void)customUIWithConfig:(JVUIConfig *)UIConfig;
接口说明:
自定义登录页 UI 样式
参数说明:
UIConfig JVUIConfig 对象
/*设置全屏样式UI*/
- (void)customFullScreenUI{
JVUIConfig *config = [[JVUIConfig alloc] init];
config.prefersStatusBarHidden = YES;
config.shouldAutorotate = YES;
config.openPrivacyInBrowser = NO;
config.autoLayout = YES;
config.agreementNavTextColor = [UIColor redColor];
config.navReturnHidden = NO;
config.privacyTextFontSize = 12;
config.navText = [[NSAttributedString alloc]initWithString:@"登录统一认证" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
config.privacyTextAlignment = NSTextAlignmentLeft;
config.numberFont = [UIFont boldSystemFontOfSize:12];
config.logBtnFont = [UIFont boldSystemFontOfSize:13];
config.sloganFont = [UIFont boldSystemFontOfSize:16];
config.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
config.privacyTextAlignment = NSTextAlignmentLeft;
config.privacyShowBookSymbol = YES;
config.privacyComponents = @[@"登录表示同意",@"文本1",@"文本2",@"文本3",@"文本4",@"文本5"];
config.preferredStatusBarStyle = 0;
config.agreementPreferredStatusBarStyle = 0;
config.privacyState = NO;
config.dismissAnimationFlag = YES;
///协议二次弹窗默认配置
config.isAlertPrivacyVC = YES;
// config.agreementAlertViewLogBtnTextColor = [UIColor whiteColor];
// config.agreementAlertViewTitleTextColor = [UIColor colorWithRed:34/255 green:35/255 blue:40/255 alpha:1];
config.agreementAlertViewContentTextFontSize = 10;
config.agreementAlertViewContentTextAlignment = NSTextAlignmentLeft;
// config.agreementAlertViewTitleTexFont = [UIFont fontWithName:NSFontAttributeName size:16];
config.windowCornerRadius = 15;
config.resetAgreementAlertViewFrameBlock = ^(NSValue *_Nullable* _Nullable superViewFrame ,NSValue *_Nullable* _Nullable alertViewFrame , NSValue *_Nullable* _Nullable titleFrame , NSValue *_Nullable* _Nullable contentFrame, NSValue *_Nullable* _Nullable buttonFrame){
*superViewFrame = [NSValue valueWithCGRect:CGRectMake(10, 60, 280, 180)];
*alertViewFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, 280, 180)];
*buttonFrame = [NSValue valueWithCGRect:CGRectMake(CGRectGetMidX([*contentFrame CGRectValue])-180/2, CGRectGetMaxY([*contentFrame CGRectValue])+5, 180, CGRectGetHeight([*buttonFrame CGRectValue]))];
};
config.customLoadingViewBlock = ^(UIView *View) {
//https://github.com/jdg/MBProgressHUD
MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:View animated:YES];
hub.backgroundColor = [UIColor clearColor];
hub.label.text = @"正在登录..";
[hub showAnimated:YES];
};
config.customPrivacyAlertViewBlock = ^(UIViewController *vc , NSArray *appPrivacys,void(^loginAction)(void)) {
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:appPrivacys.description preferredStyle:UIAlertControllerStyleAlert];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:true completion:nil];
};
config.agreementAlertViewShowWindow = YES;
__weak __typeof(self)weakSelf = self;
config.customAgreementAlertView = ^(UIView *superView,void(^hidAlertView)(void)){
weakSelf.hidAlertView = hidAlertView;
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
button.frame = CGRectMake(10, 50, 60, 40);
[button setTitle:@"关闭拉起" forState:UIControlStateNormal];
button.backgroundColor = [UIColor greenColor];
[button addTarget:self action:@selector(buttonTouch_alerView) forControlEvents:UIControlEventTouchUpInside];
[superView addSubview:button];
};
//logo
config.logoImg = [UIImage imageNamed:@"cmccLogo"];
CGFloat logoWidth = config.logoImg.size.width?:100;
CGFloat logoHeight = logoWidth;
JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-90];
JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints = config.logoConstraints;
//号码栏
JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-55];
JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints = config.numberConstraints;
//slogan展示
JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20];
JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:180];
JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
config.sloganConstraints = @[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints = config.sloganConstraints;
//登录按钮
UIImage *login_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *login_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *login_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (login_nor_image && login_dis_image && login_hig_image) {
config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat loginButtonWidth = login_nor_image.size.width?:100;
CGFloat loginButtonHeight = login_nor_image.size.height?:100;
JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:30];
JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints = config.logBtnConstraints;
//勾选框---全屏样式 sdk先add隐私 因为隐私大小随内容变化而变化
UIImage * uncheckedImg = [self imageNamed:@"checkBox_unSelected"];
UIImage * checkedImg = [self imageNamed:@"checkBox_selected"];
CGFloat checkViewWidth = uncheckedImg.size.width;
CGFloat checkViewHeight = uncheckedImg.size.height;
config.uncheckedImg = uncheckedImg;
config.checkedImg = checkedImg;
JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeTop multiplier:1 constant:0];//改为top对齐
JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints = config.checkViewConstraints;
config.navCustom = YES;
config.privacysNavCustom = NO;
//隐私
config.textVerAlignment = JVVerAlignmentTop;///设置隐私Label的垂直对齐方式
//隐私---旧方法
CGFloat spacing = checkViewWidth + 20 + 5;
config.appPrivacyOne = @[@"应用自定义服务条款1",@"https://www.jiguang.cn/about"];
config.appPrivacyTwo = @[@"应用自定义服务条款2",@"https://www.jiguang.cn/about"];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.appPrivacys = @[
@"头部文字",//头部文字
@[@"、",@"应用自定义服务条款1",@"https://www.taobao.com/",@"协议1自定义标题"],
@[@"、",@"应用自定义服务条款2",@"https://www.jiguang.cn/",@"协议2自定义标题"],
@[@"、",@"应用自定义服务条款3",@"https://www.baidu.com/", @"协议3自定义标题"],
// @[@"、",@"应用自定义服务条款4",@"https://www.taobao.com/",@"协议4自定义标题"],
// @[@"、",@"应用自定义服务条款5",@"https://www.taobao.com/",@"协议5自定义标题"],
@"尾部文字。"
];
JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:80];
config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints = config.privacyConstraints;
//loading
JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
config.loadingHorizontalConstraints = config.loadingConstraints;
// 设置 gif背景
// config.authPageGifImagePath = [[NSBundle mainBundle] pathForResource:@"auth" ofType:@"gif"];
/*
config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
config.navColor = [UIColor redColor];
config.preferredStatusBarStyle = UIStatusBarStyleDefault;
config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 44, 44);
button.backgroundColor = [UIColor greenColor];
config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
config.logoHidden = NO;
config.logBtnText = @"自定义登录按钮文字";
config.logBtnTextColor = [UIColor redColor];
config.numberColor = [UIColor blueColor];
config.appPrivacyOne = @[@"应用自定义服务条款1",@"https://www.jiguang.cn/about"];
config.appPrivacyTwo = @[@"应用自定义服务条款2",@"https://www.jiguang.cn/about"];
config.privacyComponents = @[@"文本1",@"文本2",@"文本3",@"文本4"];
config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
config.sloganTextColor = [UIColor redColor];
config.navCustom = NO;
config.numberSize = 24;
config.privacyState = YES;
*/
config.navCustom = NO;
NSString *urlStr = @"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4";
[config setVideoBackgroudResource:urlStr placeHolder:@"cmBackground.jpeg"];
[JVERIFICATIONService customUIWithConfig:[self customSMSUI:config] customViews:^(UIView *customAreaView) {
/*
//添加一个自定义label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
button.frame = CGRectMake(10, 400, 100, 40);
[button setTitle:@"关闭拉起" forState:UIControlStateNormal];
button.backgroundColor = [UIColor greenColor];
[button addTarget:self action:@selector(buttonTouch) forControlEvents:UIControlEventTouchUpInside];
[customAreaView addSubview:button];
UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
button2.frame = CGRectMake(200, 400, 100, 40);
[button2 setTitle:@"关闭" forState:UIControlStateNormal];
button2.backgroundColor = [UIColor greenColor];
[button2 addTarget:self action:@selector(buttonTouch2) forControlEvents:UIControlEventTouchUpInside];
// [customAreaView addSubview:button2];
/*
UILabel *autoLabel = [[UILabel alloc] init];
autoLabel.text = @"这是一个自定义autoLable";
[autoLabel sizeToFit];
[customAreaView addSubview:autoLabel];
autoLabel.translatesAutoresizingMaskIntoConstraints = NO;
NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeCenterX multiplier:1 constant:10];
NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeCenterY multiplier:1 constant:10];
NSLayoutConstraint *constarintW = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:50];
NSLayoutConstraint *constarintH = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
[autoLabel addConstraint:constarintW];
[autoLabel addConstraint:constarintH];
[customAreaView addConstraint:constraintCenterX];
[customAreaView addConstraint:constraintCenterY];
*/
}];
}
- (JVUIConfig *)customSMSUI:(JVUIConfig *)config {
//logo图片
config.smsLogoImg = [UIImage imageNamed:@"cmccLogo"];
CGFloat smslogoWidth = config.smsLogoImg.size.width?:100;
CGFloat smslogoHeight = smslogoWidth;
JVLayoutConstraint *smslogoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *smslogoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-150];
JVLayoutConstraint *smslogoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:smslogoWidth];
JVLayoutConstraint *smslogoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:smslogoHeight];
config.smsLogoConstraints = @[smslogoConstraintX,smslogoConstraintY,smslogoConstraintW,smslogoConstraintH];
config.smsLogoHorizontalConstraints = config.smsLogoConstraints;
//slogan展示
JVLayoutConstraint *smsSloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *smsSloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
JVLayoutConstraint *smsSloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:180];
JVLayoutConstraint *smsSloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
config.smsSloganConstraints = @[smsSloganConstraintX,smsSloganConstraintY, smsSloganConstraintW, smsSloganConstraintH];
config.smsSloganHorizontalConstraints = config.smsSloganConstraints;
//号码输入框
JVLayoutConstraint *phoneTextFieldConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *phoneTextFieldConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
JVLayoutConstraint *phoneTextFieldConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeWidth multiplier:1 constant:-40];
JVLayoutConstraint *phoneTextFieldConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
config.smsNumberTFConstraints = @[phoneTextFieldConstraintX,phoneTextFieldConstraintY, phoneTextFieldConstraintW, phoneTextFieldConstraintH];
config.smsNumberTFHorizontalConstraints = config.smsNumberTFConstraints;
//验证码输入框
JVLayoutConstraint *codeTFConstraintsX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *codeTFConstraintsY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
JVLayoutConstraint *codeTFConstraintsW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
JVLayoutConstraint *codeTFConstraintsH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
config.smsCodeTFConstraints = @[codeTFConstraintsX,codeTFConstraintsY, codeTFConstraintsW, codeTFConstraintsH];
config.smsCodeTFHorizontalConstraints = config.smsCodeTFConstraints;
//获取验证码按钮
JVLayoutConstraint *getCodeTFConstraintsX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:0];
JVLayoutConstraint *getCodeTFConstraintsY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemCodeTF attribute:NSLayoutAttributeTop multiplier:1 constant:0];
JVLayoutConstraint *getCodeTFConstraintsW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:150];
JVLayoutConstraint *getCodeTFConstraintsH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
config.smsGetCodeBtnConstraints = @[getCodeTFConstraintsX,getCodeTFConstraintsY, getCodeTFConstraintsW, getCodeTFConstraintsH];
config.smsGetCodeBtnHorizontalConstraints = config.smsGetCodeBtnConstraints;
//登录按钮
UIImage *login_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *login_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *login_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (login_nor_image && login_dis_image && login_hig_image) {
config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat loginButtonWidth = login_nor_image.size.width?:100;
CGFloat loginButtonHeight = login_nor_image.size.height?:100;
JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemCodeTF attribute:NSLayoutAttributeBottom multiplier:1 constant:30];
JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
config.smsLogBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.smsLogBtnHorizontalConstraints = config.smsLogBtnConstraints;
UIImage * uncheckedImg = [self imageNamed:@"checkBox_unSelected"];
UIImage * checkedImg = [self imageNamed:@"checkBox_selected"];
CGFloat checkViewWidth = 20;
CGFloat checkViewHeight = 20;
CGFloat spacing = checkViewWidth + 20 + 5;
JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
config.smsPrivacyConstraints = @[privacyConstraintX,privacyConstraintY,privacyConstraintX2,privacyConstraintH];
config.smsPrivacyHorizontalConstraints = config.smsPrivacyConstraints;
//勾选框
config.smsUncheckedImg = uncheckedImg;
config.smsCheckedImg = checkedImg;
JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeTop multiplier:1 constant:0];
JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
config.smsCheckViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.smsCheckViewHorizontalConstraints = config.smsCheckViewConstraints;
config.smsCustomPrivacyAlertViewBlock = ^(UIViewController *vc , NSArray *appPrivacys,void(^loginAction)(void)) {
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:appPrivacys.description preferredStyle:UIAlertControllerStyleAlert];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:true completion:nil];
};
config.smsShowWindow = NO;
config.smsAutoLayout = YES;
config.smsAgreementAlertViewShowWindow = YES;
config.smsWindowCornerRadius = 15;
config.smsResetAgreementAlertViewFrameBlock = ^(NSValue *_Nullable* _Nullable superViewFrame ,NSValue *_Nullable* _Nullable alertViewFrame , NSValue *_Nullable* _Nullable titleFrame , NSValue *_Nullable* _Nullable contentFrame, NSValue *_Nullable* _Nullable buttonFrame){
*superViewFrame = [NSValue valueWithCGRect:CGRectMake(10, 60, 280, 180)];
*alertViewFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, 280, 180)];
*buttonFrame = [NSValue valueWithCGRect:CGRectMake(CGRectGetMidX([*contentFrame CGRectValue])-180/2, CGRectGetMaxY([*contentFrame CGRectValue])+5, 180, CGRectGetHeight([*buttonFrame CGRectValue]))];
};
__weak __typeof(self)weakSelf = self;
config.smsCustomAgreementAlertView = ^(UIView *superView,void(^hidAlertView)(void)){
weakSelf.hidAlertView = hidAlertView;
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
button.frame = CGRectMake(10, 50, 60, 40);
[button setTitle:@"关闭拉起" forState:UIControlStateNormal];
button.backgroundColor = [UIColor greenColor];
[button addTarget:self action:@selector(buttonTouch_alerView) forControlEvents:UIControlEventTouchUpInside];
[superView addSubview:button];
};
config.smsAuthBtnBlock = ^(NSInteger code,NSString *msg){
[MBProgressHUD showToast:msg duration:3];
};
config.isSmsAlertPrivacyVC = YES;
config.smsPrivacysNavCustom = NO;
config.smsTextVerAlignment = JVVerAlignmentTop;
config.smsPrivacyTextAlignment = NSTextAlignmentLeft;
config.smsPrivacyShowBookSymbol = YES;
config.smsAutoLayout = YES;
config.privacyComponents = @[@"登录即同意",@"文本1",@"文本2",@"文本3",@"文本4",@"文本5"];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.smsAppPrivacys = @[
@"头部文字",//头部文字
@[@"",@"应用自定义服务条款1",@"https://www.taobao.com/",@"协议1自定义标题"],
@[@"、",@"应用自定义服务条款2",@"https://www.jiguang.cn/",@"协议2自定义标题"],
@[@"、",@"应用自定义服务条款3",@"https://www.baidu.com/", @"协议3自定义标题"],
@"尾部文字。"
];
UIImage *sms_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *sms_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *sms_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (sms_nor_image && sms_dis_image && sms_hig_image) {
///协议二次弹窗的btn图片
config.smsAgreementAlertViewLogBtnImgs = @[sms_nor_image, sms_dis_image, sms_hig_image];
}
return config;
}
- (JVUIConfig *)customSMSWindowSUI:(JVUIConfig *)config {
//弹框
config.smsShowWindow = YES;
config.smsWindowCornerRadius = 10;
config.smsWindowBackgroundAlpha = 0.3;
CGFloat windowW = 300;
CGFloat windowH = 300;
JVLayoutConstraint *windowConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *windowConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *windowConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
JVLayoutConstraint *windowConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowH];
config.smsWindowConstraints = @[windowConstraintX,windowConstraintY,windowConstraintW,windowConstraintH];
config.smsWindowHorizontalConstraints = config.windowConstraints;
//弹窗close按钮
UIImage *window_close_nor_image = [self imageNamed:@"windowClose"];
UIImage *window_close_hig_image = [self imageNamed:@"windowClose"];
if (window_close_nor_image && window_close_hig_image) {
config.smsWindowCloseBtnImgs = @[window_close_nor_image, window_close_hig_image];
}
CGFloat windowCloseBtnWidth = window_close_nor_image.size.width?:15;
CGFloat windowCloseBtnHeight = window_close_nor_image.size.height?:15;;
JVLayoutConstraint *windowCloseBtnConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
JVLayoutConstraint *windowCloseBtnConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:10];
JVLayoutConstraint *windowCloseBtnConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowCloseBtnWidth];
JVLayoutConstraint *windowCloseBtnConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowCloseBtnHeight];
config.smsWindowCloseBtnConstraints = @[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];
config.smsWindowCloseBtnHorizontalConstraints = config.windowCloseBtnConstraints;
//logo图片
config.smsLogoImg = [UIImage imageNamed:@"cmccLogo"];
CGFloat smslogoWidth = config.smsLogoImg.size.width?:100;
CGFloat smslogoHeight = smslogoWidth;
JVLayoutConstraint *smslogoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *smslogoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-150];
JVLayoutConstraint *smslogoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:smslogoWidth];
JVLayoutConstraint *smslogoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:smslogoHeight];
config.smsLogoConstraints = @[smslogoConstraintX,smslogoConstraintY,smslogoConstraintW,smslogoConstraintH];
config.smsLogoHorizontalConstraints = config.smsLogoConstraints;
//slogan展示
JVLayoutConstraint *smsSloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *smsSloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemLogo attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
JVLayoutConstraint *smsSloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:180];
JVLayoutConstraint *smsSloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
config.smsSloganConstraints = @[smsSloganConstraintX,smsSloganConstraintY, smsSloganConstraintW, smsSloganConstraintH];
config.smsSloganHorizontalConstraints = config.smsSloganConstraints;
//号码输入框
JVLayoutConstraint *phoneTextFieldConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *phoneTextFieldConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
JVLayoutConstraint *phoneTextFieldConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeWidth multiplier:1 constant:-40];
JVLayoutConstraint *phoneTextFieldConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
config.smsNumberTFConstraints = @[phoneTextFieldConstraintX,phoneTextFieldConstraintY, phoneTextFieldConstraintW, phoneTextFieldConstraintH];
config.smsNumberTFHorizontalConstraints = config.smsNumberTFConstraints;
//验证码输入框
JVLayoutConstraint *codeTFConstraintsX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *codeTFConstraintsY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeBottom multiplier:1 constant:20];
JVLayoutConstraint *codeTFConstraintsW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
JVLayoutConstraint *codeTFConstraintsH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
config.smsCodeTFConstraints = @[codeTFConstraintsX,codeTFConstraintsY, codeTFConstraintsW, codeTFConstraintsH];
config.smsCodeTFHorizontalConstraints = config.smsCodeTFConstraints;
//获取验证码按钮
JVLayoutConstraint *getCodeTFConstraintsX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:0];
JVLayoutConstraint *getCodeTFConstraintsY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemCodeTF attribute:NSLayoutAttributeTop multiplier:1 constant:0];
JVLayoutConstraint *getCodeTFConstraintsW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:150];
JVLayoutConstraint *getCodeTFConstraintsH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumberTF attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
config.smsGetCodeBtnConstraints = @[getCodeTFConstraintsX,getCodeTFConstraintsY, getCodeTFConstraintsW, getCodeTFConstraintsH];
config.smsGetCodeBtnHorizontalConstraints = config.smsGetCodeBtnConstraints;
//登录按钮
UIImage *login_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *login_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *login_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (login_nor_image && login_dis_image && login_hig_image) {
config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat loginButtonWidth = login_nor_image.size.width?:100;
CGFloat loginButtonHeight = login_nor_image.size.height?:100;
JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemCodeTF attribute:NSLayoutAttributeBottom multiplier:1 constant:30];
JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
config.smsLogBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.smsLogBtnHorizontalConstraints = config.smsLogBtnConstraints;
UIImage * uncheckedImg = [self imageNamed:@"checkBox_unSelected"];
UIImage * checkedImg = [self imageNamed:@"checkBox_selected"];
CGFloat checkViewWidth = 20;
CGFloat checkViewHeight = 20;
CGFloat spacing = checkViewWidth + 20 + 5;
JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
config.smsPrivacyConstraints = @[privacyConstraintX,privacyConstraintY,privacyConstraintX2,privacyConstraintH];
config.smsPrivacyHorizontalConstraints = config.smsPrivacyConstraints;
//勾选框
config.smsUncheckedImg = uncheckedImg;
config.smsCheckedImg = checkedImg;
JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeTop multiplier:1 constant:0];
JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
config.smsCheckViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.smsCheckViewHorizontalConstraints = config.smsCheckViewConstraints;
config.smsCustomPrivacyAlertViewBlock = ^(UIViewController *vc , NSArray *appPrivacys,void(^loginAction)(void)) {
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:appPrivacys.description preferredStyle:UIAlertControllerStyleAlert];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:true completion:nil];
};
config.smsShowWindow = YES;
config.smsAutoLayout = NO;
config.smsAgreementAlertViewShowWindow = YES;
config.smsWindowCornerRadius = 15;
config.smsResetAgreementAlertViewFrameBlock = ^(NSValue *_Nullable* _Nullable superViewFrame ,NSValue *_Nullable* _Nullable alertViewFrame , NSValue *_Nullable* _Nullable titleFrame , NSValue *_Nullable* _Nullable contentFrame, NSValue *_Nullable* _Nullable buttonFrame){
*superViewFrame = [NSValue valueWithCGRect:CGRectMake(10, 60, 280, 180)];
*alertViewFrame = [NSValue valueWithCGRect:CGRectMake(0, 0, 280, 180)];
*buttonFrame = [NSValue valueWithCGRect:CGRectMake(CGRectGetMidX([*contentFrame CGRectValue])-180/2, CGRectGetMaxY([*contentFrame CGRectValue])+5, 180, CGRectGetHeight([*buttonFrame CGRectValue]))];
};
__weak __typeof(self)weakSelf = self;
config.smsCustomAgreementAlertView = ^(UIView *superView,void(^hidAlertView)(void)){
weakSelf.hidAlertView = hidAlertView;
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
button.frame = CGRectMake(10, 50, 60, 40);
[button setTitle:@"关闭拉起" forState:UIControlStateNormal];
button.backgroundColor = [UIColor greenColor];
[button addTarget:self action:@selector(buttonTouch_alerView) forControlEvents:UIControlEventTouchUpInside];
[superView addSubview:button];
};
config.smsAuthBtnBlock = ^(NSInteger code,NSString *msg){
[MBProgressHUD showToast:msg duration:3];
};
config.isSmsAlertPrivacyVC = YES;
config.smsPrivacysNavCustom = NO;
config.smsTextVerAlignment = JVVerAlignmentTop;
config.smsPrivacyTextAlignment = NSTextAlignmentLeft;
config.smsPrivacyShowBookSymbol = YES;
config.smsAutoLayout = YES;
config.privacyComponents = @[@"登录即同意",@"文本1",@"文本2",@"文本3",@"文本4",@"文本5"];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.smsAppPrivacys = @[
@"头部文字",//头部文字
@[@"",@"应用自定义服务条款1",@"https://www.taobao.com/",@"协议1自定义标题"],
@[@"、",@"应用自定义服务条款2",@"https://www.jiguang.cn/",@"协议2自定义标题"],
@[@"、",@"应用自定义服务条款3",@"https://www.baidu.com/", @"协议3自定义标题"],
@"尾部文字。"
];
UIImage *sms_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *sms_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *sms_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (sms_nor_image && sms_dis_image && sms_hig_image) {
///协议二次弹窗的btn图片
config.smsAgreementAlertViewLogBtnImgs = @[sms_nor_image, sms_dis_image, sms_hig_image];
}
return config;
}
-(UIViewController*)topViewController{
UIViewController *topViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
while (topViewController.presentedViewController) {
topViewController = topViewController.presentedViewController;
}
return topViewController;
}
//设置授权弹窗样式UI
- (void)customWindowUI{
JVUIConfig *config = [[JVUIConfig alloc] init];
config.navCustom = YES;
config.autoLayout = YES;
config.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
config.agreementNavTextColor = UIColor.redColor;
//弹框
config.showWindow = YES;
config.windowCornerRadius = 10;
config.windowBackgroundAlpha = 0.3;
// config.windowBackgroundImage = [UIImage imageNamed:@"cuccLogo"];
CGFloat windowW = 300;
CGFloat windowH = 300;
JVLayoutConstraint *windowConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *windowConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *windowConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
JVLayoutConstraint *windowConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowH];
config.windowConstraints = @[windowConstraintX,windowConstraintY,windowConstraintW,windowConstraintH];
config.windowHorizontalConstraints = config.windowConstraints;
config.agreementNavText = [[NSAttributedString alloc]initWithString:@"运营商自定义标题" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
config.firstPrivacyAgreementNavText = [[NSAttributedString alloc]initWithString:@"协议1自定义标题" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}];
config.secondPrivacyAgreementNavText = [[NSAttributedString alloc]initWithString:@"协议2自定义标题" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//弹窗close按钮
UIImage *window_close_nor_image = [self imageNamed:@"windowClose"];
UIImage *window_close_hig_image = [self imageNamed:@"windowClose"];
if (window_close_nor_image && window_close_hig_image) {
config.windowCloseBtnImgs = @[window_close_nor_image, window_close_hig_image];
}
CGFloat windowCloseBtnWidth = window_close_nor_image.size.width?:15;
CGFloat windowCloseBtnHeight = window_close_nor_image.size.height?:15;;
JVLayoutConstraint *windowCloseBtnConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-5];
JVLayoutConstraint *windowCloseBtnConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:5];
JVLayoutConstraint *windowCloseBtnConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowCloseBtnWidth];
JVLayoutConstraint *windowCloseBtnConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowCloseBtnHeight];
config.windowCloseBtnConstraints = @[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];
config.windowCloseBtnHorizontalConstraints = config.windowCloseBtnConstraints;
//logo
config.logoImg = [UIImage imageNamed:@"cmccLogo"];
CGFloat logoWidth = config.logoImg.size.width?:100;
CGFloat logoHeight = logoWidth;
JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:10];
JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints = config.logoConstraints;
//号码栏
JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:130];
JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints = config.numberConstraints;
//slogan展示
JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:160];
JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
config.sloganConstraints = @[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints = config.sloganConstraints;
//登录按钮
UIImage *login_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *login_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *login_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (login_nor_image && login_dis_image && login_hig_image) {
config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat loginButtonWidth = login_nor_image.size.width?:100;
CGFloat loginButtonHeight = login_nor_image.size.height?:100;
JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:180];
JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints = config.logBtnConstraints;
//勾选框
UIImage * uncheckedImg = [self imageNamed:@"checkBox_unSelected"];
UIImage * checkedImg = [self imageNamed:@"checkBox_selected"];
CGFloat checkViewWidth = 30;
CGFloat checkViewHeight = 30;
config.uncheckedImg = uncheckedImg;
config.checkedImg = checkedImg;
JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints = config.checkViewConstraints;
//隐私---旧方法
CGFloat spacing = checkViewWidth + 20 + 5;
config.privacyState = YES;
config.appPrivacyOne = @[@"应用自定义服务条款1",@"https://www.jiguang.cn/about"];
config.appPrivacyTwo = @[@"应用自定义服务条款2",@"https://www.jiguang.cn/about"];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.appPrivacys = @[
@"头部文字",//头部文字
@[@"、",@"应用自定义服务条款1",@"https://www.taobao.com/",@"协议1自定义标题"],
@[@"、",@"应用自定义服务条款2",@"https://www.jiguang.cn/",@"协议2自定义标题"],
@[@"、",@"应用自定义服务条款3",@"https://www.baidu.com/", @"协议3自定义标题"],
@[@"、",@"应用自定义服务条款4",@"https://www.taobao.com/",@"协议4自定义标题"],
@[@"、",@"应用自定义服务条款5",@"https://www.taobao.com/",@"协议5自定义标题"],
@"尾部文字。"
];
JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-20];
JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints = config.privacyConstraints;
//loading
JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
config.loadingHorizontalConstraints = config.loadingConstraints;
/*
config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
config.navColor = [UIColor redColor];
config.preferredStatusBarStyle = UIStatusBarStyleDefault;
config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 44, 44);
button.backgroundColor = [UIColor greenColor];
config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
config.logoHidden = NO;
config.logBtnText = @"自定义登录按钮文字";
config.logBtnTextColor = [UIColor redColor];
config.numberColor = [UIColor blueColor];
config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
config.sloganTextColor = [UIColor redColor];
config.navCustom = NO;
config.numberSize = 24;
config.privacyState = YES;
*/
config.authPageGifImagePath = [[NSBundle mainBundle] pathForResource:@"auth" ofType:@"gif"];
NSString *urlStr = @"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4";
// [config setVideoBackgroudResource:urlStr placeHolder:@"cmBackground.jpeg"];
[JVERIFICATIONService customUIWithConfig:[self customSMSWindowSUI:config] customViews:^(UIView *customAreaView) {
/*
//添加一个自定义label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
UILabel *autoLabel = [[UILabel alloc] init];
autoLabel.text = @"这是一个自定义autoLable";
[autoLabel sizeToFit];
[customAreaView addSubview:autoLabel];
autoLabel.translatesAutoresizingMaskIntoConstraints = NO;
NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeCenterX multiplier:1 constant:10];
NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeCenterY multiplier:1 constant:10];
NSLayoutConstraint *constarintW = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:50];
NSLayoutConstraint *constarintH = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
[autoLabel addConstraint:constarintW];
[autoLabel addConstraint:constarintH];
[customAreaView addConstraint:constraintCenterX];
[customAreaView addConstraint:constraintCenterY];
}];
}
/*设置全屏样式UI*/
-
(void)customFullScreenUI{
JVUIConfig
*
config
=
[[
JVUIConfig
alloc]
init
];
config.prefersStatusBarHidden
=
YES
;
config.shouldAutorotate
=
YES
;
config.openPrivacyInBrowser
=
NO
;
config.autoLayout
=
YES
;
config.agreementNavTextColor
=
[
UIColor
redColor];
config.navReturnHidden
=
NO
;
config.privacyTextFontSize
=
12
;
config.navText
=
[[
NSAttributedString
alloc]initWithString:@
"登录统一认证"
attributes:@{
NSForegroundColorAttributeName
:[
UIColor
whiteColor],
NSFontAttributeName
:[
UIFont
boldSystemFontOfSize:
18
]}];
config.privacyTextAlignment
=
NSTextAlignmentLeft
;
config.numberFont
=
[
UIFont
boldSystemFontOfSize:
12
];
config.logBtnFont
=
[
UIFont
boldSystemFontOfSize:
13
];
config.sloganFont
=
[
UIFont
boldSystemFontOfSize:
16
];
config.modalTransitionStyle
=
UIModalTransitionStyleCoverVertical
;
config.privacyTextAlignment
=
NSTextAlignmentLeft
;
config.privacyShowBookSymbol
=
YES
;
config.privacyComponents
=
@[@
"登录表示同意"
,@
"文本1"
,@
"文本2"
,@
"文本3"
,@
"文本4"
,@
"文本5"
];
config.preferredStatusBarStyle
=
0
;
config.agreementPreferredStatusBarStyle
=
0
;
config.privacyState
=
NO
;
config.dismissAnimationFlag
=
YES
;
///协议二次弹窗默认配置
config.isAlertPrivacyVC
=
YES
;
// config.agreementAlertViewLogBtnTextColor = [UIColor whiteColor];
// config.agreementAlertViewTitleTextColor = [UIColor colorWithRed:34/255 green:35/255 blue:40/255 alpha:1];
config.agreementAlertViewContentTextFontSize
=
10
;
config.agreementAlertViewContentTextAlignment
=
NSTextAlignmentLeft
;
// config.agreementAlertViewTitleTexFont = [UIFont fontWithName:NSFontAttributeName size:16];
config.windowCornerRadius
=
15
;
config.resetAgreementAlertViewFrameBlock
=
^
(
NSValue
*
_Nullable
*
_Nullable superViewFrame ,
NSValue
*
_Nullable
*
_Nullable alertViewFrame ,
NSValue
*
_Nullable
*
_Nullable titleFrame ,
NSValue
*
_Nullable
*
_Nullable contentFrame,
NSValue
*
_Nullable
*
_Nullable buttonFrame){
*
superViewFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
10
,
60
,
280
,
180
)];
*
alertViewFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
0
,
0
,
280
,
180
)];
*
buttonFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
CGRectGetMidX
([
*
contentFrame
CGRectValue
])
-
180
/
2
,
CGRectGetMaxY
([
*
contentFrame
CGRectValue
])
+
5
,
180
,
CGRectGetHeight
([
*
buttonFrame
CGRectValue
]))];
};
config.customLoadingViewBlock
=
^
(
UIView
*
View
) {
//https://github.com/jdg/MBProgressHUD
MBProgressHUD
*
hub
=
[
MBProgressHUD
showHUDAddedTo:
View
animated:
YES
];
hub.backgroundColor
=
[
UIColor
clearColor];
hub.label.text
=
@
"正在登录.."
;
[hub showAnimated:
YES
];
};
config.customPrivacyAlertViewBlock
=
^
(
UIViewController
*
vc ,
NSArray
*
appPrivacys,void(
^
loginAction)(void)) {
UIAlertController
*
alert
=
[
UIAlertController
alertControllerWithTitle:@
"请点击同意协议"
message:appPrivacys.description preferredStyle:
UIAlertControllerStyleAlert
];
[alert addAction:[
UIAlertAction
actionWithTitle:@
"确定"
style:
UIAlertActionStyleDefault
handler:
^
(
UIAlertAction
*
_Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:
true
completion:
nil
];
};
config.agreementAlertViewShowWindow
=
YES
;
__weak __typeof(
self
)weakSelf
=
self
;
config.customAgreementAlertView
=
^
(
UIView
*
superView,void(
^
hidAlertView)(void)){
weakSelf.hidAlertView
=
hidAlertView;
UIButton
*
button
=
[
UIButton
buttonWithType:
UIButtonTypeSystem
];
button.frame
=
CGRectMake
(
10
,
50
,
60
,
40
);
[button setTitle:@
"关闭拉起"
forState:
UIControlStateNormal
];
button.backgroundColor
=
[
UIColor
greenColor];
[button addTarget:
self
action:
@selector
(buttonTouch_alerView) forControlEvents:
UIControlEventTouchUpInside
];
[superView addSubview:button];
};
//logo
config.logoImg
=
[
UIImage
imageNamed:@
"cmccLogo"
];
CGFloat
logoWidth
=
config.logoImg.size.width
?
:
100
;
CGFloat
logoHeight
=
logoWidth;
JVLayoutConstraint
*
logoConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
logoConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
90
];
JVLayoutConstraint
*
logoConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:logoWidth];
JVLayoutConstraint
*
logoConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:logoHeight];
config.logoConstraints
=
@[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints
=
config.logoConstraints;
//号码栏
JVLayoutConstraint
*
numberConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
numberConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
55
];
JVLayoutConstraint
*
numberConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
130
];
JVLayoutConstraint
*
numberConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
25
];
config.numberConstraints
=
@[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints
=
config.numberConstraints;
//slogan展示
JVLayoutConstraint
*
sloganConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
sloganConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
20
];
JVLayoutConstraint
*
sloganConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
180
];
JVLayoutConstraint
*
sloganConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
config.sloganConstraints
=
@[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints
=
config.sloganConstraints;
//登录按钮
UIImage
*
login_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
login_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
login_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(login_nor_image
&&
login_dis_image
&&
login_hig_image) {
config.logBtnImgs
=
@[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat
loginButtonWidth
=
login_nor_image.size.width
?
:
100
;
CGFloat
loginButtonHeight
=
login_nor_image.size.height
?
:
100
;
JVLayoutConstraint
*
loginConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loginConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loginConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:loginButtonWidth];
JVLayoutConstraint
*
loginConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:loginButtonHeight];
config.logBtnConstraints
=
@[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints
=
config.logBtnConstraints;
//勾选框---全屏样式 sdk先add隐私 因为隐私大小随内容变化而变化
UIImage
*
uncheckedImg
=
[
self
imageNamed:@
"checkBox_unSelected"
];
UIImage
*
checkedImg
=
[
self
imageNamed:@
"checkBox_selected"
];
CGFloat
checkViewWidth
=
uncheckedImg.size.width;
CGFloat
checkViewHeight
=
uncheckedImg.size.height;
config.uncheckedImg
=
uncheckedImg;
config.checkedImg
=
checkedImg;
JVLayoutConstraint
*
checkViewConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
checkViewConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemPrivacy
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
0
];
//改为top对齐
JVLayoutConstraint
*
checkViewConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:checkViewWidth];
JVLayoutConstraint
*
checkViewConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:checkViewHeight];
config.checkViewConstraints
=
@[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints
=
config.checkViewConstraints;
config.navCustom
=
YES
;
config.privacysNavCustom
=
NO
;
//隐私
config.textVerAlignment
=
JVVerAlignmentTop
;
///设置隐私Label的垂直对齐方式
//隐私---旧方法
CGFloat
spacing
=
checkViewWidth
+
20
+
5
;
config.appPrivacyOne
=
@[@
"应用自定义服务条款1"
,@
"https://www.jiguang.cn/about"
];
config.appPrivacyTwo
=
@[@
"应用自定义服务条款2"
,@
"https://www.jiguang.cn/about"
];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.appPrivacys
=
@[
@
"头部文字"
,
//头部文字
@[@
"、"
,@
"应用自定义服务条款1"
,@
"https://www.taobao.com/"
,@
"协议1自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款2"
,@
"https://www.jiguang.cn/"
,@
"协议2自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款3"
,@
"https://www.baidu.com/"
, @
"协议3自定义标题"
],
// @[@"、",@"应用自定义服务条款4",@"https://www.taobao.com/",@"协议4自定义标题"],
// @[@"、",@"应用自定义服务条款5",@"https://www.taobao.com/",@"协议5自定义标题"],
@
"尾部文字。"
];
JVLayoutConstraint
*
privacyConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:spacing];
JVLayoutConstraint
*
privacyConstraintX2
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
spacing];
JVLayoutConstraint
*
privacyConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
-
20
];
JVLayoutConstraint
*
privacyConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
80
];
config.privacyConstraints
=
@[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints
=
config.privacyConstraints;
//loading
JVLayoutConstraint
*
loadingConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loadingConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loadingConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loadingConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
30
];
config.loadingConstraints
=
@[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
config.loadingHorizontalConstraints
=
config.loadingConstraints;
// 设置 gif背景
// config.authPageGifImagePath = [[NSBundle mainBundle] pathForResource:@"auth" ofType:@"gif"];
/*
config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
config.navColor = [UIColor redColor];
config.preferredStatusBarStyle = UIStatusBarStyleDefault;
config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 44, 44);
button.backgroundColor = [UIColor greenColor];
config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
config.logoHidden = NO;
config.logBtnText = @"自定义登录按钮文字";
config.logBtnTextColor = [UIColor redColor];
config.numberColor = [UIColor blueColor];
config.appPrivacyOne = @[@"应用自定义服务条款1",@"https://www.jiguang.cn/about"];
config.appPrivacyTwo = @[@"应用自定义服务条款2",@"https://www.jiguang.cn/about"];
config.privacyComponents = @[@"文本1",@"文本2",@"文本3",@"文本4"];
config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
config.sloganTextColor = [UIColor redColor];
config.navCustom = NO;
config.numberSize = 24;
config.privacyState = YES;
*/
config.navCustom
=
NO
;
NSString
*
urlStr
=
@
"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4"
;
[config setVideoBackgroudResource:urlStr placeHolder:@
"cmBackground.jpeg"
];
[
JVERIFICATIONService
customUIWithConfig:[
self
customSMSUI:config] customViews:
^
(
UIView
*
customAreaView) {
/*
//添加一个自定义label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
UIButton
*
button
=
[
UIButton
buttonWithType:
UIButtonTypeSystem
];
button.frame
=
CGRectMake
(
10
,
400
,
100
,
40
);
[button setTitle:@
"关闭拉起"
forState:
UIControlStateNormal
];
button.backgroundColor
=
[
UIColor
greenColor];
[button addTarget:
self
action:
@selector
(buttonTouch) forControlEvents:
UIControlEventTouchUpInside
];
[customAreaView addSubview:button];
UIButton
*
button2
=
[
UIButton
buttonWithType:
UIButtonTypeSystem
];
button2.frame
=
CGRectMake
(
200
,
400
,
100
,
40
);
[button2 setTitle:@
"关闭"
forState:
UIControlStateNormal
];
button2.backgroundColor
=
[
UIColor
greenColor];
[button2 addTarget:
self
action:
@selector
(buttonTouch2) forControlEvents:
UIControlEventTouchUpInside
];
// [customAreaView addSubview:button2];
/*
UILabel *autoLabel = [[UILabel alloc] init];
autoLabel.text = @"这是一个自定义autoLable";
[autoLabel sizeToFit];
[customAreaView addSubview:autoLabel];
autoLabel.translatesAutoresizingMaskIntoConstraints = NO;
NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeCenterX multiplier:1 constant:10];
NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:customAreaView attribute:NSLayoutAttributeCenterY multiplier:1 constant:10];
NSLayoutConstraint *constarintW = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:50];
NSLayoutConstraint *constarintH = [NSLayoutConstraint constraintWithItem:autoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
[autoLabel addConstraint:constarintW];
[autoLabel addConstraint:constarintH];
[customAreaView addConstraint:constraintCenterX];
[customAreaView addConstraint:constraintCenterY];
*/
}];
}
-
(
JVUIConfig
*
)customSMSUI:(
JVUIConfig
*
)config {
//logo图片
config.smsLogoImg
=
[
UIImage
imageNamed:@
"cmccLogo"
];
CGFloat
smslogoWidth
=
config.smsLogoImg.size.width
?
:
100
;
CGFloat
smslogoHeight
=
smslogoWidth;
JVLayoutConstraint
*
smslogoConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
smslogoConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
150
];
JVLayoutConstraint
*
smslogoConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:smslogoWidth];
JVLayoutConstraint
*
smslogoConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:smslogoHeight];
config.smsLogoConstraints
=
@[smslogoConstraintX,smslogoConstraintY,smslogoConstraintW,smslogoConstraintH];
config.smsLogoHorizontalConstraints
=
config.smsLogoConstraints;
//slogan展示
JVLayoutConstraint
*
smsSloganConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemLogo
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
smsSloganConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemLogo
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
smsSloganConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
180
];
JVLayoutConstraint
*
smsSloganConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
config.smsSloganConstraints
=
@[smsSloganConstraintX,smsSloganConstraintY, smsSloganConstraintW, smsSloganConstraintH];
config.smsSloganHorizontalConstraints
=
config.smsSloganConstraints;
//号码输入框
JVLayoutConstraint
*
phoneTextFieldConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSlogan
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
phoneTextFieldConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSlogan
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
phoneTextFieldConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
-
40
];
JVLayoutConstraint
*
phoneTextFieldConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
30
];
config.smsNumberTFConstraints
=
@[phoneTextFieldConstraintX,phoneTextFieldConstraintY, phoneTextFieldConstraintW, phoneTextFieldConstraintH];
config.smsNumberTFHorizontalConstraints
=
config.smsNumberTFConstraints;
//验证码输入框
JVLayoutConstraint
*
codeTFConstraintsX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
codeTFConstraintsY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
codeTFConstraintsW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
codeTFConstraintsH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
0
];
config.smsCodeTFConstraints
=
@[codeTFConstraintsX,codeTFConstraintsY, codeTFConstraintsW, codeTFConstraintsH];
config.smsCodeTFHorizontalConstraints
=
config.smsCodeTFConstraints;
//获取验证码按钮
JVLayoutConstraint
*
getCodeTFConstraintsX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
getCodeTFConstraintsY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemCodeTF
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
getCodeTFConstraintsW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
150
];
JVLayoutConstraint
*
getCodeTFConstraintsH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
0
];
config.smsGetCodeBtnConstraints
=
@[getCodeTFConstraintsX,getCodeTFConstraintsY, getCodeTFConstraintsW, getCodeTFConstraintsH];
config.smsGetCodeBtnHorizontalConstraints
=
config.smsGetCodeBtnConstraints;
//登录按钮
UIImage
*
login_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
login_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
login_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(login_nor_image
&&
login_dis_image
&&
login_hig_image) {
config.logBtnImgs
=
@[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat
loginButtonWidth
=
login_nor_image.size.width
?
:
100
;
CGFloat
loginButtonHeight
=
login_nor_image.size.height
?
:
100
;
JVLayoutConstraint
*
loginConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loginConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemCodeTF
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loginConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:loginButtonWidth];
JVLayoutConstraint
*
loginConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:loginButtonHeight];
config.smsLogBtnConstraints
=
@[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.smsLogBtnHorizontalConstraints
=
config.smsLogBtnConstraints;
UIImage
*
uncheckedImg
=
[
self
imageNamed:@
"checkBox_unSelected"
];
UIImage
*
checkedImg
=
[
self
imageNamed:@
"checkBox_selected"
];
CGFloat
checkViewWidth
=
20
;
CGFloat
checkViewHeight
=
20
;
CGFloat
spacing
=
checkViewWidth
+
20
+
5
;
JVLayoutConstraint
*
privacyConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:spacing];
JVLayoutConstraint
*
privacyConstraintX2
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
spacing];
JVLayoutConstraint
*
privacyConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
-
10
];
JVLayoutConstraint
*
privacyConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
50
];
config.smsPrivacyConstraints
=
@[privacyConstraintX,privacyConstraintY,privacyConstraintX2,privacyConstraintH];
config.smsPrivacyHorizontalConstraints
=
config.smsPrivacyConstraints;
//勾选框
config.smsUncheckedImg
=
uncheckedImg;
config.smsCheckedImg
=
checkedImg;
JVLayoutConstraint
*
checkViewConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
checkViewConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemPrivacy
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
checkViewConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:checkViewWidth];
JVLayoutConstraint
*
checkViewConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:checkViewHeight];
config.smsCheckViewConstraints
=
@[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.smsCheckViewHorizontalConstraints
=
config.smsCheckViewConstraints;
config.smsCustomPrivacyAlertViewBlock
=
^
(
UIViewController
*
vc ,
NSArray
*
appPrivacys,void(
^
loginAction)(void)) {
UIAlertController
*
alert
=
[
UIAlertController
alertControllerWithTitle:@
"请点击同意协议"
message:appPrivacys.description preferredStyle:
UIAlertControllerStyleAlert
];
[alert addAction:[
UIAlertAction
actionWithTitle:@
"确定"
style:
UIAlertActionStyleDefault
handler:
^
(
UIAlertAction
*
_Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:
true
completion:
nil
];
};
config.smsShowWindow
=
NO
;
config.smsAutoLayout
=
YES
;
config.smsAgreementAlertViewShowWindow
=
YES
;
config.smsWindowCornerRadius
=
15
;
config.smsResetAgreementAlertViewFrameBlock
=
^
(
NSValue
*
_Nullable
*
_Nullable superViewFrame ,
NSValue
*
_Nullable
*
_Nullable alertViewFrame ,
NSValue
*
_Nullable
*
_Nullable titleFrame ,
NSValue
*
_Nullable
*
_Nullable contentFrame,
NSValue
*
_Nullable
*
_Nullable buttonFrame){
*
superViewFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
10
,
60
,
280
,
180
)];
*
alertViewFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
0
,
0
,
280
,
180
)];
*
buttonFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
CGRectGetMidX
([
*
contentFrame
CGRectValue
])
-
180
/
2
,
CGRectGetMaxY
([
*
contentFrame
CGRectValue
])
+
5
,
180
,
CGRectGetHeight
([
*
buttonFrame
CGRectValue
]))];
};
__weak __typeof(
self
)weakSelf
=
self
;
config.smsCustomAgreementAlertView
=
^
(
UIView
*
superView,void(
^
hidAlertView)(void)){
weakSelf.hidAlertView
=
hidAlertView;
UIButton
*
button
=
[
UIButton
buttonWithType:
UIButtonTypeSystem
];
button.frame
=
CGRectMake
(
10
,
50
,
60
,
40
);
[button setTitle:@
"关闭拉起"
forState:
UIControlStateNormal
];
button.backgroundColor
=
[
UIColor
greenColor];
[button addTarget:
self
action:
@selector
(buttonTouch_alerView) forControlEvents:
UIControlEventTouchUpInside
];
[superView addSubview:button];
};
config.smsAuthBtnBlock
=
^
(
NSInteger
code,
NSString
*
msg){
[
MBProgressHUD
showToast:msg duration:
3
];
};
config.isSmsAlertPrivacyVC
=
YES
;
config.smsPrivacysNavCustom
=
NO
;
config.smsTextVerAlignment
=
JVVerAlignmentTop
;
config.smsPrivacyTextAlignment
=
NSTextAlignmentLeft
;
config.smsPrivacyShowBookSymbol
=
YES
;
config.smsAutoLayout
=
YES
;
config.privacyComponents
=
@[@
"登录即同意"
,@
"文本1"
,@
"文本2"
,@
"文本3"
,@
"文本4"
,@
"文本5"
];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.smsAppPrivacys
=
@[
@
"头部文字"
,
//头部文字
@[@
""
,@
"应用自定义服务条款1"
,@
"https://www.taobao.com/"
,@
"协议1自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款2"
,@
"https://www.jiguang.cn/"
,@
"协议2自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款3"
,@
"https://www.baidu.com/"
, @
"协议3自定义标题"
],
@
"尾部文字。"
];
UIImage
*
sms_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
sms_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
sms_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(sms_nor_image
&&
sms_dis_image
&&
sms_hig_image) {
///协议二次弹窗的btn图片
config.smsAgreementAlertViewLogBtnImgs
=
@[sms_nor_image, sms_dis_image, sms_hig_image];
}
return
config;
}
-
(
JVUIConfig
*
)customSMSWindowSUI:(
JVUIConfig
*
)config {
//弹框
config.smsShowWindow
=
YES
;
config.smsWindowCornerRadius
=
10
;
config.smsWindowBackgroundAlpha
=
0.3
;
CGFloat
windowW
=
300
;
CGFloat
windowH
=
300
;
JVLayoutConstraint
*
windowConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
windowConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
windowConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:windowW];
JVLayoutConstraint
*
windowConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:windowH];
config.smsWindowConstraints
=
@[windowConstraintX,windowConstraintY,windowConstraintW,windowConstraintH];
config.smsWindowHorizontalConstraints
=
config.windowConstraints;
//弹窗close按钮
UIImage
*
window_close_nor_image
=
[
self
imageNamed:@
"windowClose"
];
UIImage
*
window_close_hig_image
=
[
self
imageNamed:@
"windowClose"
];
if
(window_close_nor_image
&&
window_close_hig_image) {
config.smsWindowCloseBtnImgs
=
@[window_close_nor_image, window_close_hig_image];
}
CGFloat
windowCloseBtnWidth
=
window_close_nor_image.size.width
?
:
15
;
CGFloat
windowCloseBtnHeight
=
window_close_nor_image.size.height
?
:
15
;;
JVLayoutConstraint
*
windowCloseBtnConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
10
];
JVLayoutConstraint
*
windowCloseBtnConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
10
];
JVLayoutConstraint
*
windowCloseBtnConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:windowCloseBtnWidth];
JVLayoutConstraint
*
windowCloseBtnConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:windowCloseBtnHeight];
config.smsWindowCloseBtnConstraints
=
@[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];
config.smsWindowCloseBtnHorizontalConstraints
=
config.windowCloseBtnConstraints;
//logo图片
config.smsLogoImg
=
[
UIImage
imageNamed:@
"cmccLogo"
];
CGFloat
smslogoWidth
=
config.smsLogoImg.size.width
?
:
100
;
CGFloat
smslogoHeight
=
smslogoWidth;
JVLayoutConstraint
*
smslogoConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
smslogoConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
150
];
JVLayoutConstraint
*
smslogoConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:smslogoWidth];
JVLayoutConstraint
*
smslogoConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:smslogoHeight];
config.smsLogoConstraints
=
@[smslogoConstraintX,smslogoConstraintY,smslogoConstraintW,smslogoConstraintH];
config.smsLogoHorizontalConstraints
=
config.smsLogoConstraints;
//slogan展示
JVLayoutConstraint
*
smsSloganConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemLogo
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
smsSloganConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemLogo
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
smsSloganConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
180
];
JVLayoutConstraint
*
smsSloganConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
config.smsSloganConstraints
=
@[smsSloganConstraintX,smsSloganConstraintY, smsSloganConstraintW, smsSloganConstraintH];
config.smsSloganHorizontalConstraints
=
config.smsSloganConstraints;
//号码输入框
JVLayoutConstraint
*
phoneTextFieldConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSlogan
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
phoneTextFieldConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSlogan
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
phoneTextFieldConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
-
40
];
JVLayoutConstraint
*
phoneTextFieldConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
30
];
config.smsNumberTFConstraints
=
@[phoneTextFieldConstraintX,phoneTextFieldConstraintY, phoneTextFieldConstraintW, phoneTextFieldConstraintH];
config.smsNumberTFHorizontalConstraints
=
config.smsNumberTFConstraints;
//验证码输入框
JVLayoutConstraint
*
codeTFConstraintsX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
codeTFConstraintsY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
codeTFConstraintsW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
codeTFConstraintsH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
0
];
config.smsCodeTFConstraints
=
@[codeTFConstraintsX,codeTFConstraintsY, codeTFConstraintsW, codeTFConstraintsH];
config.smsCodeTFHorizontalConstraints
=
config.smsCodeTFConstraints;
//获取验证码按钮
JVLayoutConstraint
*
getCodeTFConstraintsX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
getCodeTFConstraintsY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemCodeTF
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
getCodeTFConstraintsW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
150
];
JVLayoutConstraint
*
getCodeTFConstraintsH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNumberTF
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
0
];
config.smsGetCodeBtnConstraints
=
@[getCodeTFConstraintsX,getCodeTFConstraintsY, getCodeTFConstraintsW, getCodeTFConstraintsH];
config.smsGetCodeBtnHorizontalConstraints
=
config.smsGetCodeBtnConstraints;
//登录按钮
UIImage
*
login_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
login_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
login_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(login_nor_image
&&
login_dis_image
&&
login_hig_image) {
config.logBtnImgs
=
@[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat
loginButtonWidth
=
login_nor_image.size.width
?
:
100
;
CGFloat
loginButtonHeight
=
login_nor_image.size.height
?
:
100
;
JVLayoutConstraint
*
loginConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loginConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemCodeTF
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loginConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:loginButtonWidth];
JVLayoutConstraint
*
loginConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:loginButtonHeight];
config.smsLogBtnConstraints
=
@[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.smsLogBtnHorizontalConstraints
=
config.smsLogBtnConstraints;
UIImage
*
uncheckedImg
=
[
self
imageNamed:@
"checkBox_unSelected"
];
UIImage
*
checkedImg
=
[
self
imageNamed:@
"checkBox_selected"
];
CGFloat
checkViewWidth
=
20
;
CGFloat
checkViewHeight
=
20
;
CGFloat
spacing
=
checkViewWidth
+
20
+
5
;
JVLayoutConstraint
*
privacyConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:spacing];
JVLayoutConstraint
*
privacyConstraintX2
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
spacing];
JVLayoutConstraint
*
privacyConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
-
10
];
JVLayoutConstraint
*
privacyConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
50
];
config.smsPrivacyConstraints
=
@[privacyConstraintX,privacyConstraintY,privacyConstraintX2,privacyConstraintH];
config.smsPrivacyHorizontalConstraints
=
config.smsPrivacyConstraints;
//勾选框
config.smsUncheckedImg
=
uncheckedImg;
config.smsCheckedImg
=
checkedImg;
JVLayoutConstraint
*
checkViewConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
checkViewConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemPrivacy
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
checkViewConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:checkViewWidth];
JVLayoutConstraint
*
checkViewConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:checkViewHeight];
config.smsCheckViewConstraints
=
@[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.smsCheckViewHorizontalConstraints
=
config.smsCheckViewConstraints;
config.smsCustomPrivacyAlertViewBlock
=
^
(
UIViewController
*
vc ,
NSArray
*
appPrivacys,void(
^
loginAction)(void)) {
UIAlertController
*
alert
=
[
UIAlertController
alertControllerWithTitle:@
"请点击同意协议"
message:appPrivacys.description preferredStyle:
UIAlertControllerStyleAlert
];
[alert addAction:[
UIAlertAction
actionWithTitle:@
"确定"
style:
UIAlertActionStyleDefault
handler:
^
(
UIAlertAction
*
_Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:
true
completion:
nil
];
};
config.smsShowWindow
=
YES
;
config.smsAutoLayout
=
NO
;
config.smsAgreementAlertViewShowWindow
=
YES
;
config.smsWindowCornerRadius
=
15
;
config.smsResetAgreementAlertViewFrameBlock
=
^
(
NSValue
*
_Nullable
*
_Nullable superViewFrame ,
NSValue
*
_Nullable
*
_Nullable alertViewFrame ,
NSValue
*
_Nullable
*
_Nullable titleFrame ,
NSValue
*
_Nullable
*
_Nullable contentFrame,
NSValue
*
_Nullable
*
_Nullable buttonFrame){
*
superViewFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
10
,
60
,
280
,
180
)];
*
alertViewFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
0
,
0
,
280
,
180
)];
*
buttonFrame
=
[
NSValue
valueWithCGRect:
CGRectMake
(
CGRectGetMidX
([
*
contentFrame
CGRectValue
])
-
180
/
2
,
CGRectGetMaxY
([
*
contentFrame
CGRectValue
])
+
5
,
180
,
CGRectGetHeight
([
*
buttonFrame
CGRectValue
]))];
};
__weak __typeof(
self
)weakSelf
=
self
;
config.smsCustomAgreementAlertView
=
^
(
UIView
*
superView,void(
^
hidAlertView)(void)){
weakSelf.hidAlertView
=
hidAlertView;
UIButton
*
button
=
[
UIButton
buttonWithType:
UIButtonTypeSystem
];
button.frame
=
CGRectMake
(
10
,
50
,
60
,
40
);
[button setTitle:@
"关闭拉起"
forState:
UIControlStateNormal
];
button.backgroundColor
=
[
UIColor
greenColor];
[button addTarget:
self
action:
@selector
(buttonTouch_alerView) forControlEvents:
UIControlEventTouchUpInside
];
[superView addSubview:button];
};
config.smsAuthBtnBlock
=
^
(
NSInteger
code,
NSString
*
msg){
[
MBProgressHUD
showToast:msg duration:
3
];
};
config.isSmsAlertPrivacyVC
=
YES
;
config.smsPrivacysNavCustom
=
NO
;
config.smsTextVerAlignment
=
JVVerAlignmentTop
;
config.smsPrivacyTextAlignment
=
NSTextAlignmentLeft
;
config.smsPrivacyShowBookSymbol
=
YES
;
config.smsAutoLayout
=
YES
;
config.privacyComponents
=
@[@
"登录即同意"
,@
"文本1"
,@
"文本2"
,@
"文本3"
,@
"文本4"
,@
"文本5"
];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.smsAppPrivacys
=
@[
@
"头部文字"
,
//头部文字
@[@
""
,@
"应用自定义服务条款1"
,@
"https://www.taobao.com/"
,@
"协议1自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款2"
,@
"https://www.jiguang.cn/"
,@
"协议2自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款3"
,@
"https://www.baidu.com/"
, @
"协议3自定义标题"
],
@
"尾部文字。"
];
UIImage
*
sms_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
sms_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
sms_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(sms_nor_image
&&
sms_dis_image
&&
sms_hig_image) {
///协议二次弹窗的btn图片
config.smsAgreementAlertViewLogBtnImgs
=
@[sms_nor_image, sms_dis_image, sms_hig_image];
}
return
config;
}
-
(
UIViewController
*
)topViewController{
UIViewController
*
topViewController
=
[
UIApplication
sharedApplication].keyWindow.rootViewController;
while
(topViewController.presentedViewController) {
topViewController
=
topViewController.presentedViewController;
}
return
topViewController;
}
//设置授权弹窗样式UI
-
(void)customWindowUI{
JVUIConfig
*
config
=
[[
JVUIConfig
alloc]
init
];
config.navCustom
=
YES
;
config.autoLayout
=
YES
;
config.modalTransitionStyle
=
UIModalTransitionStyleCoverVertical
;
config.agreementNavTextColor
=
UIColor
.redColor;
//弹框
config.showWindow
=
YES
;
config.windowCornerRadius
=
10
;
config.windowBackgroundAlpha
=
0.3
;
// config.windowBackgroundImage = [UIImage imageNamed:@"cuccLogo"];
CGFloat
windowW
=
300
;
CGFloat
windowH
=
300
;
JVLayoutConstraint
*
windowConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
windowConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
windowConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:windowW];
JVLayoutConstraint
*
windowConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:windowH];
config.windowConstraints
=
@[windowConstraintX,windowConstraintY,windowConstraintW,windowConstraintH];
config.windowHorizontalConstraints
=
config.windowConstraints;
config.agreementNavText
=
[[
NSAttributedString
alloc]initWithString:@
"运营商自定义标题"
attributes:@{
NSForegroundColorAttributeName
:[
UIColor
whiteColor]}];
config.firstPrivacyAgreementNavText
=
[[
NSAttributedString
alloc]initWithString:@
"协议1自定义标题"
attributes:@{
NSForegroundColorAttributeName
:[
UIColor
whiteColor],
NSFontAttributeName
:[
UIFont
boldSystemFontOfSize:
18
]}];
config.secondPrivacyAgreementNavText
=
[[
NSAttributedString
alloc]initWithString:@
"协议2自定义标题"
attributes:@{
NSForegroundColorAttributeName
:[
UIColor
whiteColor]}];
//弹窗close按钮
UIImage
*
window_close_nor_image
=
[
self
imageNamed:@
"windowClose"
];
UIImage
*
window_close_hig_image
=
[
self
imageNamed:@
"windowClose"
];
if
(window_close_nor_image
&&
window_close_hig_image) {
config.windowCloseBtnImgs
=
@[window_close_nor_image, window_close_hig_image];
}
CGFloat
windowCloseBtnWidth
=
window_close_nor_image.size.width
?
:
15
;
CGFloat
windowCloseBtnHeight
=
window_close_nor_image.size.height
?
:
15
;;
JVLayoutConstraint
*
windowCloseBtnConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
5
];
JVLayoutConstraint
*
windowCloseBtnConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
5
];
JVLayoutConstraint
*
windowCloseBtnConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:windowCloseBtnWidth];
JVLayoutConstraint
*
windowCloseBtnConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:windowCloseBtnHeight];
config.windowCloseBtnConstraints
=
@[windowCloseBtnConstraintX,windowCloseBtnConstraintY,windowCloseBtnConstraintW,windowCloseBtnConstraintH];
config.windowCloseBtnHorizontalConstraints
=
config.windowCloseBtnConstraints;
//logo
config.logoImg
=
[
UIImage
imageNamed:@
"cmccLogo"
];
CGFloat
logoWidth
=
config.logoImg.size.width
?
:
100
;
CGFloat
logoHeight
=
logoWidth;
JVLayoutConstraint
*
logoConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
logoConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
10
];
JVLayoutConstraint
*
logoConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:logoWidth];
JVLayoutConstraint
*
logoConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:logoHeight];
config.logoConstraints
=
@[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints
=
config.logoConstraints;
//号码栏
JVLayoutConstraint
*
numberConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
numberConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
130
];
JVLayoutConstraint
*
numberConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
130
];
JVLayoutConstraint
*
numberConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
25
];
config.numberConstraints
=
@[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints
=
config.numberConstraints;
//slogan展示
JVLayoutConstraint
*
sloganConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
sloganConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
160
];
JVLayoutConstraint
*
sloganConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
130
];
JVLayoutConstraint
*
sloganConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
config.sloganConstraints
=
@[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints
=
config.sloganConstraints;
//登录按钮
UIImage
*
login_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
login_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
login_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(login_nor_image
&&
login_dis_image
&&
login_hig_image) {
config.logBtnImgs
=
@[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat
loginButtonWidth
=
login_nor_image.size.width
?
:
100
;
CGFloat
loginButtonHeight
=
login_nor_image.size.height
?
:
100
;
JVLayoutConstraint
*
loginConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loginConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
180
];
JVLayoutConstraint
*
loginConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:loginButtonWidth];
JVLayoutConstraint
*
loginConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:loginButtonHeight];
config.logBtnConstraints
=
@[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints
=
config.logBtnConstraints;
//勾选框
UIImage
*
uncheckedImg
=
[
self
imageNamed:@
"checkBox_unSelected"
];
UIImage
*
checkedImg
=
[
self
imageNamed:@
"checkBox_selected"
];
CGFloat
checkViewWidth
=
30
;
CGFloat
checkViewHeight
=
30
;
config.uncheckedImg
=
uncheckedImg;
config.checkedImg
=
checkedImg;
JVLayoutConstraint
*
checkViewConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
checkViewConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemPrivacy
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
checkViewConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:checkViewWidth];
JVLayoutConstraint
*
checkViewConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:checkViewHeight];
config.checkViewConstraints
=
@[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints
=
config.checkViewConstraints;
//隐私---旧方法
CGFloat
spacing
=
checkViewWidth
+
20
+
5
;
config.privacyState
=
YES
;
config.appPrivacyOne
=
@[@
"应用自定义服务条款1"
,@
"https://www.jiguang.cn/about"
];
config.appPrivacyTwo
=
@[@
"应用自定义服务条款2"
,@
"https://www.jiguang.cn/about"
];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.appPrivacys
=
@[
@
"头部文字"
,
//头部文字
@[@
"、"
,@
"应用自定义服务条款1"
,@
"https://www.taobao.com/"
,@
"协议1自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款2"
,@
"https://www.jiguang.cn/"
,@
"协议2自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款3"
,@
"https://www.baidu.com/"
, @
"协议3自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款4"
,@
"https://www.taobao.com/"
,@
"协议4自定义标题"
],
@[@
"、"
,@
"应用自定义服务条款5"
,@
"https://www.taobao.com/"
,@
"协议5自定义标题"
],
@
"尾部文字。"
];
JVLayoutConstraint
*
privacyConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:spacing];
JVLayoutConstraint
*
privacyConstraintX2
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
spacing];
JVLayoutConstraint
*
privacyConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
-
20
];
JVLayoutConstraint
*
privacyConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
50
];
config.privacyConstraints
=
@[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints
=
config.privacyConstraints;
//loading
JVLayoutConstraint
*
loadingConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loadingConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loadingConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loadingConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
30
];
config.loadingConstraints
=
@[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
config.loadingHorizontalConstraints
=
config.loadingConstraints;
/*
config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
config.navColor = [UIColor redColor];
config.preferredStatusBarStyle = UIStatusBarStyleDefault;
config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 44, 44);
button.backgroundColor = [UIColor greenColor];
config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
config.logoHidden = NO;
config.logBtnText = @"自定义登录按钮文字";
config.logBtnTextColor = [UIColor redColor];
config.numberColor = [UIColor blueColor];
config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
config.sloganTextColor = [UIColor redColor];
config.navCustom = NO;
config.numberSize = 24;
config.privacyState = YES;
*/
config.authPageGifImagePath
=
[[
NSBundle
mainBundle] pathForResource:@
"auth"
ofType:@
"gif"
];
NSString
*
urlStr
=
@
"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4"
;
// [config setVideoBackgroudResource:urlStr placeHolder:@"cmBackground.jpeg"];
[
JVERIFICATIONService
customUIWithConfig:[
self
customSMSWindowSUI:config] customViews:
^
(
UIView
*
customAreaView) {
/*
//添加一个自定义label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
UILabel
*
autoLabel
=
[[
UILabel
alloc]
init
];
autoLabel.text
=
@
"这是一个自定义autoLable"
;
[autoLabel sizeToFit];
[customAreaView addSubview:autoLabel];
autoLabel.translatesAutoresizingMaskIntoConstraints
=
NO
;
NSLayoutConstraint
*
constraintCenterX
=
[
NSLayoutConstraint
constraintWithItem:autoLabel attribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:customAreaView attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
10
];
NSLayoutConstraint
*
constraintCenterY
=
[
NSLayoutConstraint
constraintWithItem:autoLabel attribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:customAreaView attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
10
];
NSLayoutConstraint
*
constarintW
=
[
NSLayoutConstraint
constraintWithItem:autoLabel attribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
nil
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
50
];
NSLayoutConstraint
*
constarintH
=
[
NSLayoutConstraint
constraintWithItem:autoLabel attribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
nil
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
[autoLabel addConstraint:constarintW];
[autoLabel addConstraint:constarintH];
[customAreaView addConstraint:constraintCenterX];
[customAreaView addConstraint:constraintCenterY];
}];
}
此代码块在浮窗中显示
授权页面添加自定义控件
支持的版本
开始支持的版本 2.1.0
接口定义
+ (void)customUIWithConfig:(JVUIConfig *)UIConfig customViews:(void(^)(UIView *customAreaView))customViewsBlk;
接口说明:
自定义授权页面 UI 样式，并添加自定义控件
参数说明:
UIConfig JVUIConfig 的子类
customViewsBlk 添加自定义视图的 block
调用示例:
OC
JVUIConfig *config = [[JVUIConfig alloc] init];
config.navCustom = NO;
// config.prefersStatusBarHidden = YES;
config.shouldAutorotate = YES;
config.autoLayout = YES;
// config.orientation = UIInterfaceOrientationPortrait;
config.navReturnHidden = NO;
config.privacyTextFontSize = 12;
config.navText = [[NSAttributedString alloc]initWithString:@"登录统一认证" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
// config.navColor = [UIColor redColor];
// config.navBarBackGroundImage = [UIImage imageNamed:@"cmccLogo"];
config.privacyTextAlignment = NSTextAlignmentLeft;
// config.numberFont = [UIFont systemFontOfSize:10];
// config.logBtnFont = [UIFont systemFontOfSize:5];
// config.privacyShowBookSymbol = YES;
// config.privacyLineSpacing = 5;
// config.agreementNavBackgroundColor = [UIColor redColor];
// config.sloganFont = [UIFont systemFontOfSize:30];
// config.checkViewHidden = YES;
config.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
/*
config.customLoadingViewBlock = ^(UIView *View) {
//https://github.com/jdg/MBProgressHUD
MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:View animated:YES];
hub.backgroundColor = [UIColor clearColor];
hub.label.text = @"正在登录..";
[hub showAnimated:YES];
};
*/
/*
config.customPrivacyAlertViewBlock = ^(UIViewController *vc , NSArray *appPrivacys,void(^loginAction)(void)) {
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:appPrivacys.description preferredStyle:UIAlertControllerStyleAlert];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:true completion:nil];
};
*/
//logo
config.logoImg = [UIImage imageNamed:@"cmccLogo"];
CGFloat logoWidth = config.logoImg.size.width?:100;
CGFloat logoHeight = logoWidth;
JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-90];
JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints = config.logoConstraints;
// 号码栏
JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-55];
JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];
config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints = config.numberConstraints;
//slogan 展示
JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:-20];
JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
config.sloganConstraints = @[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints = config.sloganConstraints;
// 登录按钮
UIImage *login_nor_image = [self imageNamed:@"loginBtn_Nor"];
UIImage *login_dis_image = [self imageNamed:@"loginBtn_Dis"];
UIImage *login_hig_image = [self imageNamed:@"loginBtn_Hig"];
if (login_nor_image && login_dis_image && login_hig_image) {config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat loginButtonWidth = login_nor_image.size.width?:100;
CGFloat loginButtonHeight = login_nor_image.size.height?:100;
JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:30];
JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints = config.logBtnConstraints;
// 勾选框
UIImage * uncheckedImg = [self imageNamed:@"checkBox_unSelected"];
UIImage * checkedImg = [self imageNamed:@"checkBox_selected"];
CGFloat checkViewWidth = uncheckedImg.size.width;
CGFloat checkViewHeight = uncheckedImg.size.height;
config.uncheckedImg = uncheckedImg;
config.checkedImg = checkedImg;
JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints = config.checkViewConstraints;
// 隐私
CGFloat spacing = checkViewWidth + 20 + 5;
config.privacyState = YES;
JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:spacing];
JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeRight multiplier:1 constant:-spacing];
JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints = config.privacyConstraints;
//loading
JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
config.loadingHorizontalConstraints = config.loadingConstraints;
/*
config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
config.navColor = [UIColor redColor];
config.preferredStatusBarStyle = 0;
config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 44, 44);
button.backgroundColor = [UIColor greenColor];
config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
config.logoHidden = NO;
config.logBtnText = @"自定义登录按钮文字";
config.logBtnTextColor = [UIColor redColor];
config.numberColor = [UIColor blueColor];
config.appPrivacyOne = @[@"应用自定义服务条款 1",@"https://www.jiguang.cn/about"];
config.appPrivacyTwo = @[@"应用自定义服务条款 2",@"https://www.jiguang.cn/about"];
config.privacyComponents = @[@"文本 1",@"文本 2",@"文本 3",@"文本 4"];
config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
config.sloganTextColor = [UIColor redColor];
config.navCustom = NO;
config.numberSize = 24;
config.privacyState = YES;
*/
[JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
/*
// 添加一个自定义 label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义 label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
}];
Swift
let config = JVUIConfig()
// 导航栏
config.navCustom = false
config.navText = NSAttributedString.init(string: "登录统一认证", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18)])
config.navReturnHidden = false
config.shouldAutorotate = true
config.autoLayout = true
// 弹窗弹出方式
config.modalTransitionStyle = UIModalTransitionStyle.coverVertical
//logo
config.logoImg = UIImage(named: "cmccLogo")
let logoWidth = config.logoImg?.size.width ?? 100
let logoHeight = logoWidth
let logoConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
let logoConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -90)
let logoConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: logoWidth)
let logoConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant: logoHeight)
config.logoConstraints = [logoConstraintX!,logoConstraintY!,logoConstraintW!,logoConstraintH!]
config.logoHorizontalConstraints = config.logoConstraints
// 号码栏
let numberConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
let numberConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:-55)
let numberConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:130)
let numberConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:25)
config.numberConstraints = [numberConstraintX!, numberConstraintY!, numberConstraintW!, numberConstraintH!]
config.numberHorizontalConstraints = config.numberConstraints
//slogan
let sloganConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
let sloganConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:-20)
let sloganConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:130)
let sloganConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:20)
config.sloganConstraints = [sloganConstraintX!, sloganConstraintY!, sloganConstraintW!, sloganConstraintH!]
config.sloganHorizontalConstraints = config.sloganConstraints
// 登录按钮
let login_nor_image = imageNamed(name: "loginBtn_Nor")
let login_dis_image = imageNamed(name: "loginBtn_Dis")
let login_hig_image = imageNamed(name: "loginBtn_Hig")
if let norImage = login_nor_image, let disImage = login_dis_image, let higImage = login_hig_image {config.logBtnImgs = [norImage, disImage, higImage]
}
let loginBtnWidth = login_nor_image?.size.width ?? 100
let loginBtnHeight = login_nor_image?.size.height ?? 100
let loginConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
let loginConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:30)
let loginConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:loginBtnWidth)
let loginConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:loginBtnHeight)
config.logBtnConstraints = [loginConstraintX!, loginConstraintY!, loginConstraintW!, loginConstraintH!]
config.logBtnHorizontalConstraints = config.logBtnConstraints
// 勾选框
let uncheckedImage = imageNamed(name: "checkBox_unSelected")
let checkedImage = imageNamed(name: "checkBox_selected")
let checkViewWidth = uncheckedImage?.size.width ?? 10
let checkViewHeight = uncheckedImage?.size.height ?? 10
config.uncheckedImg = uncheckedImage
config.checkedImg = checkedImage
let checkViewConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant:20)
let checkViewConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.privacy, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:0)
let checkViewConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:checkViewWidth)
let checkViewConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:checkViewHeight)
config.checkViewConstraints = [checkViewConstraintX!, checkViewConstraintY!, checkViewConstraintW!, checkViewConstraintH!]
config.checkViewHorizontalConstraints = config.checkViewConstraints
// 隐私
let spacing = checkViewWidth + 20 + 5
config.privacyState = true
config.privacyTextFontSize = 12
config.privacyTextAlignment = NSTextAlignment.left
config.appPrivacyOne = ["应用自定义服务条款 1","应用自定义服务条款 2"]
let privacyConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1, constant:spacing)
let privacyConstraintX2 = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant:-spacing)
let privacyConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant:-10)
let privacyConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:50)
config.privacyConstraints = [privacyConstraintX!,privacyConstraintX2!, privacyConstraintY!, privacyConstraintH!]
config.privacyHorizontalConstraints = config.privacyConstraints
//loading
let loadingConstraintX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:0)
let loadingConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant:0)
let loadingConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant:30)
let loadingConstraintH = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1, constant:30)
config.loadingConstraints = [loadingConstraintX!, loadingConstraintY!, loadingConstraintW!, loadingConstraintH!]
config.loadingHorizontalConstraints = config.loadingConstraints
JVERIFICATIONService.customUI(with: config) {(customView) in
// 自定义 view, 加到 customView 上
guard let customV = customView else {return}
let label = UILabel()
label.text = "customLabel"
label.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
customV.addSubview(label)
}
OC
JVUIConfig
*
config
=
[[
JVUIConfig
alloc]
init
];
config.navCustom
=
NO
;
// config.prefersStatusBarHidden = YES;
config.shouldAutorotate
=
YES
;
config.autoLayout
=
YES
;
// config.orientation = UIInterfaceOrientationPortrait;
config.navReturnHidden
=
NO
;
config.privacyTextFontSize
=
12
;
config.navText
=
[[
NSAttributedString
alloc]initWithString:@
"登录统一认证"
attributes:@{
NSForegroundColorAttributeName
:[
UIColor
whiteColor],
NSFontAttributeName
:[
UIFont
systemFontOfSize:
18
]}];
// config.navColor = [UIColor redColor];
// config.navBarBackGroundImage = [UIImage imageNamed:@"cmccLogo"];
config.privacyTextAlignment
=
NSTextAlignmentLeft
;
// config.numberFont = [UIFont systemFontOfSize:10];
// config.logBtnFont = [UIFont systemFontOfSize:5];
// config.privacyShowBookSymbol = YES;
// config.privacyLineSpacing = 5;
// config.agreementNavBackgroundColor = [UIColor redColor];
// config.sloganFont = [UIFont systemFontOfSize:30];
// config.checkViewHidden = YES;
config.modalTransitionStyle
=
UIModalTransitionStyleCoverVertical
;
/*
config.customLoadingViewBlock = ^(UIView *View) {
//https://github.com/jdg/MBProgressHUD
MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:View animated:YES];
hub.backgroundColor = [UIColor clearColor];
hub.label.text = @"正在登录..";
[hub showAnimated:YES];
};
*/
/*
config.customPrivacyAlertViewBlock = ^(UIViewController *vc , NSArray *appPrivacys,void(^loginAction)(void)) {
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请点击同意协议" message:appPrivacys.description preferredStyle:UIAlertControllerStyleAlert];
[alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:true completion:nil];
};
*/
//logo
config.logoImg
=
[
UIImage
imageNamed:@
"cmccLogo"
];
CGFloat
logoWidth
=
config.logoImg.size.width
?
:
100
;
CGFloat
logoHeight
=
logoWidth;
JVLayoutConstraint
*
logoConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
logoConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
90
];
JVLayoutConstraint
*
logoConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:logoWidth];
JVLayoutConstraint
*
logoConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:logoHeight];
config.logoConstraints
=
@[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints
=
config.logoConstraints;
// 号码栏
JVLayoutConstraint
*
numberConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
numberConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
55
];
JVLayoutConstraint
*
numberConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
130
];
JVLayoutConstraint
*
numberConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
25
];
config.numberConstraints
=
@[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints
=
config.numberConstraints;
//slogan 展示
JVLayoutConstraint
*
sloganConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
sloganConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-
20
];
JVLayoutConstraint
*
sloganConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
130
];
JVLayoutConstraint
*
sloganConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
config.sloganConstraints
=
@[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints
=
config.sloganConstraints;
// 登录按钮
UIImage
*
login_nor_image
=
[
self
imageNamed:@
"loginBtn_Nor"
];
UIImage
*
login_dis_image
=
[
self
imageNamed:@
"loginBtn_Dis"
];
UIImage
*
login_hig_image
=
[
self
imageNamed:@
"loginBtn_Hig"
];
if
(login_nor_image
&&
login_dis_image
&&
login_hig_image) {config.logBtnImgs
=
@[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat
loginButtonWidth
=
login_nor_image.size.width
?
:
100
;
CGFloat
loginButtonHeight
=
login_nor_image.size.height
?
:
100
;
JVLayoutConstraint
*
loginConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loginConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loginConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:loginButtonWidth];
JVLayoutConstraint
*
loginConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:loginButtonHeight];
config.logBtnConstraints
=
@[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints
=
config.logBtnConstraints;
// 勾选框
UIImage
*
uncheckedImg
=
[
self
imageNamed:@
"checkBox_unSelected"
];
UIImage
*
checkedImg
=
[
self
imageNamed:@
"checkBox_selected"
];
CGFloat
checkViewWidth
=
uncheckedImg.size.width;
CGFloat
checkViewHeight
=
uncheckedImg.size.height;
config.uncheckedImg
=
uncheckedImg;
config.checkedImg
=
checkedImg;
JVLayoutConstraint
*
checkViewConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:
20
];
JVLayoutConstraint
*
checkViewConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemPrivacy
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
checkViewConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:checkViewWidth];
JVLayoutConstraint
*
checkViewConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:checkViewHeight];
config.checkViewConstraints
=
@[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints
=
config.checkViewConstraints;
// 隐私
CGFloat
spacing
=
checkViewWidth
+
20
+
5
;
config.privacyState
=
YES
;
JVLayoutConstraint
*
privacyConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:spacing];
JVLayoutConstraint
*
privacyConstraintX2
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeRight
multiplier:
1
constant:
-
spacing];
JVLayoutConstraint
*
privacyConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
-
10
];
JVLayoutConstraint
*
privacyConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
50
];
config.privacyConstraints
=
@[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints
=
config.privacyConstraints;
//loading
JVLayoutConstraint
*
loadingConstraintX
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loadingConstraintY
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemSuper
attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint
*
loadingConstraintW
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
30
];
JVLayoutConstraint
*
loadingConstraintH
=
[
JVLayoutConstraint
constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:
JVLayoutItemNone
attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
30
];
config.loadingConstraints
=
@[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
config.loadingHorizontalConstraints
=
config.loadingConstraints;
/*
config.authPageBackgroundImage = [UIImage imageNamed:@"背景图"];
config.navColor = [UIColor redColor];
config.preferredStatusBarStyle = 0;
config.navText = [[NSAttributedString alloc] initWithString:@"自定义标题"];
config.navReturnImg = [UIImage imageNamed:@"自定义返回键"];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
button.frame = CGRectMake(0, 0, 44, 44);
button.backgroundColor = [UIColor greenColor];
config.navControl = [[UIBarButtonItem alloc] initWithCustomView:button];
config.logoHidden = NO;
config.logBtnText = @"自定义登录按钮文字";
config.logBtnTextColor = [UIColor redColor];
config.numberColor = [UIColor blueColor];
config.appPrivacyOne = @[@"应用自定义服务条款 1",@"https://www.jiguang.cn/about"];
config.appPrivacyTwo = @[@"应用自定义服务条款 2",@"https://www.jiguang.cn/about"];
config.privacyComponents = @[@"文本 1",@"文本 2",@"文本 3",@"文本 4"];
config.appPrivacyColor = @[[UIColor redColor], [UIColor blueColor]];
config.sloganTextColor = [UIColor redColor];
config.navCustom = NO;
config.numberSize = 24;
config.privacyState = YES;
*/
[
JVERIFICATIONService
customUIWithConfig:config customViews:
^
(
UIView
*
customAreaView) {
/*
// 添加一个自定义 label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义 label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
}];
Swift
let
config
=
JVUIConfig
()
// 导航栏
config.navCustom
=
false
config.navText
=
NSAttributedString
.
init
(string:
"登录统一认证"
, attributes: [
NSAttributedString
.
Key
.foregroundColor:
UIColor
.white,
NSAttributedString
.
Key
.font:
UIFont
.systemFont(ofSize:
18
)])
config.navReturnHidden
=
false
config.shouldAutorotate
=
true
config.autoLayout
=
true
// 弹窗弹出方式
config.modalTransitionStyle
=
UIModalTransitionStyle
.coverVertical
//logo
config.logoImg
=
UIImage
(named:
"cmccLogo"
)
let
logoWidth
=
config.logoImg
?
.size.width
??
100
let
logoHeight
=
logoWidth
let
logoConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerX, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerX, multiplier:
1
, constant:
0
)
let
logoConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.bottom, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerY, multiplier:
1
, constant:
-
90
)
let
logoConstraintW
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.width, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.width, multiplier:
1
, constant: logoWidth)
let
logoConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant: logoHeight)
config.logoConstraints
=
[logoConstraintX
!
,logoConstraintY
!
,logoConstraintW
!
,logoConstraintH
!
]
config.logoHorizontalConstraints
=
config.logoConstraints
// 号码栏
let
numberConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerX, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerX, multiplier:
1
, constant:
0
)
let
numberConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerY, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerY, multiplier:
1
, constant:
-
55
)
let
numberConstraintW
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.width, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.width, multiplier:
1
, constant:
130
)
let
numberConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant:
25
)
config.numberConstraints
=
[numberConstraintX
!
, numberConstraintY
!
, numberConstraintW
!
, numberConstraintH
!
]
config.numberHorizontalConstraints
=
config.numberConstraints
//slogan
let
sloganConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerX, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerX, multiplier:
1
, constant:
0
)
let
sloganConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.bottom, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerY, multiplier:
1
, constant:
-
20
)
let
sloganConstraintW
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.width, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.width, multiplier:
1
, constant:
130
)
let
sloganConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant:
20
)
config.sloganConstraints
=
[sloganConstraintX
!
, sloganConstraintY
!
, sloganConstraintW
!
, sloganConstraintH
!
]
config.sloganHorizontalConstraints
=
config.sloganConstraints
// 登录按钮
let
login_nor_image
=
imageNamed(name:
"loginBtn_Nor"
)
let
login_dis_image
=
imageNamed(name:
"loginBtn_Dis"
)
let
login_hig_image
=
imageNamed(name:
"loginBtn_Hig"
)
if
let
norImage
=
login_nor_image,
let
disImage
=
login_dis_image,
let
higImage
=
login_hig_image {config.logBtnImgs
=
[norImage, disImage, higImage]
}
let
loginBtnWidth
=
login_nor_image
?
.size.width
??
100
let
loginBtnHeight
=
login_nor_image
?
.size.height
??
100
let
loginConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerX, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerX, multiplier:
1
, constant:
0
)
let
loginConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.bottom, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerY, multiplier:
1
, constant:
30
)
let
loginConstraintW
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.width, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.width, multiplier:
1
, constant:loginBtnWidth)
let
loginConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant:loginBtnHeight)
config.logBtnConstraints
=
[loginConstraintX
!
, loginConstraintY
!
, loginConstraintW
!
, loginConstraintH
!
]
config.logBtnHorizontalConstraints
=
config.logBtnConstraints
// 勾选框
let
uncheckedImage
=
imageNamed(name:
"checkBox_unSelected"
)
let
checkedImage
=
imageNamed(name:
"checkBox_selected"
)
let
checkViewWidth
=
uncheckedImage
?
.size.width
??
10
let
checkViewHeight
=
uncheckedImage
?
.size.height
??
10
config.uncheckedImg
=
uncheckedImage
config.checkedImg
=
checkedImage
let
checkViewConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.left, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.left, multiplier:
1
, constant:
20
)
let
checkViewConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerY, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.privacy, attribute:
NSLayoutConstraint
.
Attribute
.centerY, multiplier:
1
, constant:
0
)
let
checkViewConstraintW
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.width, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.width, multiplier:
1
, constant:checkViewWidth)
let
checkViewConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant:checkViewHeight)
config.checkViewConstraints
=
[checkViewConstraintX
!
, checkViewConstraintY
!
, checkViewConstraintW
!
, checkViewConstraintH
!
]
config.checkViewHorizontalConstraints
=
config.checkViewConstraints
// 隐私
let
spacing
=
checkViewWidth
+
20
+
5
config.privacyState
=
true
config.privacyTextFontSize
=
12
config.privacyTextAlignment
=
NSTextAlignment
.left
config.appPrivacyOne
=
[
"应用自定义服务条款 1"
,
"应用自定义服务条款 2"
]
let
privacyConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.left, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.left, multiplier:
1
, constant:spacing)
let
privacyConstraintX2
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.right, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.right, multiplier:
1
, constant:
-
spacing)
let
privacyConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.bottom, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.bottom, multiplier:
1
, constant:
-
10
)
let
privacyConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant:
50
)
config.privacyConstraints
=
[privacyConstraintX
!
,privacyConstraintX2
!
, privacyConstraintY
!
, privacyConstraintH
!
]
config.privacyHorizontalConstraints
=
config.privacyConstraints
//loading
let
loadingConstraintX
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerX, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerX, multiplier:
1
, constant:
0
)
let
loadingConstraintY
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.centerY, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.super, attribute:
NSLayoutConstraint
.
Attribute
.centerY, multiplier:
1
, constant:
0
)
let
loadingConstraintW
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.width, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.width, multiplier:
1
, constant:
30
)
let
loadingConstraintH
=
JVLayoutConstraint
(attribute:
NSLayoutConstraint
.
Attribute
.height, relatedBy:
NSLayoutConstraint
.
Relation
.equal, to:
JVLayoutItem
.none, attribute:
NSLayoutConstraint
.
Attribute
.height, multiplier:
1
, constant:
30
)
config.loadingConstraints
=
[loadingConstraintX
!
, loadingConstraintY
!
, loadingConstraintW
!
, loadingConstraintH
!
]
config.loadingHorizontalConstraints
=
config.loadingConstraints
JVERIFICATIONService
.customUI(with: config) {(customView)
in
// 自定义 view, 加到 customView 上
guard
let
customV
=
customView
else
{
return
}
let
label
=
UILabel
()
label.text
=
"customLabel"
label.frame
=
CGRect
(x:
0
, y:
0
, width:
60
, height:
30
)
customV.addSubview(label)
}
此代码块在浮窗中显示
创建 JVLayoutConstraint 布局对象
+(instancetype _Nullable )constraintWithAttribute:(NSLayoutAttribute)attr1
relatedBy:(NSLayoutRelation)relation
toItem:(JVLayoutItem)item
attribute:(NSLayoutAttribute)attr2
multiplier:(CGFloat)multiplier
constant:(CGFloat)c;
接口说明:
创建 JVLayoutConstraint 布局对象
参数说明:
attr1 约束类型
relation 与参照视图之间的约束关系
item 参照 item
attr2 参照 item 约束类型
multiplier 乘数
c 常量
调用示例:
CGFloat windowW = 300;
CGFloat windowH = 300;
JVLayoutConstraint *windowConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
JVLayoutConstraint *windowConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
JVLayoutConstraint *windowConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:windowW];
JVLayoutConstraint *windowConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:windowH];
config.windowConstraints = @[windowConstraintX,windowConstraintY,windowConstraintW,windowConstraintH];
CGFloat
windowW =
300
;
CGFloat
windowH =
300
;
JVLayoutConstraint *windowConstraintX = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeCenterX
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeCenterX
multiplier:
1
constant:
0
];
JVLayoutConstraint *windowConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
0
];
JVLayoutConstraint *windowConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:windowW];
JVLayoutConstraint *windowConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:windowH];
config.windowConstraints = @[windowConstraintX,windowConstraintY,windowConstraintW,windowConstraintH];
此代码块在浮窗中显示
JVLayoutItem 枚举
枚举值
枚举说明
JVLayoutItemNone
不参照任何item。可用来直接设置width、height
JVLayoutItemLogo
参照logo视图
JVLayoutItemNumber
参照号码栏
JVLayoutItemNumberTF
短信页面手机号输入框
JVLayoutItemCodeTF
短信页面验证码输入框
JVLayoutItemGetCode
短信页面获取验证码按钮
JVLayoutItemSlogan
参照标语栏
JVLayoutItemLogin
参照登录按钮
JVLayoutItemCheck
参照隐私选择框
JVLayoutItemPrivacy
参照隐私栏
JVLayoutItemSuper
参照父视图
JVLayoutConstraint 类
属性说明：
参数名称
参数类型
参数说明
firstAttribute
NSLayoutAttribute
约束类型
relation
NSLayoutRelation
与参考视图之间的约束关系
item
JVLayoutItem
参照 item
attr2
NSLayoutAttribute
参照 item 约束类型
multiplier
CGFloat
乘数
c
CGFloat
常量
JVAuthConfig 类
应用配置信息类。以下是属性说明：
参数名称
参数类型
参数说明
AppKey
NSString
极光系统应用唯一标识，必填
channel
NSString
应用发布渠道，可选
advertisingId
NSString
广告标识符，可选
timeout
NSTimeInterval
设置初始化超时时间，单位毫秒，合法范围是(0,30000]，推荐设置为 5000-10000, 默认值为 10000
isProduction
BOOL
是否生产环境。如果为开发状态，设置为 NO；如果为生产状态，应改为 YES。可选，默认为 NO
authBlock
Block
初始化回调，包含 code 和 content 两个参数。在 timeout 时间内未完成则返回超时
设置一键登录页面背景视频方法
+(
void
)setVideoBackgroudResource:(NSString *)path placeHolder:(NSString *)imageName;
参数说明
path 视频路径支持在线 url 或者本地视频路径
imageName 视频未准备好播放时的占位图片名称
调用示例
// 在线视频
NSString *urlStr = @"在线视频地址";
/*
本地视频
NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"本地视频文件地址" ofType:@"本地文件类型"];
**/
[config setVideoBackgroudResource:urlStr placeHolder:@"cmBackground.jpeg"];
// 在线视频
NSString *urlStr =
@"在线视频地址"
;
/*
本地视频
NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"本地视频文件地址" ofType:@"本地文件类型"];
**/
[
config setVideoBackgroudResource:urlStr placeHolder:@
"cmBackground.jpeg"
];
此代码块在浮窗中显示
JVUIConfig 类
授权界面 UI 配置基类。以下是属性说明：
授权页面设置
参数名称
参数类型
参数说明
authPageBackgroundImage
UIImage
授权界面背景图片
authPageGifImagePath
NSString
授权界面背景 gif 资源路径，与 authPageBackgroundImage 属性互斥
autoLayout
BOOL
是否使用 autoLayout，默认 YES，
shouldAutorotate
BOOL
是否支持自动旋转 默认 YES
orientation
UIInterfaceOrientation
设置进入授权页的屏幕方向，不支持 UIInterfaceOrientationPortraitUpsideDown
modalTransitionStyle
UIModalTransitionStyle
授权页弹出方式, 弹窗模式下不支持 UIModalTransitionStylePartialCurl
dismissAnimationFlag
BOOL
关闭授权页是否有动画。默认 YES, 有动画。参数仅作用于以下两种情况：1、一键登录接口设置登录完成后，自动关闭授权页 2、用户点击授权页关闭按钮，关闭授权页
多语言配置
参数名称
参数类型
参数说明
appLanguageType
JVLanguageType
配置授权页面的语言，可以配置的值：JVLanguageSimplifiedChinese-简体中文; JVLanguageTraditionalChinese-繁体中文; JVLanguageEnglish-英文
导航栏
参数名称
参数类型
参数说明
navCustom
BOOL
是否隐藏导航栏（适配全屏图片）
navColor
UIColor
导航栏颜色
barStyle
UIBarStyle
此方法从 v2.5.0 版本开始已废弃。建议使用 preferredStatusBarStyle 控制状态栏。preferredStatusBarStyle 默认为 UIStatusBarStyleDefault, 当 barStyle 的效果和 preferredStatusBarStyle 冲突时，barStyle 的效果会失效。
preferredStatusBarStyle
UIStatusBarStyle
授权页 preferred status bar style，取代 barStyle 参数
navText
NSAttributedString
导航栏标题
navReturnImg
UIImage
导航返回图标
navControl
UIBarButtonItem
导航栏右侧自定义控件
prefersStatusBarHidden
BOOL
竖屏情况下，是否隐藏状态栏。默认 NO. 在项目的 Info.plist 文件里设置 UIViewControllerBasedStatusBarAppearance 为 YES. 注意：弹窗模式下无效，是否隐藏由外部控制器控制
navTransparent
BOOL
导航栏是否透明，默认不透明。此参数和 navBarBackGroundImage 冲突，应避免同时使用
navReturnHidden
BOOL
导航栏默认返回按钮隐藏，默认不隐藏
navReturnImageEdgeInsets
UIEdgeInsets
导航栏返回按钮图片缩进, 默认为 UIEdgeInsetsZero
navDividingLineHidden
BOOL
导航栏分割线是否隐藏，默认隐藏
navBarBackGroundImage
UIImage
导航栏背景图片. 此参数和 navTransparent 冲突，应避免同时使用
LOGO
参数名称
参数类型
参数说明
logoImg
UIImage
LOGO 图片
logoWidth
CGFloat
LOGO 图片宽度
logoHeight
CGFloat
LOGO 图片高度
logoOffsetY
CGFloat
LOGO 图片偏移量
logoConstraints
NSArray
LOGO 图片布局对象
logoHorizontalConstraints
NSArray
LOGO 图片 横屏布局，横屏时优先级高于 logoConstraints
logoHidden
BOOL
LOGO 图片隐藏
登录按钮
参数名称
参数类型
参数说明
logBtnText
NSString
登录按钮文本
logBtnOffsetY
CGFloat
登录按钮 Y 偏移量
logBtnConstraints
NSArray
登录按钮布局对象
logBtnHorizontalConstraints
NSArray
登录按钮 横屏布局，横屏时优先级高于 logBtnConstraints
logBtnTextColor
UIImage
登录按钮文本颜色
logBtnFont
UIFont
登录按钮字体，默认跟随系统
logBtnImgs
UIColor
登录按钮背景图片添加到数组(顺序如下) @[激活状态的图片, 失效状态的图片, 高亮状态的图片]
手机号码
参数名称
参数类型
参数说明
numberColor
UIColor
手机号码字体颜色
numberSize
CGFloat
手机号码字体大小
numberFont
UIFont
手机号码字体，优先级高于 numberSize
numFieldOffsetY
CGFloat
号码栏 Y 偏移量
numberConstraints
NSArray
号码栏布局对象
numberHorizontalConstraints
NSArray
号码栏 横屏布局, 横屏时优先级高于 numberConstraints
checkBox
参数名称
参数类型
参数说明
uncheckedImg
UIImage
checkBox 未选中时图片
checkedImg
UIImage
checkBox 选中时图片
checkViewConstraints
NSArray
checkBox 布局对象
checkViewHorizontalConstraints
NSArray
checkBox 横屏布局，横屏优先级高于 checkViewConstraints
checkViewHidden
BOOL
checkBox 是否隐藏，默认不隐藏
privacyState
BOOL
隐私条款 check 框默认状态 默认:NO
隐私协议栏
参数名称
参数类型
参数说明
appPrivacyOne
NSArray
隐私条款一: 数组（务必按顺序）@[条款名称, 条款链接]；支持在线文件和 NSBundle 本地文件，沙盒中文件仅支持 NSTemporaryDirectory()路径下文件，274 及之后版本设置无效
appPrivacyTwo
NSArray
隐私条款二: 数组（务必按顺序）@[条款名称, 条款链接]；支持在线文件和 NSBundle 本地文件，沙盒中文件仅支持 NSTemporaryDirectory()路径下文件，274 及之后版本设置无效
appPrivacyColor
UIImage
隐私条款名称颜色 @[基础文字颜色, 条款颜色]
privacyTextFontSize
CGFloat
隐私条款字体大小，默认 12
privacyOffsetY
CGFloat
隐私条款 Y 偏移量(注: 此属性为与屏幕底部的距离)
privacyComponents
NSArray
隐私条款拼接文本数组
privacyConstraints
NSArray
隐私条款布局对象
privacyHorizontalConstraints
NSArray
隐私条款 横屏布局，横屏下优先级高于 privacyConstraints
privacyTextFontSize
CGFloat
隐私条款字体大小，默认 12
privacyTextAlignment
NSTextAlignment
隐私条款文本对齐方式，目前仅支持 left、center
privacyShowBookSymbol
BOOL
隐私条款是否显示书名号，默认不显示
privacyLineSpacing
CGFloat
隐私条款行距，默认跟随系统
customPrivacyAlertViewBlock
Block 类型
自定义 Alert view, 当隐私条款未选中时, 点击登录按钮时回调。当此参数存在时, 未选中隐私条款的情况下，登录按钮可以被点击，block 内部参数为自定义 Alert view 可被添加的控制器，详细用法可参见示例 demo
isAlertPrivacyVC
BOOL 类型
是否在未勾选隐私协议的情况下 弹窗提示窗口
appPrivacys
NSArray
隐私条款组合: 数组 @[privacyComponents, 条款名称, 条款链接] 条款链接， 支持在线文件和 NSBundle 本地文件， 沙盒中文件仅支持 NSTemporaryDirectory() 路径下文件 since2.7.4
openPrivacyInBrowser
BOOL
隐私协议点击是否用浏览器打开，默认否。since 2.9.4
隐私协议栏添加辅文本属性
(
void
)addPrivacyTextAttribute:(NSAttributedStringKey *)name value: (
id
)value range:(NSRange)range;
参数说明
name NSAttributedStringKey
value NSAttributedStringKey 对应的值
range 对应字符串范围
调用示例
[config addPrivacyTextAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range: NSMakeRange(5, 10)];
[config addPrivacyTextAttribute:
NSUnderlineStyleAttributeName
value:@(
NSUnderlineStyleSingle
) range:
NSMakeRange
(
5
,
10
)];
此代码块在浮窗中显示
隐私协议页面
参数名称
参数类型
参数说明
agreementNavBackgroundColor
UIColor
协议页导航栏背景颜色
agreementNavText
NSAttributedString
运营商协议的协议页面导航栏标题
firstPrivacyAgreementNavText
NSAttributedString
自定义协议 1 的协议页面导航栏标题
secondPrivacyAgreementNavText
NSAttributedString
自定义协议 2 的协议页面导航栏标题
agreementNavReturnImage
UIImage
协议页导航栏返回按钮图片
agreementPreferredStatusBarStyle
UIStatusBarStyle
协议页 preferred status bar style，取代 barStyle 参数
agreementNavTextFont
UIFont
设置授权页点击隐私协议，进入协议页时, 协议页自定义导航栏标题的字体 当 agreementNavText、secondPrivacyAgreementNavText、 firstPrivacyAgreementNavText 存在时不生效 since2.7.4
agreementNavTextColor
UIColor
设置授权页点击隐私协议，进入协议页时, 协议页自定义导航栏标题的颜色 当 agreementNavText、secondPrivacyAgreementNavText、 firstPrivacyAgreementNavText 存在时不生效 since2.7.4
slogan
参数名称
参数类型
参数说明
sloganOffsetY
CGFloat
slogan 偏移量 Y
sloganConstraints
NSArray
slogan 布局对象
sloganHorizontalConstraints
NSArray
slogan 横屏布局, 横屏下优先级高于 sloganConstraints
sloganTextColor
UIColor
slogan 文字颜色
sloganFont
UIFont
slogan 文字 font, 默认 12
loading
参数名称
参数类型
参数说明
loadingConstraints
NSArray
loading 布局对象
loadingHorizontalConstraints
NSArray
默认 loading 横屏布局，横屏下优先级高于 loadingConstraints
customLoadingViewBlock
Block 类型
自定义 loading view, 当授权页点击登录按钮时回调。当此参数存在时, 默认 loading view 不会显示, 需开发者自行设计 loading view。block 内部参数为自定义 loading view 可被添加的父视图，详细用法可参见示例 demo
弹窗
参数名称
参数类型
参数说明
showWindow
BOOL
是否弹窗，默认 no
windowBackgroundImage
UIImage
弹框内部背景图片
windowBackgroundAlpha
CGFloat
弹窗外侧 透明度 0~1.0
windowCornerRadius
CGFloat
弹窗圆角数值
windowConstraints
NSArray
弹窗布局对象
windowHorizontalConstraints
NSArray
弹窗横屏布局，横屏下优先级高于 windowConstraints
windowCloseBtnImgs
NSArray
弹窗 close 按钮图片 @[普通状态图片，高亮状态图片]
windowCloseBtnConstraints
NSArray
弹窗 close 按钮布局
windowCloseBtnHorizontalConstraints
NSArray
弹窗 close 按钮 横屏布局, 横屏下优先级高于 windowCloseBtnConstraints
协议二次弹窗（未勾选协议默认提示弹窗）
参数名称
参数类型
参数说明
agreementAlertViewBackgroundColor
UIColor
协议二次弹窗背景颜色
agreementAlertViewBackgroundImage
UIImage
协议二次弹窗背景图片
agreementAlertViewTitleText
NSString
协议二次弹窗标题文本
agreementAlertViewTitleTexFont
UIFont
协议二次弹窗标题文本样式
agreementAlertViewTitleTextColor
UIColor
协议二次弹窗标题文本颜色
agreementAlertViewContentTextAlignment
NSTextAlignment
协议二次弹窗内容文本对齐方式
agreementAlertViewContentTextFontSize
NSInteger
协议二次弹窗内容文本字体大小
agreementAlertViewLogBtnImgs
NSArray
协议二次弹窗登录按钮背景图片添加到数组
agreementAlertViewLogBtnTextColor
UIColor
协议二次弹窗登录按钮文本颜色
agreementAlertViewLogBtnText
NSString
协议二次弹窗登录按钮文本
agreementAlertViewLogBtnTextFontSize
NSInteger
协议二次弹窗登录按钮文本字体大小
短信登录界面 UI 配置基类。以下是属性说明：
短信登录页面设置
参数名称
参数类型
参数说明
smsAuthPageBackgroundImage
UIImage
短信登录页面背景图片
smsAuthPageGifImagePath
NSString
短信登录页面背景 gif 资源路径，与 smsAuthPageBackgroundImage 属性互斥
smsAutoLayout
BOOL
是否使用 autoLayout，默认 YES，
shouldAutorotate
BOOL
是否支持自动旋转 默认 YES
orientation
UIInterfaceOrientation
设置进入短信登录页面的屏幕方向，不支持 UIInterfaceOrientationPortraitUpsideDown
modalTransitionStyle
UIModalTransitionStyle
短信登录页面弹出方式, 弹窗模式下不支持 UIModalTransitionStylePartialCurl
dismissAnimationFlag
BOOL
关闭短信登录页面是否有动画。默认 YES, 有动画。参数仅作用于以下两种情况：1、一键登录接口/短信登录接口设置登录完成后，自动关闭授权页 2、用户点击短信登录页面关闭按钮，关闭短信登录页面
导航栏
参数名称
参数类型
参数说明
smsPrivacysNavCustom
BOOL
是否隐藏导航栏（适配全屏图片）
navColor
UIColor
导航栏颜色
barStyle
UIBarStyle
此方法从 v2.5.0 版本开始已废弃。建议使用 preferredStatusBarStyle 控制状态栏。preferredStatusBarStyle 默认为 UIStatusBarStyleDefault, 当 barStyle 的效果和 preferredStatusBarStyle 冲突时，barStyle 的效果会失效。
preferredStatusBarStyle
UIStatusBarStyle
授权页 preferred status bar style，取代 barStyle 参数
smsNavText
NSAttributedString
导航栏标题
navReturnImg
UIImage
导航返回图标
navControl
UIBarButtonItem
导航栏右侧自定义控件
prefersStatusBarHidden
BOOL
竖屏情况下，是否隐藏状态栏。默认 NO. 在项目的 Info.plist 文件里设置 UIViewControllerBasedStatusBarAppearance 为 YES. 注意：弹窗模式下无效，是否隐藏由外部控制器控制
navTransparent
BOOL
导航栏是否透明，默认不透明。此参数和 navBarBackGroundImage 冲突，应避免同时使用
navReturnHidden
BOOL
导航栏默认返回按钮隐藏，默认不隐藏
navReturnImageEdgeInsets
UIEdgeInsets
导航栏返回按钮图片缩进, 默认为 UIEdgeInsetsZero
navDividingLineHidden
BOOL
导航栏分割线是否隐藏，默认隐藏
navBarBackGroundImage
UIImage
导航栏背景图片. 此参数和 navTransparent 冲突，应避免同时使用
LOGO
参数名称
参数类型
参数说明
smsLogoImg
UIImage
LOGO 图片
smsLogoConstraints
NSArray
LOGO 图片布局对象
smsLogoHorizontalConstraints
NSArray
LOGO 图片 横屏布局，横屏时优先级高于 smsLogoConstraints
smsLogoHidden
BOOL
LOGO 图片隐藏
手机号输入框
参数名称
参数类型
参数说明
smsNumberTFPlaceholder
NSString
手机号码输入框默认提示语
smsNumberTFColor
UIColor
手机号码输入框字体颜色
smsNumberTFSize
CGFloat
手机号码输入框字体大小
smsNumberTFFont
UIFont
手机号码输入框字体，优先级高于numberSize
smsNumberTFConstraints
NSArray
手机号码输入框布局对象
smsNumberTFHorizontalConstraints
NSArray
手机号码输入框 横屏布局,横屏时优先级高于numberConstraints
验证码输入框
参数名称
参数类型
参数说明
smsCodeTFPlaceholder
NSString
手机号码输入框默认提示语
smsCodeTFColor
UIColor
手机号码输入框字体颜色
smsCodeTFSize
CGFloat
手机号码输入框字体大小
smsCodeTFFont
UIFont
手机号码输入框字体，优先级高于numberSize
smsCodeTFConstraints
NSArray
手机号码输入框布局对象
smsCodeTFHorizontalConstraints
NSArray
手机号码输入框 横屏布局,横屏时优先级高于numberConstraints
获取验证码按钮
参数名称
参数类型
参数说明
smsGetCodeBtnCornerRadius
CGFloat
获取验证码按钮圆角度数
smsGetCodeBtnText
NSString
获取验证码按钮文本
smsGetCodeBtnConstraints
NSArray
获取验证码布局对象
smsGetCodeBtnHorizontalConstraints
NSArray
获取验证码 横屏布局，横屏时优先级高于logBtnConstraints
smsGetCodeBtnTextColor
UIColor
获取验证码文本颜色
smsGetCodeBtnAttributedString
UIFont
获取验证码字体，默认跟随系统
smsGetCodeBtnImgs
NSArray
获取验证码背景图片添加到数组(顺序如下) @[激活状态的图片,失效状态的图片,高亮状态的图片]
登录按钮
参数名称
参数类型
参数说明
smsLogBtnText
NSString
登录按钮文本
smsLogBtnConstraints
NSArray
登录按钮布局对象
smsLogBtnHorizontalConstraints
NSArray
登录按钮 横屏布局，横屏时优先级高于logBtnConstraints
smsLogBtnTextColor
UIColor
登录按钮文本颜色
smsLogBtnAttributedString
UIFont
登录按钮字体，默认跟随系统
smsLogBtnImgs
NSArray
登录按钮背景图片添加到数组(顺序如下) @[激活状态的图片,失效状态的图片,高亮状态的图片]
checkBox
参数名称
参数类型
参数说明
smsUncheckedImg
UIImage
复选框未选中时图片
smsCheckedImg
UIImage
复选框选中时图片
smsCheckViewConstraints
NSArray
复选框布局对象
smsCheckViewHorizontalConstraints
NSArray
复选框 横屏布局，横屏优先级高于checkViewConstraints
smsCheckViewHidden
BOOL
复选框是否隐藏，默认不隐藏
隐私协议栏
参数名称
参数类型
参数说明
smsAppPrivacyColor
UIImage
隐私条款名称颜色 @[基础文字颜色,条款颜色]
smsPrivacyTextFontSize
CGFloat
隐私条款字体大小，默认12
smsPrivacyComponents
NSArray
隐私条款拼接文本数组
smsPrivacyConstraints
NSArray
隐私条款布局对象
smsPrivacyHorizontalConstraints
NSArray
隐私条款 横屏布局，横屏下优先级高于privacyConstraints
smsPrivacyTextAlignment
NSTextAlignment
隐私条款文本对齐方式，目前仅支持 left、center
smsPrivacyLineSpacing
CGFloat
隐私条款行距，默认跟随系统
隐私协议页面
参数名称
参数类型
参数说明
agreementNavBackgroundColor
UIColor
协议页导航栏背景颜色
agreementNavText
NSAttributedString
运营商协议的协议页面导航栏标题
firstPrivacyAgreementNavText
NSAttributedString
自定义协议 1 的协议页面导航栏标题
secondPrivacyAgreementNavText
NSAttributedString
自定义协议 2 的协议页面导航栏标题
agreementNavReturnImage
UIImage
协议页导航栏返回按钮图片
agreementPreferredStatusBarStyle
UIStatusBarStyle
协议页 preferred status bar style，取代 barStyle 参数
agreementNavTextFont
UIFont
设置授权页点击隐私协议，进入协议页时, 协议页自定义导航栏标题的字体 当 agreementNavText、secondPrivacyAgreementNavText、 firstPrivacyAgreementNavText 存在时不生效 since2.7.4
agreementNavTextColor
UIColor
设置授权页点击隐私协议，进入协议页时, 协议页自定义导航栏标题的颜色 当 agreementNavText、secondPrivacyAgreementNavText、 firstPrivacyAgreementNavText 存在时不生效 since2.7.4
slogan
参数名称
参数类型
参数说明
smsSloganConstraints
NSArray
slogan布局对象
smsSloganHorizontalConstraints
NSArray
slogan 横屏布局,横屏下优先级高于sloganConstraints
smsSloganTextColor
UIColor
slogan文字颜色
smsSloganFont
UIFont
slogan文字font,默认12
loading
参数名称
参数类型
参数说明
loadingConstraints
NSArray
loading 布局对象
loadingHorizontalConstraints
NSArray
默认 loading 横屏布局，横屏下优先级高于 loadingConstraints
customLoadingViewBlock
Block 类型
自定义 loading view, 当授权页点击登录按钮时回调。当此参数存在时, 默认 loading view 不会显示, 需开发者自行设计 loading view。block 内部参数为自定义 loading view 可被添加的父视图，详细用法可参见示例 demo
弹窗
参数名称
参数类型
参数说明
smsShowWindow
BOOL
是否弹窗，默认no
smsWindowBackgroundImage
UIImage
弹框内部背景图片
smsWindowBackgroundAlpha
CGFloat
弹窗外侧 透明度 0~1.0
smsWindowCornerRadius
CGFloat
弹窗圆角数值
smsWindowConstraints
NSArray
弹窗布局对象
smsWindowHorizontalConstraints
NSArray
弹窗横屏布局，横屏下优先级高于windowConstraints
smsWindowCloseBtnImgs
NSArray
弹窗close按钮图片 @[普通状态图片，高亮状态图片]
smsWindowCloseBtnConstraints
NSArray
弹窗close按钮布局
smsWindowCloseBtnHorizontalConstraints
NSArray
弹窗close按钮 横屏布局,横屏下优先级高于windowCloseBtnConstraints
协议二次弹窗（未勾选协议默认提示弹窗）
参数名称
参数类型
参数说明
smsAgreementAlertViewBackgroundColor
UIColor
协议二次弹窗背景颜色
smsAgreementAlertViewBackgroundImage
UIImage
协议二次弹窗背景图片
smsAgreementAlertViewTitleText
NSString
协议二次弹窗标题文本
smsAgreementAlertViewTitleTexFont
UIFont
协议二次弹窗标题文本样式
smsAgreementAlertViewTitleTextColor
UIColor
协议二次弹窗标题文本颜色
smsAgreementAlertViewContentTextAlignment
NSTextAlignment
协议二次弹窗内容文本对齐方式
smsAgreementAlertViewContentTextFontSize
NSInteger
协议二次弹窗内容文本字体大小
smsAgreementAlertViewLogBtnImgs
NSArray
协议二次弹窗登录按钮背景图片添加到数组
smsAgreementAlertViewLogBtnTextColor
UIColor
协议二次弹窗登录按钮文本颜色
smsAgreementAlertViewLogBtnText
NSString
协议二次弹窗登录按钮文本
smsAgreementAlertViewLogBtnTextFontSize
NSInteger
协议二次弹窗登录按钮文本字体大小
SDK 请求授权一键登录（旧）
支持的版本
开始支持的版本 2.4.0
接口定义
+ (void)getAuthorizationWithController:(UIViewController *)vc hide:(BOOL)hide completion:(void (^)(NSDictionary *result))completion actionBlock:(void(^)(NSInteger type, NSString *content))actionBlock
接口说明:
授权登录
参数说明:
completion 登录结果
result 字典 获取到 token 时 key 有 operator、code、loginToken 字段，获取不到 token 是 key 为 code 和 content 字段
vc 当前控制器
hide 完成后是否自动隐藏授权页。
actionBlock 授权页事件触发回调。包含type和content两个参数，type为事件类型，content为事件描述。 type = 1,授权页被关闭;type=2,授权页面被拉起；type=3,协议被点击；type=4,获取验证码按钮被点击；type=6,checkBox变为选中；type=7,checkBox变为未选中；type=8,登录按钮被点击
调用示例:
[JVERIFICATIONService getAuthorizationWithController:self hide:YES completion:^(NSDictionary *result) {NSLog(@"一键登录 result:%@", result);
} actionBlock:^(NSInteger type, NSString *content) {NSLog(@"一键登录 actionBlock :%ld %@", (long)type , content);}];
[JVERIFICATIONService getAuthorizationWithController:
self
hide:
YES
completion:^(
NSDictionary
*result) {
NSLog
(
@"一键登录 result:%@"
, result);
} actionBlock:^(
NSInteger
type,
NSString
*content) {
NSLog
(
@"一键登录 actionBlock :%ld %@"
, (
long
)type , content);}];
此代码块在浮窗中显示
SDK 请求授权一键登录（旧）
支持的版本
开始支持的版本 2.3.0
接口定义
+ (void)getAuthorizationWithController:(UIViewController *)vc hide:(BOOL)hide completion:(void (^)(NSDictionary *result))completion
接口说明:
授权一键登录
参数说明:
completion 登录结果
result 字典 获取到 token 时 key 有 operator、code、loginToken 字段，获取不到 token 是 key 为 code 和 content 字段
vc 当前控制器
hide 完成后是否自动隐藏授权页，默认 YES。若此字段设置为 NO，请在收到一键登录回调后调用 SDK 提供的关闭授权页面方法。
调用示例:
[JVERIFICATIONService getAuthorizationWithController:self hide:YES completion:^(NSDictionary *result) {NSLog(@"一键登录 result:%@", result);
}];
[JVERIFICATIONService getAuthorizationWithController:
self
hide:
YES
completion:^(
NSDictionary
*result) {
NSLog
(
@"一键登录 result:%@"
, result);
}];
此代码块在浮窗中显示
号码认证
初始化
调用 SDK 其他流程方法前，请确保已调用过初始化，否则会返回未初始化，详情参考
SDK 初始化 API
。初始化后，如您调用如下功能接口，视为您同意开启极光安全认证相关业务功能，我们会收集业务功能必要的个人信息并上报。
判断网络环境是否支持
判断当前的手机网络环境是否可以使用号码认证，若网络支持，再调用号码认证 API，否则请调用其他认证方式的 API，详情参考
判断网络环境是否支持 API
。
获取号码认证 token
支持的版本
开始支持的版本 2.2.0
接口定义
+ (void)getToken:(NSTimeInterval)timeout completion:(void (^)(NSDictionary * result))completion;
接口说明:
获取手机号校验 token
参数说明
completion 参数是字典 返回 token 、错误码等相关信息，token 有效期 1 分钟, 一次认证后失效
result 字典 获取到 token 时 key 有 operator、code、token 字段，获取不到 token 是 key 为 code 和 content 字段
timeout 超时时间（毫秒）, 有效取值范围(0,10000]. 为保证获取 token 的成功率，建议设置为 3000-5000ms.
调用示例:
OC
[JVERIFICATIONService getToken:(NSTimeInterval)timeout completion:^(NSDictionary *result) {NSLog(@"getToken result:%@", result)
//TODO: 获取 token 后相关操作
}];
Swift
JVERIFICATIONService.getToken {(result) in
if let result = result {if let token = result["token"] {if let code = result["code"], let op = result["operator"] {print("get token result: code = \(code), operator = \(op), token = \(token)")}}else if let code = result["code"], let content = result["content"] {print("get token result: code = \(code), content = \(content)")}}
}
OC
[
JVERIFICATIONService
getToken:(
NSTimeInterval
)timeout completion:
^
(
NSDictionary
*
result) {
NSLog
(@
"getToken result:%@"
, result)
//
TODO:
获取 token 后相关操作
}];
Swift
JVERIFICATIONService
.getToken {(result)
in
if
let
result
=
result {
if
let
token
=
result[
"token"
] {
if
let
code
=
result[
"code"
],
let
op
=
result[
"operator"
] {
print
(
"get token result: code =
\(code)
, operator =
\(op)
, token =
\(token)
"
)}}
else
if
let
code
=
result[
"code"
],
let
content
=
result[
"content"
] {
print
(
"get token result: code =
\(code)
, content =
\(content)
"
)}}
}
此代码块在浮窗中显示
说明
：开发者可以通过 SDK 获取 token 接口的回调信息来选择验证方式，若成功获取到 token 则可以继续使用极光认证进行号码验证；若获取 token 失败，需要换用短信验证码等方式继续完成验证。
获取号码认证 token（新）
支持的版本
开始支持的版本 2.2.0
接口定义
+ (void)getTokenWithEnableSms:(BOOL)enableSms timeout:(NSTimeInterval)timeout completion:(void (^)(NSDictionary * result))completion;
接口说明:
获取手机号校验 token
参数说明
completion 参数是字典 返回 token 、错误码等相关信息，token 有效期 1 分钟, 一次认证后失效
result 字典 获取到 token 时 key 有 operator、code、token 字段，获取不到 token 是 key 为 code 和 content 字段
timeout 超时时间（毫秒）, 有效取值范围(0,10000]. 为保证获取 token 的成功率，建议设置为 3000-5000ms.
enableSms 是否在获取号码认证失败时，切换至短信登录
调用示例:
OC
[JVERIFICATIONService getTokenWithEnableSms:(BOOL)enableSms timeout:(NSTimeInterval)timeout completion:^(NSDictionary *result) {NSLog(@"getToken result:%@", result)
//TODO: 获取 token 后相关操作
}];
Swift
JVERIFICATIONService.getTokenWithEnableSms(true, timeout: 5000) {(result) in
if let result = result {if let token = result["token"] {if let code = result["code"], let op = result["operator"] {print("get token result: code = \(code), operator = \(op), token = \(token)")}}else if let code = result["code"], let content = result["content"] {print("get token result: code = \(code), content = \(content)")}}
}
OC
[
JVERIFICATIONService
getTokenWithEnableSms:(
BOOL
)enableSms timeout:(
NSTimeInterval
)timeout completion:
^
(
NSDictionary
*
result) {
NSLog
(@
"getToken result:%@"
, result)
//
TODO:
获取 token 后相关操作
}];
Swift
JVERIFICATIONService
.getTokenWithEnableSms(
true
, timeout:
5000
) {(result)
in
if
let
result
=
result {
if
let
token
=
result[
"token"
] {
if
let
code
=
result[
"code"
],
let
op
=
result[
"operator"
] {
print
(
"get token result: code =
\(code)
, operator =
\(op)
, token =
\(token)
"
)}}
else
if
let
code
=
result[
"code"
],
let
content
=
result[
"content"
] {
print
(
"get token result: code =
\(code)
, content =
\(content)
"
)}}
}
此代码块在浮窗中显示
说明
：开发者可以通过 SDK 获取 token 接口的回调信息来选择验证方式，若成功获取到 token 则可以继续使用极光认证进行号码验证；若获取 token 失败，需要换用短信验证码等方式继续完成验证。
短信登录
SDK 短信登录
支持的版本
开始支持的版本 3.1.0
接口定义
+(void)getSMSAuthorizationWithController:(UIViewController *)vc hide:(BOOL)hide animated:(BOOL)animationFlag timeout:(NSTimeInterval)timeout completionHandler:(void (^ _Nonnull)(NSDictionary * _Nonnull result)) handler actionBlock:(void (^)(NSInteger, NSString * ))actionBlock
接口说明
获取短信验证码，使用此功能需要在 Portal 控制台中极光短信模块添加短信签名和验证码短信模版，或者使用默认的签名或模版。详见：
操作指南
。
通过此接口获得到短信验证码后，需要调用极光验证码验证 API 来进行验证，详见：
验证码验证 API
。
参数说明
completion 登录结果
result 字典 获取到token时key有operator、code、msg字段
vc 当前控制器
hide 完成后是否自动隐藏授权页。
animationFlag 拉起短信登录时是否需要动画效果，默认YES
timeout 超时。单位毫秒，合法范围是(0,30000]，默认值为10000。此参数作用于拉起登录页面后，点击登录页登录按钮获取登录结果超时。
actionBlock 授权页事件触发回调。包含type和content两个参数，type为事件类型，content为事件描述。 type = 1,授权页被关闭;type=2,授权页面被拉起；type=3,协议被点击；type=4,获取验证码按钮被点击；type=6,checkBox变为选中；type=7,checkBox变为未选中；type=8,登录按钮被点击
调用示例
[JVERIFICATIONService getSMSAuthorizationWithController:self hide:YES animated:YES timeout:5*1000 completion:^(NSDictionary *result) {
NSLog(@"短信登录 result:%@", result);
} actionBlock:^(NSInteger type, NSString *content) {
NSLog(@"短信登录 actionBlock :%ld %@", (long)type , content);
}];
[JVERIFICATIONService getSMSAuthorizationWithController:
self
hide:
YES
animated:
YES
timeout:
5
*
1000
completion:^(
NSDictionary
*result) {
NSLog
(
@"短信登录 result:%@"
, result);
} actionBlock:^(
NSInteger
type,
NSString
*content) {
NSLog
(
@"短信登录 actionBlock :%ld %@"
, (
long
)type , content);
}];
此代码块在浮窗中显示
验证码
SDK 获取验证码
支持的版本
开始支持的版本 2.6.0
接口定义
+(void)getSMSCode:(NSString *)phoneNumber templateID:(NSString * _Nullable)templateID signID:(NSString * _Nullable)signID completionHandler:(void (^ _Nonnull)(NSDictionary * _Nonnull result) ) handler
接口说明
获取短信验证码，使用此功能需要在 Portal 控制台中极光短信模块添加申请短信签名和验证码短信模版。详见：
操作指南
。
通过此接口获得到短信验证码后，需要调用极光验证码验证 API 来进行验证，详见：
验证码验证 API
。
参数说明
phoneNumber：电话号码
signID：短信签名 ID，如果为 null，则为所设置的默认短信签名 ID
templateID：短信模板 ID
handler ：block 回调 成功的时返回的 result 字典包含 uuid ,code, msg 字段，uuid 为此次获取的唯一标识码, 失败时 result 字段仅返回 code, msg 字段
调用示例
[JVERIFICATIONService getSMSCode:@"手机号" templateID:@"" signID:@"" completionHandler:^(NSDictionary * _Nonnull result) {NSLog(@"getSMSCodeWithPhoneNumber result :%@",result);
}];
[JVERIFICATIONService getSMSCode:
@"手机号"
templateID:
@""
signID:
@""
completionHandler:^(
NSDictionary
* _Nonnull result) {
NSLog
(
@"getSMSCodeWithPhoneNumber result :%@"
,result);
}];
此代码块在浮窗中显示
设置前后两次获取验证码的时间间隔
支持的版本
开始支持的版本 2.6.0
接口定义
+ (void)setGetCodeInternal:(NSTimeInterval)intervalTime
接口说明
设置前后两次获取验证码的时间间隔，单位 ms 默认 30000ms，有效范围(0,300000)
参数说明
intervalTime：时间间隔，单位是毫秒(ms)
调用示例
[JVERIFICATIONService setGetCodeInternal:30000]
[
JVERIFICATIONService setGetCodeInternal:30000
]
此代码块在浮窗中显示
扩展业务相关设置
可选个人信息设置
调用此 API 来配置可选个人信息采集
请在初始化函数之前调用该接口
支持的版本
开始支持的版本 3.1.7, 需要配合JCore iOS SDK v4.6.0及以上版本使用
接口定义
+ (void)setCollectControl:(JVCollectControl*)control
接口说明
调用此 API 来配置可选个人信息采集。
参数说明
control：采集控制项配置类。
调用示例
JVCollectControl *collectControl = [[JVCollectControl alloc] init];
collectControl.cell = YES;
[JVERIFICATIONService setCollectControl:collectControl];
JVCollectControl *collectControl = [[JVCollectControl alloc]
init
];
collectControl.cell = YES;
[
JVERIFICATIONService setCollectControl:collectControl
];
此代码块在浮窗中显示
JVCollectControl 控制类
基站采集开关
@property (nonatomic, assign) BOOL cell;
@property
(
nonatomic
,
assign
)
BOOL
cell;
此代码块在浮窗中显示
方法说明
配置基站信息采集开关，默认为YES，NO-不允许采集
安全风控接口
请在初始化函数之前调用该接口
支持的版本
开始支持的版本 3.2.2
接口定义
+ (void)setSecureControl:(BOOL)enable
接口说明
如果有安全风控需求时可调用该接口。
参数说明
enable: YES为打开，NO为关闭，默认为YES。
调用示例
[JVERIFICATIONService setSecureControl:NO];
[JVERIFICATIONService setSecureControl:NO]
;
此代码块在浮窗中显示
文档内容是否对您有帮助？
提交评分
本页目录
SDK 接口说明
设置 Debug 模式
SDK 初始化
支持回调参数
获取 SDK 初始化状态
判断网络环境是否支持
判断网络环境是否支持 （支持移动香港卡）
校验预取号缓存是否有效
是否获取地理位置信息
一键登录
初始化
判断网络环境是否支持
预取号
清除预取号缓存
拉起授权页面
拉起授权页面
关闭授权页面
自定义授权页面 UI 样式
授权页面添加自定义控件
创建 JVLayoutConstraint 布局对象
JVLayoutItem 枚举
JVLayoutConstraint 类
JVAuthConfig 类
JVUIConfig 类
SDK 请求授权一键登录（旧）
SDK 请求授权一键登录（旧）
号码认证
初始化
判断网络环境是否支持
获取号码认证 token
获取号码认证 token（新）
短信登录
SDK 短信登录
验证码
SDK 获取验证码
设置前后两次获取验证码的时间间隔
扩展业务相关设置
可选个人信息设置
安全风控接口
代码浮窗
