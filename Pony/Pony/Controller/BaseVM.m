//
//  BaseVM.m
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseVM.h"

@implementation BaseVM

- (instancetype)init
{
    self = [super init];
    if (self) {
        _errors = [[RACSubject subject] setNameWithFormat:@"%@ -errors", self];
        [self initialize];
    }
    
    return self;
}

- (void)initialize {}

- (void)dealloc
{
    [_errors sendCompleted];
}

@end
