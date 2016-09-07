//
//  AppDelegate.h
//  Pony
//
//  Created by Baby on 16/1/21.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChatConstants.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (assign, nonatomic)BOOL isDBMigrating;
+ (AppDelegate *) appDelegete;

- (void)appVersionUpdate;
@end

