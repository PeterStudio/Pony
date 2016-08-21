//
//  HROrderM.h
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HROrderM : JSONModel
@property (nonatomic, copy) NSString<Optional> * reponse_user_id;
@property (nonatomic, copy) NSString<Optional> * talk_status;
@property (nonatomic, copy) NSString<Optional> * talk_start_time;
@property (nonatomic, copy) NSString<Optional> * user_img;
@property (nonatomic, copy) NSString<Optional> * talk_heartbeat;
@property (nonatomic, copy) NSString<Optional> * im_xiaoma;
@property (nonatomic, copy) NSString<Optional> * fee_per_heart;
@property (nonatomic, copy) NSString<Optional> * talk_fee;
@property (nonatomic, copy) NSString<Optional> * im_bole;
@property (nonatomic, copy) NSString<Optional> * user_nickname;
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * request_user_id;
@property (nonatomic, copy) NSString<Optional> * talk_fee_start_time;
@property (nonatomic, copy) NSString<Optional> * talk_end_time;
@end
