//
//  LoginVM.m
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "LoginVM.h"

@interface LoginVM()
@property (nonatomic, copy) RACSignal * phoneValidSignal;
@property (nonatomic, copy) RACSignal * passwordValidSignal;
@end

@implementation LoginVM

- (void)initialize{
    self.title = @"登录";
}

//- (id)init{
//    self = [super init];
//    if (self) {
//        RACSignal*startedMessageSource = [self.loginCommand.executionSignals map:^id(RACSignal *subscribeSignal) {
//            return NSLocalizedString(@"Sending request...", nil);
//        }];
//        
//        RACSignal*completedMessageSource = [self.loginCommand.executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
//            return[[[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
//                return event.eventType == RACEventTypeCompleted;
//            }]map:^id(id value) {
//                return NSLocalizedString(@"Thanks", nil);
//            }];
//        }];
//        
//        RACSignal*failedMessageSource = [[self.loginCommand.errors subscribeOn:[RACScheduler mainThreadScheduler]] map:^id(NSError *error) {
//            return NSLocalizedString(@"Error :(", nil);
//        }];
        
//        RAC(self,statusMessage) = [RACSignal merge:@[startedMessageSource,completedMessageSource, failedMessageSource]];
//    }
//    return self;
//}

- (RACCommand *)loginCommand{
    if (!_loginCommand) {
        @weakify(self)
        _loginCommand = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[self.phoneValidSignal,self.passwordValidSignal] reduce:^id(NSNumber * x, NSNumber * y){
            return @([x boolValue]&&[y boolValue]);
        }] signalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [self postService];
        }];
    }
    return _loginCommand;
}

- (RACSignal *)postService{
    NSDictionary * params = @{@"q":@"基础"};
    return [[[self.sessionManager rac_GET:@"https://api.douban.com/v2/book/search" parameters:params] logAll] replayLazily];
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
