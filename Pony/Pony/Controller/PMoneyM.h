//
//  PMoneyM.h
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PMoneyM : JSONModel
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * moneyBalance;
@property (nonatomic, copy) NSString<Optional> * moneyLastUpdate;
@property (nonatomic, copy) NSString<Optional> * moneyUserId;
@end
