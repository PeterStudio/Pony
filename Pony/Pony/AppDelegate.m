//
//  AppDelegate.m
//  Pony
//
//  Created by Baby on 16/1/21.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "AppDelegate.h"
#import <JMessage/JMessage.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self initLogger];
    
    // init third-party SDK
    [JMessage setupJMessage:launchOptions
                     appKey:JMSSAGE_APPKEY
                    channel:@"" apsForProduction:NO
                   category:nil];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [self registerJPushStatusNotification];
    
    return YES;
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

- (void)initLogger {
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // 将 log 发送给苹果服务器，之后在 Console.app 中可以查看
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // 将 log 发送给 Xcode 的控制台
    
    DDLogVerbose(@"Verbose");
    DDLogDebug(@"Debug");
    DDLogInfo(@"Info");
    DDLogWarn(@"Warn");
    DDLogError(@"Error");
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
