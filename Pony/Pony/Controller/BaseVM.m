//
//  BaseVM.m
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseVM.h"

@implementation BaseVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _errors = [[RACSubject subject] setNameWithFormat:@"%@ -errors", self];
        [self initialize];
    }
    
    return self;
}

- (void)initialize {}

- (void)dealloc
{
    [_errors sendCompleted];
}


//- (AFHTTPSessionManager *)sharedManager {
//    static AFHTTPSessionManager *sessionManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
//        // Requset 非JSON
//        sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        // Response JSON
//        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        // Timte Out
//        sessionManager.requestSerializer.timeoutInterval = 20;
//    });
//    return sessionManager;
//}


@end
