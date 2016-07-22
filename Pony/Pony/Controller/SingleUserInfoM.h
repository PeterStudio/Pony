//
//  SingleUserInfoM.h
//  Pony
//
//  Created by 杜文 on 16/7/22.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SingleUserInfoM : JSONModel
@property (nonatomic, copy) NSString<Optional> * enabled;
@property (nonatomic, copy) NSString<Optional> * issys;
@property (nonatomic, copy) NSString<Optional> * subSystem;
@property (nonatomic, copy) NSString<Optional> * userNickname;
@property (nonatomic, copy) NSString<Optional> * userDept;
@property (nonatomic, copy) NSString<Optional> * userDesc;
@property (nonatomic, copy) NSString<Optional> * userDuty;
@property (nonatomic, copy) NSString<Optional> * userId;
@property (nonatomic, copy) NSString<Optional> * userName;
@property (nonatomic, copy) NSString<Optional> * userPassword;
@property (nonatomic, copy) NSString<Optional> * roleName;
@property (nonatomic, copy) NSString<Optional> * userPhone;
@property (nonatomic, copy) NSString<Optional> * userMail;
@property (nonatomic, copy) NSString<Optional> * userImg;
@property (nonatomic, copy) NSString<Optional> * user_money_password;
@property (nonatomic, copy) NSString<Optional> * lastPasswordReset;
@property (nonatomic, copy) NSString<Optional> * jpush_ma_id;
@property (nonatomic, copy) NSString<Optional> * jpush_bole_id;
@property (nonatomic, copy) NSString<Optional> * userAuth;  //  0为未认证，1为认证 2待审核 3审核失败
@end
