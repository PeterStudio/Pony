//
//  LoginVM.h
//  Pony
//
//  Created by 杜文 on 16/4/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseVM.h"
#import "RequestVM.h"


@interface LoginVM : RequestVM
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;

@property (nonatomic, copy) RACSignal * phoneValidSignal;
@property (nonatomic, copy) RACSignal * passwordValidSignal;
@property (strong, nonatomic) RACCommand *loginCommand;
@end
