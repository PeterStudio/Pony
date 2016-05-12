//
//  AppDelegate.h
//  Pony
//
//  Created by Baby on 16/1/21.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChatConstants.h"
//#import <CocoaLumberjack/DDLegacyMacros.h>

#define JMSSAGE_APPKEY @"4f7aef34fb361292c566a1cd"//@"fda9d138fe7e4325f225106c"

#define USERLOGIC_SB [NSNumber numberWithInteger:0]
#define PONY_SB      [NSNumber numberWithInteger:1]
#define HR_SB        [NSNumber numberWithInteger:2]

//typedef enum : NSUInteger {
//    USERLOGIC_SB = 0,
//    PONY_SB = 1,
//    HR_SB = 2,
//} StoryboardTag;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *) appDelegete; 

@end

