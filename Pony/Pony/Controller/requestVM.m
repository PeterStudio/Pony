//
//  RequestVM.m
//  Pony
//
//  Created by 杜文 on 16/4/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "RequestVM.h"
#import <CocoaLumberjack/DDLegacyMacros.h>

@interface RequestVM()
//@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation RequestVM

// 懒加载
- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
        // Requset JSON
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        // Response JSON
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [_sessionManager setResponseSerializer:responseSerializer];
        // Timte Out
        _sessionManager.requestSerializer.timeoutInterval = 20;
    }
    return _sessionManager;
}

- (RACSignal *)wPost:(NSString *)_URLString parameters:(id)_parameters{
    DLog(@"\n===========POST===========\n%@:\n%@", _URLString, _parameters);
    return [[[self.sessionManager rac_POST:_URLString parameters:_parameters] logError] replayLazily];
}

// 在对象销毁时，别忘了取消已经在队列中的请求
- (void)dealloc {
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}


@end
