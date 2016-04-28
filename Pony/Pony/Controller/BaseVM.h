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

#import "AFHTTPSessionManager.h"
#import "AFHTTPSessionManager+RACSupport.h"
#import "NSString+LangExt.h"
#import "APIStringMacros.h"

@interface BaseVM : RVMViewModel
@property (nonatomic) RACSubject *errors;

- (AFHTTPSessionManager *)sharedManager;
@end
