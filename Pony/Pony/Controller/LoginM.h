//
//  LoginM.h
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserInfoM : JSONModel
@property (copy, nonatomic) NSString<Optional> * balance;
@property (copy, nonatomic) NSString<Optional> * bole_im_id;
@property (copy, nonatomic) NSString<Optional> * im_password;
@property (copy, nonatomic) NSString<Optional> * user_auth;
@property (copy, nonatomic) NSString<Optional> * user_id;
@property (copy, nonatomic) NSString<Optional> * user_img;
@property (copy, nonatomic) NSString<Optional> * user_name;
@property (copy, nonatomic) NSString<Optional> * user_phone;
@property (copy, nonatomic) NSString<Optional> * xiaoma_im_id;
@end

@interface LoginM : JSONModel
@property (copy, nonatomic) NSString<Optional> * token;
@property (copy, nonatomic) UserInfoM<Optional> * userinfo;
@end

