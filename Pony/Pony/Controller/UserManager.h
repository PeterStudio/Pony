//
//  UserManager.h
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginM.h"

#define USERMANAGER     [UserManager shareInstance]

typedef enum {
    BOLE = 0,
    XIAOMA
}Role;

@interface UserManager : NSObject

+ (UserManager *)shareInstance;

/**保存资料*/
- (void)saveUserInfo:(LoginM *)_loginM;
/**保存认证状态*/
- (void)saveUserAuth:(NSString *)_auth;

/**保存交易密码设置状态*/
- (void)saveUserDealStatus:(NSString *)_status;

/**获取token*/
- (NSString *)token;

/**获取用户信息*/
- (UserInfoM *)userInfoM;

/**极光伯乐帐号*/
- (NSString *)jPushBoleUsername;

/**极光小马帐号*/
- (NSString *)jPushUserName;

/**极光密码*/
- (NSString *)jPushPassword;

/**切换角色*/
- (void)changeToRole:(Role)_role;

/**是小马吗*/
- (BOOL)isXiaoMaAccount;

/**是否登录*/
- (BOOL)isLogin;

/**登出*/
- (void)logout;

@end
