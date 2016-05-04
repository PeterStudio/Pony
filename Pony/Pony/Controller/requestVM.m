//
//  RequestVM.m
//  Pony
//
//  Created by 杜文 on 16/4/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "RequestVM.h"

@interface RequestVM()
//@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation RequestVM

// 懒加载
- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
        // Requset 非JSON
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        // Response JSON
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        // Timte Out
        _sessionManager.requestSerializer.timeoutInterval = 20;
    }
    return _sessionManager;
}


- (RACSignal *)wPost:(NSString *)_URLString parameters:(id)_parameters{
    return [[[self.sessionManager rac_POST:_URLString parameters:_parameters] logAll] replayLazily];
//    return [[self.sessionManager rac_POST:_URLString parameters:_parameters] subscribeNext:^(id x) {
//        
//    } error:^(NSError *error) {
//        
//    } completed:^{
//        
//    }];
//    return [[[[self.sessionManager rac_POST:_URLString parameters:_parameters] logError] replayLazily] subscribeNext:^(id x) {
//        
//    } error:^(NSError *error) {
//        
//    } completed:^{
//        
//    }];
}



// 在对象销毁时，别忘了取消已经在队列中的请求
- (void)dealloc {
    
    [self.sessionManager invalidateSessionCancelingTasks:YES];
}


@end
