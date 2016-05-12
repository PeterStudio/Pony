//
//  UserM.h
//  Pony
//
//  Created by 杜文 on 16/5/10.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseM.h"

@interface UserM : BaseM
@property (copy, nonatomic) NSString * token;
@property (copy, nonatomic) NSString * balance;
@property (copy, nonatomic) NSString * userId;
@property (copy, nonatomic) NSString * userName;
@property (copy, nonatomic) NSString * userPhone;

@property (copy, nonatomic) NSString * status;
@property (copy, nonatomic) NSString * message;
@end
