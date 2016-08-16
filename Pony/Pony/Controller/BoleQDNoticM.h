//
//  BoleQDNoticM.h
//  Pony
//
//  Created by 杜文 on 16/8/9.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BoleQDNoticM : JSONModel
@property (nonatomic,copy) NSString<Optional> * nickName;
@property (nonatomic,copy) NSString<Optional> * virtualTalkid;
@property (nonatomic,copy) NSString<Optional> * msg_type;
@property (nonatomic,copy) NSString<Optional> * msg_time;
@property (nonatomic,copy) NSString<Optional> * userid;
@property (nonatomic,copy) NSString<Optional> * user_img;
@end
