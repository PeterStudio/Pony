//
//  UserManager.m
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "UserManager.h"

#define USER_INFO   @"USER_INFO"

@implementation UserManager

+ (UserManager *)shareInstance{
    static UserManager *sharedUserManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedUserManagerInstance = [[self alloc] init];
    });
    return sharedUserManagerInstance;
}

/**保存资料*/
- (void)saveUserInfo:(LoginM *)_loginM{
    [[NSUserDefaults standardUserDefaults] setObject:[_loginM toDictionary] forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**获取token*/
- (NSString *)token{
    NSDictionary * tokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    LoginM * loginM = [[LoginM alloc] initWithDictionary:tokenDic error:nil];
    return loginM.token;
}

/**获取用户信息*/
- (UserInfoM *)userInfoM{
    NSDictionary * tokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    LoginM * loginM = [[LoginM alloc] initWithDictionary:tokenDic error:nil];
    return loginM.userinfo;
}

/**是否登录*/
- (BOOL)isLogin{
    if ([self token]) {
        return YES;
    }
    return NO;
}

/**登出*/
- (void)logout{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:USER_INFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
