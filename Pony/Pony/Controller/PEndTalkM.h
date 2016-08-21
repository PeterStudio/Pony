//
//  PEndTalkM.h
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@protocol PCommentStatisticsM <NSObject>

@end

@interface PCommentStatisticsM : JSONModel
@property (nonatomic, copy) NSString<Optional> * comment_count;
@property (nonatomic, copy) NSString<Optional> * comment_title;
@end

@interface PEndTalkM : JSONModel
@property (nonatomic, copy) NSString<Optional> * endtime;
@property (nonatomic, copy) NSString<Optional> * starttime;
@property (nonatomic, copy) NSString<Optional> * status;
@property (nonatomic, copy) NSString<Optional> * consume_time;
@property (nonatomic, copy) NSString<Optional> * talk_id;
@property (nonatomic, copy) NSString<Optional> * consume;
@property (nonatomic, copy) NSArray<PCommentStatisticsM, Optional> * commentStatistics;
@end
