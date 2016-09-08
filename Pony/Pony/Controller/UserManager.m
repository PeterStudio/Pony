//
//  UserManager.m
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "UserManager.h"

#define USER_INFO   @"USER_INFO"
#define ROLE_TAG    @"ROLE_TAG"


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

/**保存认证状态*/
- (void)saveUserAuth:(NSString *)_auth{
    NSDictionary * tokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    LoginM * loginM = [[LoginM alloc] initWithDictionary:tokenDic error:nil];
    loginM.userinfo.user_auth = _auth;
    [self saveUserInfo:loginM];
}

/**保存交易密码设置状态*/
- (void)saveUserDealStatus:(NSString *)_status{
    NSDictionary * tokenDic = [[NSUserDefaults standardUserDefaults] objectForKey:USER_INFO];
    LoginM * loginM = [[LoginM alloc] initWithDictionary:tokenDic error:nil];
    loginM.userinfo.charge_status = _status;
    [self saveUserInfo:loginM];
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

/**极光伯乐帐号*/
- (NSString *)jPushBoleUsername{
    UserInfoM * m = [self userInfoM];
    return m.bole_im_id;
}

/**极光帐号*/
- (NSString *)jPushUserName{
    UserInfoM * m = [self userInfoM];
    return m.xiaoma_im_id;
}

/**极光密码*/
- (NSString *)jPushPassword{
    UserInfoM * m = [self userInfoM];
    return m.im_password;
}

/**切换角色*/
- (void)changeToRole:(Role)_role{
    if (BOLE == _role) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:ROLE_TAG];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ROLE_TAG];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**是小马吗*/
- (BOOL)isXiaoMaAccount{
    NSNumber *b = [[NSUserDefaults standardUserDefaults] objectForKey:ROLE_TAG];
    return [b boolValue];
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
