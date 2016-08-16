//
//  AppDelegate.m
//  Pony
//
//  Created by Baby on 16/1/21.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "AppDelegate.h"

#import "XXDGuideView.h"

#import "UserManager.h"
#import "Macors.h"

/** ViewController*/
#import "HRVC.h"
#import "HRChatVC.h"
#import "HRMineVC.h"

/** Vender*/
#import <JMessage/JMessage.h>
#import <SMS_SDK/SMSSDK.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
#import <AlipaySDK/AlipaySDK.h>

#import <ReactiveViewModel/ReactiveViewModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

// 极光key
#define JMSSAGE_APPKEY @"fda9d138fe7e4325f225106c"

//SMSSDK官网公共key
#define appkey @"100fd9b14a15a"
#define app_secrect @"cf274655e142b143c45c449da3d5c17a"

// 友盟key
#define UmengAppkey @"57511c7567e58e72f7001044"

@interface AppDelegate ()<JMessageDelegate,UIAlertViewDelegate>

@end

@implementation AppDelegate

- (void)config{
    //Mob，appKey和appSecret从后台申请得
    [SMSSDK registerApp:appkey
             withSecret:app_secrect];
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx98a9093e63b0ddbb" appSecret:@"0bba47f956daa6949f7db7cc9564c6ef" url:@"http://www.umeng.com/social"];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:@"1105319509" appKey:@"gtZpCuOGi3ekWquL" url:@"http://www.umeng.com/social"];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。需要 #import "UMSocialSinaSSOHandler.h"
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1397362174"
                                              secret:@"aa88d99dfd2970a2b8794b07cca7769a"
                                         RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    /**DDLog*/
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // 将 log 发送给苹果服务器，之后在 Console.app 中可以查看
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // 将 log 发送给 Xcode 的控制台
    
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
    
}

+ (AppDelegate *) appDelegete
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}


/**
 *  主页
 */
- (void)showMainViewController{
    UIStoryboard * sb1 = [UIStoryboard storyboardWithName:@"HBoleSB" bundle:[NSBundle mainBundle]];
    UIStoryboard * sb2 = [UIStoryboard storyboardWithName:@"HChatSB" bundle:[NSBundle mainBundle]];
    UIStoryboard * sb3 = [UIStoryboard storyboardWithName:@"HMineSB" bundle:[NSBundle mainBundle]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController * nav1 = [sb1 instantiateInitialViewController];
    [nav1 setTabBarItem:[self createTabBarItemWithTitle:@"伯乐" norImageName:@"nav_icon01" selImageName:@"nav_icon01_1"]];
    UINavigationController * nav2 = [sb2 instantiateInitialViewController];
    [nav2 setTabBarItem:[self createTabBarItemWithTitle:@"聊天" norImageName:@"nav_icon02" selImageName:@"nav_icon02_1"]];
    UINavigationController * nav3 = [sb3 instantiateInitialViewController];
    [nav3 setTabBarItem:[self createTabBarItemWithTitle:@"我的" norImageName:@"nav_icon03" selImageName:@"nav_icon03_1"]];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:nav1,nav2,nav3, nil];
    [self.window setRootViewController:self.tabBarController];
}

/**
 *  创建UITabBarItem
 *
 *  @param _title        标题
 *  @param _norImageName 正常图片
 *  @param _selImageName 选中图片
 *
 *  @return self
 */
- (UITabBarItem *)createTabBarItemWithTitle:(NSString *)_title norImageName:(NSString *)_norImageName selImageName:(NSString *)_selImageName{
    UIImage *imgNor = [UIImage imageNamed:_norImageName];
    UIImage *imgSel = [UIImage imageNamed:_selImageName];
    imgNor = [imgNor imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    imgSel = [imgSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem * tabBarItem = [[UITabBarItem alloc] initWithTitle:_title image:imgNor selectedImage:imgSel];
    return tabBarItem;
}


- (void)switchStoryboard:(NSNumber *)_tag{
    switch ([_tag integerValue]) {
        case 0:
        {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"UserLogic" bundle:[NSBundle mainBundle]];
            [_window setRootViewController:sb.instantiateInitialViewController];
        }
            break;
        case 1:
        {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Pony" bundle:[NSBundle mainBundle]];
            [_window setRootViewController:sb.instantiateInitialViewController];
        }
            break;
        case 2:
        {
            UIStoryboard * sb = [UIStoryboard storyboardWithName:@"HR" bundle:[NSBundle mainBundle]];
            [_window setRootViewController:sb.instantiateInitialViewController];
        }
            break;
        default:
            break;
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_window setBackgroundColor:[UIColor whiteColor]];
    if (![USERMANAGER isLogin]) {
        [self switchStoryboard:USERLOGIC_SB];
    }else{
        if ([USERMANAGER isXiaoMaAccount]) {
            [self switchStoryboard:PONY_SB];
        }else{
            [self switchStoryboard:HR_SB];
        }
    }
    [_window makeKeyAndVisible];
    
    /**添加引导页*/
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:VERSION_NUM_FOR_GUIDE_KEY] integerValue] < VERSION_NUM_FOR_GUIDE)
    {
        XXDGuideView * guideView = [[XXDGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.window addSubview:guideView];
    }
    
    
    @weakify(self)
    [[[[NSNotificationCenter defaultCenter]
       rac_addObserverForName:NOTICE_SWITCH_VC
       object:nil] takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification *notification) {
         @strongify(self);
         [self switchStoryboard:notification.object];
     }];
    
    
    [self config];
    
    /// Required - 添加 JMessage SDK 监听。这个动作放在启动前
    [JMessage addDelegate:self withConversation:nil];
    
    [JMessage setupJMessage:launchOptions
                     appKey:JMSSAGE_APPKEY
                    channel:@"Apple Store" apsForProduction:NO  //
                   category:nil];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [self registerJPushStatusNotification];
    
    return YES;
}

