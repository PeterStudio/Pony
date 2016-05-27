//
//  ForgetVM.m
//  Pony
//
//  Created by 杜文 on 16/5/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "ForgetVM.h"

@implementation ForgetVM

- (void)initialize{
    self.title = @"忘记密码";
}

- (RACCommand *)checkCommand{
    if (!_checkCommand) {
        _checkCommand = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[self.usernameValidSignal,self.codeValidSignal] reduce:^id(NSNumber * x, NSNumber * y){
            return @([x boolValue]&&[y boolValue]);
        }] signalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _checkCommand;
}

- (RACSignal *)usernameValidSignal{
    if (!_usernameValidSignal) {
        _usernameValidSignal = [RACObserve(self, username) map:^id(NSString * value) {
            return @(![value validBlank]);
        }];
    }
    return _usernameValidSignal;
}

- (RACSignal *)codeValidSignal{
    if (!_codeValidSignal) {
        _codeValidSignal = [RACObserve(self, code) map:^id(NSString * value) {
            return @(![value validBlank]);
        }];
    }
    return _codeValidSignal;
}

@end
