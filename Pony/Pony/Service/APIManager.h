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


- (void)wPost:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
        error:(void (^)(NSError * err))error
      failure:(void (^)(NSError *err))failure
   completion:(void (^)(void))completion;

@end
