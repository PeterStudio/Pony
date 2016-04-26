//
//  Constant.h
//  Pony
//
//  Created by 杜文 on 16/4/26.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define DWRootViewController    [[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define DWRootView              [ZPRootViewController view]

#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)

#define kClearColor     [UIColor clearColor]

#define kUserDefault    [NSUserDefaults standardUserDefaults]

#define kIOSVersion             [[[UIDevice currentDevice] systemVersion] floatValue]
#define kCurrentSystemVersion   [[UIDevice currentDevice] systemVersion]
/**
 *  设备屏幕尺寸
 */
#define kDeviceIsiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDeviceIsiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDeviceIsiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDeviceIsiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDeviceIsiPhone6PlusEnlarge ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)

#define RGB(r, g, b)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define GETIMAGE(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@", name]]

#define STRING_NOT_EMPTY(string)              (string && (string.length > 0))
#define ARRAY_NOT_EMPTY(array)                (array && (array.count > 0))

#endif /* Constant_h */
