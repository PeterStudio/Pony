//
//  APIManager.h
//  Pony
//
//  Created by 杜文 on 16/5/5.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "APIStringMacros.h"
#import "Macors.h"

#define APIHTTP [APIManager sharedManager]

@interface APIManager : AFHTTPSessionManager

+ (instancetype)sharedManager;


- (void)wGet:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)wHead:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;

- (void)wPost:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure;

- (void)wPut:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure;

- (void)wPatch:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;

- (void)wDelete:(NSString *)URLString
     parameters:(id)parameters
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;

- (void)wPost:(NSString *)URLString
   parameters:(id)parameters
     fileInfo:(NSDictionary *)fileInfo
      success:(void (^)(NSDictionary *object))success
      failure:(void (^)(NSError *error))failure;

@end
