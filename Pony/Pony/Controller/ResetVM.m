//
//  ResetVM.m
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "ResetVM.h"

@implementation ResetVM

- (void)initialize{
    self.title = @"重置密码";
}

- (RACCommand *)sureCommand{
    if (!_sureCommand) {
        _sureCommand = [[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[self.nPswValidSignal,self.cPswValidSignal] reduce:^id(NSNumber * x, NSNumber * y){
            return @([x boolValue]&&[y boolValue]);
        }] signalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    return _sureCommand;
}

- (RACSignal *)nPswValidSignal{
    if (!_nPswValidSignal) {
        _nPswValidSignal = [RACObserve(self, nPsw) map:^id(NSString * value) {
            return @(![value validBlank]);
        }];
    }
    return _nPswValidSignal;
}


- (RACSignal *)cPswValidSignal{
    if (!_cPswValidSignal) {
        _cPswValidSignal = [RACObserve(self, cPsw) map:^id(NSString * value) {
            return @(![value validBlank]);
        }];
    }
    return _cPswValidSignal;
}

@end
