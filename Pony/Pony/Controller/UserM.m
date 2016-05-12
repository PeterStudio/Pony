//
//  UserM.m
//  Pony
//
//  Created by 杜文 on 16/5/10.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "UserM.h"

@implementation UserM

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"token":@"data.token",
             @"balance":@"data.userinfo.balance",
             @"userId":@"data.userinfo.user_id",
             @"userName":@"data.userinfo.user_name",
             @"userPhone":@"data.userinfo.user_phone",
             @"status":@"status",
             @"message":@"message"};
}

@end
