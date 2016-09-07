//
//  PonyHJNoticM.h
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PonyHJNoticM : JSONModel
@property (nonatomic, copy) NSString<Optional> * msg_type;
@property (nonatomic, copy) NSString<Optional> * user_img;
@property (nonatomic, copy) NSString<Optional> * userid;
@property (nonatomic, copy) NSString<Optional> * msg_time;
@property (nonatomic, copy) NSString<Optional> * mode;
@property (nonatomic, copy) NSString<Optional> * expire_time;
@property (nonatomic, copy) NSString<Optional> * virtualTalkid;
@property (nonatomic, copy) NSString<Optional> * nickName;
@property (nonatomic, copy) NSString<Optional> * _j_msgid;
@property (nonatomic, copy) NSString<Optional> * _j_type;



@property (nonatomic, copy) NSString<Optional> * chattype;
@property (nonatomic, copy) NSString<Optional> * from;
@property (nonatomic, copy) NSString<Optional> * im_bole;
@property (nonatomic, copy) NSString<Optional> * im_xiaoma;
@property (nonatomic, copy) NSString<Optional> * platform;
@property (nonatomic, copy) NSString<Optional> * sessionid;
@property (nonatomic, copy) NSString<Optional> * timestamp;
@property (nonatomic, copy) NSString<Optional> * to;

@end
