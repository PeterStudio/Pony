//
//  UIViewController+LangExt.h
//  Pony
//
//  Created by 杜文 on 16/7/21.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LangExt)


/**
 *  提示框
 *
 *  @param _message 提示信息
 */
- (void)addAlertViewWithMsg:(NSString *)_message cancelTitle:(NSString *)_cancelTitle;

/**
 *  提示框（标题）
 *
 *  @param title   标题
 *  @param _message 提示信息
 */
- (void)addAlertViewWithTitle:(NSString *)title Msg:(NSString *)_message cancelTitle:(NSString *)_cancelTitle;

/**
 *  文件是否存在
 *
 *  @param filePath 文件路径
 *
 *  @return
 */
- (BOOL)fileExist:(NSString *)filePath;

/**
 *  创建文件夹
 *
 *  @param _finder 文件夹
 *  @param _file   文件
 *
 *  @return
 */
- (NSString *)creatFinder:(NSString *)_finder file:(NSString *)_file;

@end
