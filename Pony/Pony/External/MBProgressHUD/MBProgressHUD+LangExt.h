//
//  MBProgressHUD+LangExt.h
//  MaiYaDai
//
//  Created by Baby on 16/6/13.
//  Copyright © 2016年 maiya. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LangExt)

+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
