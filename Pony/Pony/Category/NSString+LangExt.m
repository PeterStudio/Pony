//
//  NSString+LangExt.m
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "NSString+LangExt.h"

@implementation NSString (LangExt)

- (BOOL)validLoginPhoneNumber{
    NSString * numberRegex = @"1[0-9]{10}$";
    NSPredicate * numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberTest evaluateWithObject:self];
}

- (BOOL)validLoginPassword{
    NSString * numberRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate * numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberTest evaluateWithObject:self];
}

@end
