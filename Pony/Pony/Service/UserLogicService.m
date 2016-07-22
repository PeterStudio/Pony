//
//  UserLogicService.m
//  Pony
//
//  Created by 杜文 on 16/7/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "UserLogicService.h"

@implementation UserLogicService

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    // Requset JSON
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    // Response JSON
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [self setResponseSerializer:responseSerializer];
    // Timte Out
    self.requestSerializer.timeoutInterval = 30;
    return self;
}

#pragma mark - Static Public
+ (instancetype)sharedManager {
    static UserLogicService *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[UserLogicService alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
    });
    return sessionManager;
}

#pragma mark - Public

- (void)wPost:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
        error:(void (^)(NSError * err))error
      failure:(void (^)(NSError *error))failure
   completion:(void (^)(void))completion{
    DLog(@"\n===========POST===========\n%@:\n%@", URLString, parameters);
    [self POST:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
        completion();
        NSDictionary * object = (NSDictionary *)responseObject;
        id status = object[@"status"];
        NSInteger code = 0;
        if ([status isKindOfClass:[NSString class]]) {
            // NSString
            code = [(NSString *)status integerValue];
        }
        
        if ([status isKindOfClass:[NSNumber class]]) {
            // NSNumber
            code = [(NSNumber *)status integerValue];
        }
        
        if (code == 102) {
            success(object[@"data"]);
        }
        else {
            NSInteger errnoInteger = code;
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : object[@"message"] };
            NSError *uError = [NSError errorWithDomain:@"com.peterstudio.pony"
                                                  code:errnoInteger
                                              userInfo:userInfo];
            error(uError);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
        completion();
        failure(error);
    }];
}

@end
