//
//  ResetVM.h
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseVM.h"

@interface ResetVM : BaseVM
@property (nonatomic, copy) NSString * nPsw;
@property (nonatomic, copy) NSString * cPsw;

@property (nonatomic, copy) RACSignal * nPswValidSignal;
@property (nonatomic, copy) RACSignal * cPswValidSignal;
@property (strong, nonatomic) RACCommand * sureCommand;
@end
