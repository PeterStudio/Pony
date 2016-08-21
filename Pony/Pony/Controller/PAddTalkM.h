//
//  PAddTalkM.h
//  Pony
//
//  Created by 杜文 on 16/8/9.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PAddTalkM : JSONModel
@property (nonatomic, copy) NSString<Optional> * fee_per_heart;     // 每次扣的费用
@property (nonatomic, copy) NSString<Optional> * balance;           // 余额校正
@property (nonatomic, copy) NSString<Optional> * heartbeat;         // 扣费频率
@property (nonatomic, copy) NSString<Optional> * bole_im_id;
@property (nonatomic, copy) NSString<Optional> * free_time;         // 免费时间-用于倒计时
@property (nonatomic, copy) NSString<Optional> * talkid;            // 扣费接口要用
@end
