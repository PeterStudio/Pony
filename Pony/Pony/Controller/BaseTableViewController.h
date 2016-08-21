//
//  BaseTableViewController.h
//  Pony
//
//  Created by Baby on 16/1/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JChatConstants.h"
#import "NSString+MessageInputView.h"
#import "MBProgressHUD+LangExt.h"

#import <ReactiveViewModel/ReactiveViewModel.h>
//#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "APIManager.h"

#import "UIViewController+LangExt.h"

#import "Macors.h"

#import "UIColor+Hex.h"

#import "UserManager.h"

@interface BaseTableViewController : UITableViewController
- (void)click_backBarButtonItem;
@end
