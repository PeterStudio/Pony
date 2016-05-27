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

@interface UserManager : NSObject

+ (UserManager *)shareInstance;

/**保存资料*/
- (void)saveUserInfo:(LoginM *)_loginM;

/**获取token*/
- (NSString *)token;

/**获取用户信息*/
- (UserInfoM *)userInfoM;

/**是否登录*/
- (BOOL)isLogin;

/**登出*/
- (void)logout;

@end