#pragma - mark JMessageDelegate
- (void)onLoginUserKicked {
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"登录状态出错"
                                                       message:@"你已在别的设备上登录!"
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"确定", nil];
    alertView.tag = 1200;
    [alertView show];
}

- (void)onDBMigrateStart {
    NSLog(@"onDBmigrateStart in appdelegate");
    _isDBMigrating = YES;
}

- (void)onDBMigrateFinishedWithError:(NSError *)error {
    NSLog(@"onDBmigrateFinish in appdelegate");
    _isDBMigrating = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kDBMigrateFinishNotification object:nil];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    return result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
        }
    }
    return result;
}

- (void)registerJPushStatusNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkIsConnecting:)
                          name:kJPFNetworkIsConnectingNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(receivePushMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    
}

// notification from JPush
- (void)networkDidSetup:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidSetup");
}

// notification from JPush
- (void)networkIsConnecting:(NSNotification *)notification {
    DDLogDebug(@"Event - networkIsConnecting");
}

// notification from JPush
- (void)networkDidClose:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidClose");
}

// notification from JPush
- (void)networkDidRegister:(NSNotification *)notification {
    DDLogDebug(@"networkDidRegister-%@", [notification userInfo]);
    DDLogDebug(@"Event - networkDidRegister");
}

// notification from JPush
- (void)networkDidLogin:(NSNotification *)notification {
    DDLogDebug(@"Event - networkDidLogin");
}

// notification from JPush
- (void)receivePushMessage:(NSNotification *)notification {
    DDLogDebug(@"Event - receivePushMessage");
    
    NSDictionary *info = notification.userInfo;
    if (info) {
        DDLogDebug(@"The message - %@", info);
        [[NSNotificationCenter defaultCenter] postNotificationName:BOLE_QIANGDAN_NOTIC object:info[@"content"]];
        
        /*
         2016-07-26 14:46:21:957 Pony[1173:326671] The message - {
         content = "{\"nickName\":\"151***8133\",\"virtualTalkid\":\"8fd94706933c41198e487d5654079ec4\",\"msg_type\":1,\"msg_time\":\"2016-46-26 02:46:21\",\"userid\":\"6fc22a6ef13243609b908f5cbacbb399\",\"user_img\":\"head_0\"}";
         }
         */
    } else {
        DDLogWarn(@"Unexpected - no user info in jpush mesasge");
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self resetApplicationBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


// ---------------------- JPUSH
// 通常会调用 JPUSHService 方法去完成 Push 相关的功能

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    DDLogInfo(@"Action - didRegisterForRemoteNotificationsWithDeviceToken");
    DDLogVerbose(@"Got Device Token - %@", deviceToken);
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DDLogVerbose(@"Action - didFailToRegisterForRemoteNotificationsWithError - %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    DDLogInfo(@"Action - didRegisterUserNotificationSettings");
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    DDLogDebug(@"Action - handleActionWithIdentifier:forLocalNotification");
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
    DDLogDebug(@"Action - handleActionWithIdentifier:forRemoteNotification");
}

#endif // end of - > __IPHONE_7_1

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DDLogDebug(@"Action - didReceiveRemoteNotification");
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    DDLogVerbose(@"收到通知 - %@", [JCHATStringUtils dictionary2String:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    DDLogDebug(@"Action - didReceiveRemoteNotification:fetchCompletionHandler");
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知 - %@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    DDLogDebug(@"Action - didReceiveLocalNotification");
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}


// ---------- end of JPUSH

- (void)resetApplicationBadge {
    DDLogVerbose(@"Action - resetApplicationBadge");
    
    NSInteger badge = [[[NSUserDefaults standardUserDefaults] objectForKey:kBADGE] integerValue];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    
    [JPUSHService setBadge:badge];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1200) {
        [self switchStoryboard:USERLOGIC_SB];
    }
}

@end
