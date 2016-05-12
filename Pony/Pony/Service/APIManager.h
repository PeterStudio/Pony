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


/**
 *  网络请求
 *
 *  @param method       HTTP请求方法 "POST" or "GET"
 *  @param relativePath API相对路径，不包含"/"
 *  @param parameters   请求参数
 *  @param resultClass  从服务端获取到JSON数据后，使用哪个Class来将JSON转换为OC的Model
 *  @param listKey      listKey - 如果不指定，表示返回的是一个object，
 *                      如user，如果指定表示返回的是一个数组，listKey就表示这个列表的
 *                      keyname，如{'users':[]}, 那么listName就为'user'
 *
 *  @return RACSignal
 */

//- (RACSignal *)requestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass listKey:(NSString *)listKey;

@end
