//
//  RegistVM.m
//  Pony
//
//  Created by 杜文 on 16/5/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "RegistVM.h"

@implementation RegistVM

- (void)initialize{
    self.title = @"注册";
}

- (RACCommand *)codeCommand{
    if (!_codeCommand) {
        _codeCommand = [[RACCommand alloc] initWithEnabled:_usernameValidSignal signalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _codeCommand;
}

- (RACCommand *)sureCommand{
    if (!_sureCommand) {
        _sureCommand = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[self.usernameValidSignal,self.codeValidSignal,self.passwordValidSignal] reduce:^id(NSNumber * x, NSNumber * y, NSNumber * z){
            return @([x boolValue]&&[y boolValue]&&[z boolValue]);
        }] signalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _sureCommand;
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
        _codeValidSignal = [RACObserve(self, password) map:^id(NSString * value) {
            return @(![value validBlank]);
        }];
    }
    return _codeValidSignal;
}

- (RACSignal *)passwordValidSignal{
    if (!_passwordValidSignal) {
        _passwordValidSignal = [RACObserve(self, password) map:^id(NSString * value) {
            return @(![value validBlank]);
        }];
    }
    return _passwordValidSignal;
}

@end
