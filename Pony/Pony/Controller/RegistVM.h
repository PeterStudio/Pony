//
//  RegistVM.h
//  Pony
//
//  Created by 杜文 on 16/5/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseVM.h"

@interface RegistVM : BaseVM

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * password;

@property (nonatomic, copy) RACSignal * usernameValidSignal;
@property (nonatomic, copy) RACSignal * codeValidSignal;
@property (nonatomic, copy) RACSignal * passwordValidSignal;
@property (strong, nonatomic) RACCommand * sureCommand;

@end
