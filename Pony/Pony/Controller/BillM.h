//
//  BillM.h
//  Pony
//
//  Created by 杜文 on 16/9/19.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BillM : JSONModel
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * logType;
@property (nonatomic, copy) NSString<Optional> * moneyFromUser;
@property (nonatomic, copy) NSString<Optional> * moneyToUser;
@property (nonatomic, copy) NSString<Optional> * logMoneyFee;
@property (nonatomic, copy) NSString<Optional> * logTime;
@property (nonatomic, copy) NSString<Optional> * moneyTalkId;
@property (nonatomic, copy) NSString<Optional> * moneyStatus;
@property (nonatomic, copy) NSString<Optional> * moneyStatusName;

@end
