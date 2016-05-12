//
//  APIManager.m
//  Pony
//
//  Created by 杜文 on 16/5/5.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "APIManager.h"
#import "MTLJSONAdapter.h"

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
- (void)wGet:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure {
    DLog(@"\n===========GET===========\n%@:\n%@", URLString, parameters);
    [self GET:URLString
   parameters:parameters
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
          success(responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
          failure(error);
      }];
}

- (void)wHead:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure {
    DLog(@"\n===========HEAD===========\n%@:\n%@", URLString, parameters);
    [self HEAD:URLString
    parameters:parameters
       success:^(NSURLSessionDataTask * _Nonnull task) {
           DLog(@"\n===========success===========\n%@:", URLString);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
           failure(error);
       }];
}

- (void)wPost:(NSString *)URLString
   parameters:(id)parameters
      success:(void (^)(id responseObject))success
      failure:(void (^)(NSError *error))failure {
    DLog(@"\n===========POST===========\n%@:\n%@", URLString, parameters);
    [self POST:URLString
    parameters:parameters
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
           DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
           success(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
           failure(error);
       }];
}

- (void)wPut:(NSString *)URLString
  parameters:(id)parameters
     success:(void (^)(id responseObject))success
     failure:(void (^)(NSError *error))failure {
    DLog(@"\n===========PUT===========\n%@:\n%@", URLString, parameters);
    [self PUT:URLString
   parameters:parameters
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
          DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
          success(responseObject);
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
          failure(error);
      }];
}

- (void)wPatch:(NSString *)URLString
    parameters:(id)parameters
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure {
    DLog(@"\n===========PATCH===========\n%@:\n%@", URLString, parameters);
    [self PATCH:URLString
     parameters:parameters
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
            failure(error);
        }];
}

- (void)wDelete:(NSString *)URLString
     parameters:(id)parameters
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure {
    DLog(@"\n===========DELETE===========\n%@:\n%@", URLString, parameters);
    [self DELETE:URLString
      parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
             DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
             success(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
             failure(error);
         }];
}

- (void)wPost:(NSString *)URLString
   parameters:(id)parameters
     fileInfo:(NSDictionary *)fileInfo
      success:(void (^)(NSDictionary *object))success
      failure:(void (^)(NSError *error))failure {
    [self POST:URLString
    parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (fileInfo) {
            [formData appendPartWithFileData:fileInfo[@"kFileData"]
                                        name:fileInfo[@"kName"]
                                    fileName:fileInfo[@"kFileName"]
                                    mimeType:fileInfo[@"kMimeType"]];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        DLog(@"\n===========success===========\n%@:\n%@", URLString, responseObject);
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DLog(@"\n===========error===========\n%@:\n%@", URLString, error);
        failure(error);
    }];
}
@end
