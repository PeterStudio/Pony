//
//  LoginVM.m
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "LoginVM.h"
#import <AdSupport/ASIdentifierManager.h>
#import "UserM.h"

@interface LoginVM()

@end

@implementation LoginVM

- (void)initialize{
    self.title = @"登录";
    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        UserM * userM = [MTLJSONAdapter modelOfClass:UserM.class fromJSONDictionary:x error:nil];
        NSLog(@"userM = %@",x);
    } error:^(NSError *error) {
        
    }];
}

- (void)requestLogin:(void (^)(id))success error:(void (^)(NSError *))error failure:(void (^)(NSError *))failure completion:(void (^)(void))completion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSDictionary * parameters = @{@"userName":_username,@"userPassword":[_password md5Hex],@"deviceName":[infoDic objectForKey:@"DTPlatformName"],@"imei":idfa,@"version":appVersion,@"os":@"1"};
    [APIHTTP wPost:kAPILogin
       parameters:parameters
          success:^(NSDictionary *object) {
              UserM * userM = [MTLJSONAdapter modelOfClass:[UserM class] fromJSONDictionary:object error:nil];
              
              NSLog(@"object = %@",userM);
              
              
//              if ([object[@"msgCode"] isEqualToString:kRequestSuccess]) {
//                  success(nil);
//                  completion();
//              }
//              else {
//                  NSInteger errnoInteger = [object[@"msgCode"] integerValue];
//                  NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : object[@"msg"] };
//                  NSError *uError = [NSError errorWithDomain:@"ZPCustom"
//                                                        code:errnoInteger
//                                                    userInfo:userInfo];
//                  error(uError);
//                  completion();
//              }
          } failure:^(NSError *error) {
              failure(error);
              completion();
          }];
}

- (RACCommand *)loginCommand{
    if (!_loginCommand) {
        @weakify(self)
        _loginCommand = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[self.phoneValidSignal,self.passwordValidSignal] reduce:^id(NSNumber * x, NSNumber * y){
            return @([x boolValue]&&[y boolValue]);
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [RACSignal empty];//[self postService];
        }];
    }
    return _loginCommand;
}

- (RACSignal *)postService{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSDictionary * params = @{@"userName":_username,@"userPassword":[_password md5Hex],@"deviceName":[infoDic objectForKey:@"DTPlatformName"],@"imei":idfa,@"version":appVersion,@"os":@"1"};
    return [self wPost:kAPILogin parameters:params];
}

- (RACSignal *)phoneValidSignal{
    if (!_phoneValidSignal) {
        _phoneValidSignal = [RACObserve(self, username) map:^id(NSString * value) {
            return @([value validLoginPhoneNumber]);
        }];
    }
    return _phoneValidSignal;
}

- (RACSignal *)passwordValidSignal{
    if (!_passwordValidSignal) {
        _passwordValidSignal = [RACObserve(self, password) map:^id(NSString * value) {
            return @([value validLoginPassword]);
        }];
    }
    return _passwordValidSignal;
}

@end
