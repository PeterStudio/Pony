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
    [self.requestSerializer setValue:[USERMANAGER token] forHTTPHeaderField:@"X-Auth-Token"];
    // Timte Out
    self.requestSerializer.timeoutInterval = 30;
    return self;
}

#pragma mark - Static Public
+ (instancetype)sharedManager {
    static APIManager *sessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionManager = [[APIManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL_STRING]];
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
    [self POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
