//
//  APIManager.m
//  Pony
//
//  Created by 杜文 on 16/5/5.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "APIManager.h"
#import "UserManager.h"


@implementation APIManager

#pragma mark - Static Public
+ (instancetype)sharedManager {
    APIManager *sessionManager = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
    // Requset JSON
    sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // Response JSON
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [sessionManager setResponseSerializer:responseSerializer];
    [sessionManager.requestSerializer setValue:[USERMANAGER token] forHTTPHeaderField:@"X-Auth-Token"];
    [sessionManager.requestSerializer setValue:@"1" forHTTPHeaderField:@"channel"];
    NSLog(@"token == %@",[USERMANAGER token]);
    // Timte Out
    sessionManager.requestSerializer.timeoutInterval = 30;
    
    return sessionManager;
}

#pragma mark - Public

- (void)wwPost:(NSString *)URLString
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
            if (code == 100) {
                // 非法token 退出
                [JMSGUser logout:^(id resultObject, NSError *error) {
                    [USERMANAGER logout];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                                        object:USERLOGIC_SB];
                }];
            }
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
