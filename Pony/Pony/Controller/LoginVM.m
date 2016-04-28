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

- (id)init{
    self = [super init];
    if (self) {
        [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
            NSLog(@"x == %@",x);
        }];
        
        [self.loginCommand.executionSignals.switchToLatest subscribeCompleted:^{
            NSLog(@"Completed ====");
        }];
        
        [self.loginCommand.executionSignals.switchToLatest subscribeError:^(NSError *error) {
            NSLog(@"error ====");
        }];
        
    }
    return self;
}

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
    return [[[[self sharedManager] rac_GET:@"https://api.douban.com/v2/book/search" parameters:params] logError] replayLazily];
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
