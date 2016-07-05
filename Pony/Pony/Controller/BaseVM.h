//
//  BaseVM.h
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

#import "MBProgressHUD+LangExt.h"
#import "ConstantLogger.h"

#import "NSString+LangExt.h"
#import "NSString+MessageInputView.h"
#import "APIStringMacros.h"

@interface BaseVM : RVMViewModel
@property (nonatomic) RACSubject *errors;

@property (nonatomic, strong) NSString *title;
- (void)initialize;

@end
