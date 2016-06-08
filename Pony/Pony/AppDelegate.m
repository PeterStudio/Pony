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

/** Vender*/
#import <JMessage/JMessage.h>
#import <SMS_SDK/SMSSDK.h>
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"

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

@interface AppDelegate ()

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
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3921700954"
                                              secret:@"04b48b094faeb16683c32669824ebdad"
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

- (void)switchStoryboard:(NSNumber *)_tag{
    NSString * sbStr = @"UserLogic";
    switch ([_tag integerValue]) {
        case 0:
            sbStr = @"UserLogic";
            break;
        case 1:
            sbStr = @"Pony";
            break;
        case 2:
            sbStr = @"HR";
            break;
        default:
            break;
    }
    UIStoryboard * sb = [UIStoryboard storyboardWithName:sbStr bundle:[NSBundle mainBundle]];
    [_window setRootViewController:sb.instantiateInitialViewController];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
    
    // init third-party SDK
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
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
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
