//
//  RegistVM.h
//  Pony
//
//  Created by 杜文 on 16/5/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "RequestVM.h"

@interface RegistVM : RequestVM

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * password;


@end