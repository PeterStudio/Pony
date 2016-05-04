//
//  RequestVM.h
//  Pony
//
//  Created by 杜文 on 16/4/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseVM.h"
#import <AFNetworking.h>
#import "AFHTTPSessionManager+RACSupport.h"

// 继承自BaseVM
// 需要网络请求的VM继承该类
// 该类有一个公共属性sessionManager，一个该属性的懒加载方法和一个dealloc中取消网络请求的方法
@interface RequestVM : BaseVM
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

- (RACSignal *)wPost:(NSString *)_URLString parameters:(id)_parameters;

@end
