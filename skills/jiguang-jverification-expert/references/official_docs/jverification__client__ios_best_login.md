# 极光安全认证_iOS 一键登录最佳实践 - 极光文档

- Source: https://docs.jiguang.cn/jverification/client/ios_best_login
- Fetched at (UTC): 2026-02-28 13:44:59Z

## Snapshot Text

极光文档
>
极光安全认证
>
客户端 SDK
>
iOS SDK
>
iOS 一键登录最佳实践
iOS 最佳实践指南
最近更新：2024-06-17
本页目录
一键登录流程说明
1、初始化
2、预取号
3、设置授权页面UI样式
4、拉起授权页面
iOS 最佳实践指南
本文旨要介绍 iOS SDK 一键登录的最佳实践方式。
一键登录流程说明
初始化 SDK->获取运营商预取号->设置授权页面 UI 样式->拉起授权页面
1、初始化
我们建议在AppDelegate.m的application:didFinishLaunchingWithOptions:方法中初始化SDK。
SDK 初始化的牧目的是为了提前拉取运营商配置，提前拉取运行商配置有助于提高一键登录的速度。
#import "AppDelegate.h"
#import "JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
// 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingI
NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
JVAuthConfig *config = [[JVAuthConfig alloc] init];
config.appKey = @"your appkey";
config.advertisingId = idfaStr;
config.timeout = 5000;
config.authBlock = ^(NSDictionary *result) {
NSLog(@"初始化结果 result:%@", result);
};
[JVERIFICATIONService setupWithConfig:config];
return YES;
}
#import
"AppDelegate.h"
#import
"JVERIFICATIONService.h"
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import
<AdSupport/AdSupport.h>
@implementation
AppDelegate
- (
BOOL
)application:(
UIApplication
*)application didFinishLaunchingWithOptions:(
NSDictionary
*)launchOptions {
// 如需使用 IDFA 功能请添加此代码并在初始化配置类中设置 advertisingI
NSString
*idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
JVAuthConfig *config = [[JVAuthConfig alloc] init];
config.appKey =
@"your appkey"
;
config.advertisingId = idfaStr;
config.timeout =
5000
;
config.authBlock = ^(
NSDictionary
*result) {
NSLog
(
@"初始化结果 result:%@"
, result);
};
[JVERIFICATIONService setupWithConfig:config];
return
YES
;
}
此代码块在浮窗中显示
2、预取号
API：
预取号
预取号是通过运营商获取登录token的前置步骤，所以我们建议在进入需要使用一键登录的页面后，先调用预取号接口，这样当用户真正要使用一键登录的时候可以减少预取号加载时间，提升用户体验。
我们建议用户增加一个字段存储预取号接口状态！
//增加一个字段存储预取号接口状态
static BOOL finishPrelogin = YES;
- (void)viewDidLoad {
[super viewDidLoad];
//建议在页面加载时进行获取预取号
[self preLogin];
}
- (void)preLogin {
// 先判断SDK初始化状态
if ([JVERIFICATIONService isSetupClient]) {
finishPrelogin = NO;
[JVERIFICATIONService preLogin:5000 completion:^(NSDictionary * _Nonnull result) {
// 回调响应结果，建议用户增加一个字段存储预取号接口状态
finishPrelogin = YES;
}];
}
}
//增加一个字段存储预取号接口状态
static
BOOL
finishPrelogin =
YES
;
- (
void
)viewDidLoad {
[
super
viewDidLoad];
//建议在页面加载时进行获取预取号
[
self
preLogin];
}
- (
void
)preLogin {
// 先判断SDK初始化状态
if
([JVERIFICATIONService isSetupClient]) {
finishPrelogin =
NO
;
[JVERIFICATIONService preLogin:
5000
completion:^(
NSDictionary
* _Nonnull result) {
// 回调响应结果，建议用户增加一个字段存储预取号接口状态
finishPrelogin =
YES
;
}];
}
}
此代码块在浮窗中显示
3、设置授权页面UI样式
API：
自定义授权页面 UI 样式
在拉起授权登录页面之前，建议设置自定义的页面样式以呈现更好的页面效果。
- (void)loginAuth {
//一些前置操作，例如：判断是否处于预取号中，加载HUD等等
..............
//建议拉起授权页面之前设置自定义UI
[self setUIConfig];
//以下为拉起授权页面部分
..............
}
- (void)setUIConfig{
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
- (
void
)loginAuth {
//一些前置操作，例如：判断是否处于预取号中，加载HUD等等
..............
//建议拉起授权页面之前设置自定义UI
[
self
setUIConfig];
//以下为拉起授权页面部分
..............
}
- (
void
)setUIConfig{
JVUIConfig *config = [[JVUIConfig alloc] init];
config.prefersStatusBarHidden =
YES
;
config.shouldAutorotate =
YES
;
config.openPrivacyInBrowser =
NO
;
config.autoLayout =
YES
;
config.agreementNavTextColor = [
UIColor
redColor];
config.navReturnHidden =
NO
;
config.privacyTextFontSize =
12
;
config.navText = [[
NSAttributedString
alloc]initWithString:
@"登录统一认证"
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
config.privacyTextAlignment =
NSTextAlignmentLeft
;
config.numberFont = [
UIFont
boldSystemFontOfSize:
12
];
config.logBtnFont = [
UIFont
boldSystemFontOfSize:
13
];
config.sloganFont = [
UIFont
boldSystemFontOfSize:
16
];
config.modalTransitionStyle =
UIModalTransitionStyleCoverVertical
;
config.privacyTextAlignment =
NSTextAlignmentLeft
;
config.privacyShowBookSymbol =
YES
;
config.privacyComponents = @[
@"登录表示同意"
,
@"文本1"
,
@"文本2"
,
@"文本3"
,
@"文本4"
,
@"文本5"
];
config.preferredStatusBarStyle =
0
;
config.agreementPreferredStatusBarStyle =
0
;
config.privacyState =
NO
;
config.dismissAnimationFlag =
YES
;
///协议二次弹窗默认配置
config.isAlertPrivacyVC =
YES
;
// config.agreementAlertViewLogBtnTextColor = [UIColor whiteColor];
// config.agreementAlertViewTitleTextColor = [UIColor colorWithRed:34/255 green:35/255 blue:40/255 alpha:1];
config.agreementAlertViewContentTextFontSize =
10
;
config.agreementAlertViewContentTextAlignment =
NSTextAlignmentLeft
;
// config.agreementAlertViewTitleTexFont = [UIFont fontWithName:NSFontAttributeName size:16];
config.windowCornerRadius =
15
;
config.resetAgreementAlertViewFrameBlock = ^(
NSValue
*_Nullable* _Nullable superViewFrame ,
NSValue
*_Nullable* _Nullable alertViewFrame ,
NSValue
*_Nullable* _Nullable titleFrame ,
NSValue
*_Nullable* _Nullable contentFrame,
NSValue
*_Nullable* _Nullable buttonFrame){
*superViewFrame = [
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
*alertViewFrame = [
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
*buttonFrame = [
NSValue
valueWithCGRect:
CGRectMake
(
CGRectGetMidX
([*contentFrame
CGRectValue
])
-180
/
2
,
CGRectGetMaxY
([*contentFrame
CGRectValue
])+
5
,
180
,
CGRectGetHeight
([*buttonFrame
CGRectValue
]))];
};
config.customLoadingViewBlock = ^(
UIView
*View) {
//https://github.com/jdg/MBProgressHUD
MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:View animated:
YES
];
hub.backgroundColor = [
UIColor
clearColor];
hub.label.text =
@"正在登录.."
;
[hub showAnimated:
YES
];
};
config.customPrivacyAlertViewBlock = ^(
UIViewController
*vc ,
NSArray
*appPrivacys,
void
(^loginAction)(
void
)) {
UIAlertController
*alert = [
UIAlertController
alertControllerWithTitle:
@"请点击同意协议"
message:appPrivacys.description preferredStyle:
UIAlertControllerStyleAlert
];
[alert addAction:[
UIAlertAction
actionWithTitle:
@"确定"
style:
UIAlertActionStyleDefault
handler:^(
UIAlertAction
* _Nonnull action) {
loginAction();
}]];
[vc presentViewController:alert animated:
true
completion:
nil
];
};
config.agreementAlertViewShowWindow =
YES
;
__
weak
__
typeof
(
self
)weakSelf =
self
;
config.customAgreementAlertView = ^(
UIView
*superView,
void
(^hidAlertView)(
void
)){
weakSelf.hidAlertView = hidAlertView;
UIButton
*button = [
UIButton
buttonWithType:
UIButtonTypeSystem
];
button.frame =
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
[button setTitle:
@"关闭拉起"
forState:
UIControlStateNormal
];
button.backgroundColor = [
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
config.logoImg = [
UIImage
imageNamed:
@"cmccLogo"
];
CGFloat
logoWidth = config.logoImg.size.width?:
100
;
CGFloat
logoHeight = logoWidth;
JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:
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
JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-90
];
JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:logoWidth];
JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:logoHeight];
config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
config.logoHorizontalConstraints = config.logoConstraints;
//号码栏
JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:
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
JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeCenterY
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-55
];
JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
130
];
JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
25
];
config.numberConstraints = @[numberConstraintX,numberConstraintY, numberConstraintW, numberConstraintH];
config.numberHorizontalConstraints = config.numberConstraints;
//slogan展示
JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:
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
JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
-20
];
JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
180
];
JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
20
];
config.sloganConstraints = @[sloganConstraintX,sloganConstraintY, sloganConstraintW, sloganConstraintH];
config.sloganHorizontalConstraints = config.sloganConstraints;
//登录按钮
UIImage
*login_nor_image = [
self
imageNamed:
@"loginBtn_Nor"
];
UIImage
*login_dis_image = [
self
imageNamed:
@"loginBtn_Dis"
];
UIImage
*login_hig_image = [
self
imageNamed:
@"loginBtn_Hig"
];
if
(login_nor_image && login_dis_image && login_hig_image) {
config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
}
CGFloat
loginButtonWidth = login_nor_image.size.width?:
100
;
CGFloat
loginButtonHeight = login_nor_image.size.height?:
100
;
JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:
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
JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeCenterY
multiplier:
1
constant:
30
];
JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:loginButtonWidth];
JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:loginButtonHeight];
config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
config.logBtnHorizontalConstraints = config.logBtnConstraints;
//勾选框---全屏样式 sdk先add隐私 因为隐私大小随内容变化而变化
UIImage
* uncheckedImg = [
self
imageNamed:
@"checkBox_unSelected"
];
UIImage
* checkedImg = [
self
imageNamed:
@"checkBox_selected"
];
CGFloat
checkViewWidth = uncheckedImg.size.width;
CGFloat
checkViewHeight = uncheckedImg.size.height;
config.uncheckedImg = uncheckedImg;
config.checkedImg = checkedImg;
JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:
20
];
JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeTop
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemPrivacy attribute:
NSLayoutAttributeTop
multiplier:
1
constant:
0
];
//改为top对齐
JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:checkViewWidth];
JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:checkViewHeight];
config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
config.checkViewHorizontalConstraints = config.checkViewConstraints;
config.navCustom =
YES
;
config.privacysNavCustom =
NO
;
//隐私
config.textVerAlignment = JVVerAlignmentTop;
///设置隐私Label的垂直对齐方式
//隐私---旧方法
CGFloat
spacing = checkViewWidth +
20
+
5
;
config.appPrivacyOne = @[
@"应用自定义服务条款1"
,
@"https://www.jiguang.cn/about"
];
config.appPrivacyTwo = @[
@"应用自定义服务条款2"
,
@"https://www.jiguang.cn/about"
];
//隐私---新方法 存在appPrivacys则默认使用appPrivacys方式
config.appPrivacys = @[
@"头部文字"
,
//头部文字
@[
@"、"
,
@"应用自定义服务条款1"
,
@"https://www.taobao.com/"
,
@"协议1自定义标题"
],
@[
@"、"
,
@"应用自定义服务条款2"
,
@"https://www.jiguang.cn/"
,
@"协议2自定义标题"
],
@[
@"、"
,
@"应用自定义服务条款3"
,
@"https://www.baidu.com/"
,
@"协议3自定义标题"
],
// @[@"、",@"应用自定义服务条款4",@"https://www.taobao.com/",@"协议4自定义标题"],
// @[@"、",@"应用自定义服务条款5",@"https://www.taobao.com/",@"协议5自定义标题"],
@"尾部文字。"
];
JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeLeft
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeLeft
multiplier:
1
constant:spacing];
JVLayoutConstraint *privacyConstraintX2 = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeRight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeRight
multiplier:
1
constant:-spacing];
JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeBottom
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemSuper attribute:
NSLayoutAttributeBottom
multiplier:
1
constant:
-20
];
JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
80
];
config.privacyConstraints = @[privacyConstraintX,privacyConstraintX2,privacyConstraintY,privacyConstraintH];
config.privacyHorizontalConstraints = config.privacyConstraints;
//loading
JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:
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
JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:
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
JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeWidth
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeWidth
multiplier:
1
constant:
30
];
JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:
NSLayoutAttributeHeight
relatedBy:
NSLayoutRelationEqual
toItem:JVLayoutItemNone attribute:
NSLayoutAttributeHeight
multiplier:
1
constant:
30
];
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
config.navCustom =
NO
;
NSString
*urlStr =
@"http://video01.youju.sohu.com/88a61007-d1be-4e82-8d74-2b87ba7797f72_0_0.mp4"
;
[config setVideoBackgroudResource:urlStr placeHolder:
@"cmBackground.jpeg"
];
[JVERIFICATIONService customUIWithConfig:[
self
customSMSUI:config] customViews:^(
UIView
*customAreaView) {
/*
//添加一个自定义label
UILabel *lable = [[UILabel alloc] init];
lable.text = @"这是一个自定义label";
[lable sizeToFit];
lable.center = customAreaView.center;
[customAreaView addSubview:lable];
*/
UIButton
*button = [
UIButton
buttonWithType:
UIButtonTypeSystem
];
button.frame =
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
[button setTitle:
@"关闭拉起"
forState:
UIControlStateNormal
];
button.backgroundColor = [
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
*button2 = [
UIButton
buttonWithType:
UIButtonTypeSystem
];
button2.frame =
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
[button2 setTitle:
@"关闭"
forState:
UIControlStateNormal
];
button2.backgroundColor = [
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
此代码块在浮窗中显示
4、拉起授权页面
API：
拉起授权页面
拉起授权页面，在该页面中完成一键登录；
注意
如果没有获取预取号该接口则会主动获取预取号，然后再进行拉起页面；
如果调用该接口时调用了预取号接口并且还没有获取完成，则回调中会返回预取号获取中的提示，建议在预取号获取完成后再调用该接口；
没有设置自定义UI，会使用默认UI；
- (void)loginAuth {
//如果预登录未完成则不建议调用一键登录，根据我们的数据分析如果预登录较长时间未完成，一键登录的成功率也会降低，所以用户体验最好的方式就是，在预登录接口执行完成后进行一键登录。
//我们强烈建议，在一键登录的前置页面进行预取号接口调用。
if (!finishPrelogin) {
return;
}
//设置自定义UI
[self setUIConfig];
// 一键登录
__weak __typeof(self)weakSelf = self;
[JVERIFICATIONService getAuthorizationWithController:weakSelf hide:YES animated:YES timeout:5*1000 completion:^(NSDictionary *result) {
NSLog(@"一键登录 result:%@", result);
NSString *token = result[@"loginToken"];
// 通过token调用极光接口去拿手机号。
[weakSelf getRealNumber:token];
} actionBlock:^(NSInteger type, NSString *content) {
NSLog(@"一键登录 actionBlock :%ld %@", (long)type , content);
}];
}
- (void)setUIConfig {
......
}
- (
void
)loginAuth {
//如果预登录未完成则不建议调用一键登录，根据我们的数据分析如果预登录较长时间未完成，一键登录的成功率也会降低，所以用户体验最好的方式就是，在预登录接口执行完成后进行一键登录。
//我们强烈建议，在一键登录的前置页面进行预取号接口调用。
if
(!finishPrelogin) {
return
;
}
//设置自定义UI
[
self
setUIConfig];
// 一键登录
__
weak
__
typeof
(
self
)weakSelf =
self
;
[JVERIFICATIONService getAuthorizationWithController:weakSelf hide:
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
@"一键登录 result:%@"
, result);
NSString
*token = result[
@"loginToken"
];
// 通过token调用极光接口去拿手机号。
[weakSelf getRealNumber:token];
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
)type , content);
}];
}
- (
void
)setUIConfig {
......
}
此代码块在浮窗中显示
文档内容是否对您有帮助？
提交评分
本页目录
一键登录流程说明
1、初始化
2、预取号
3、设置授权页面UI样式
4、拉起授权页面
代码浮窗
