//
//  NSString+LangExt.m
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "NSString+LangExt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LangExt)

- (BOOL)validLoginPhoneNumber{
    NSString * numberRegex = @"1[0-9]{10}$";
    NSPredicate * numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberTest evaluateWithObject:self];
}

- (BOOL)validLoginPassword{
    NSString * numberRegex = @"^(?![0-9]+$)(?![_]+$)(?![a-zA-Z]+$)[0-9A-Za-z_]{6,16}$";
    NSPredicate * numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    return [numberTest evaluateWithObject:self];
}

- (NSString *)md5Hex
{
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (BOOL)validBlank{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

@end
