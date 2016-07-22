//
//  UIViewController+LangExt.m
//  Pony
//
//  Created by 杜文 on 16/7/21.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "UIViewController+LangExt.h"

@implementation UIViewController (LangExt)

/**
 *  提示框
 *
 *  @param _message 提示信息
 */
- (void)addAlertViewWithMsg:(NSString *)_message cancelTitle:(NSString *)_cancelTitle{
    [self addAlertViewWithTitle:nil Msg:_message cancelTitle:_cancelTitle];
}

/**
 *  提示框（标题）
 *
 *  @param _title   标题
 *  @param _message 提示信息
 */
- (void)addAlertViewWithTitle:(NSString *)title Msg:(NSString *)_message cancelTitle:(NSString *)_cancelTitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:_message delegate:nil cancelButtonTitle:_cancelTitle otherButtonTitles:nil, nil];
    [alert show];
}

/**
 *  文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return
 */
- (BOOL)fileExist:(NSString *)filePath{
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

/**
 *  创建文件夹
 *
 *  @param _finder 文件夹
 *  @param _file   文件
 *
 *  @return
 */
- (NSString *)creatFinder:(NSString *)_finder file:(NSString *)_file{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_finder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:_finder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _file;
}

@end
