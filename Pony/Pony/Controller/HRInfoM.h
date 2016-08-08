//
//  HRInfoM.h
//  Pony
//
//  Created by 杜文 on 16/8/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol  HRBoleDetailM <NSObject>
@end
@interface HRBoleDetailM : JSONModel
@property (nonatomic, copy) NSString<Optional> * job_year;
@property (nonatomic, copy) NSString<Optional> * user_name;
@property (nonatomic, copy) NSString<Optional> * user_auth;
@property (nonatomic, copy) NSString<Optional> * industry;
@property (nonatomic, copy) NSString<Optional> * real_name;
@property (nonatomic, copy) NSString<Optional> * user_img;
@property (nonatomic, copy) NSString<Optional> * auth_reason;
@property (nonatomic, copy) NSString<Optional> * user_score;
@property (nonatomic, copy) NSString<Optional> * user_id;
@property (nonatomic, copy) NSString<Optional> * job_post;
@property (nonatomic, copy) NSString<Optional> * user_nickname;
@property (nonatomic, copy) NSString<Optional> * user_level;
@property (nonatomic, copy) NSString<Optional> * company;
@property (nonatomic, copy) NSString<Optional> * jpush_bole_id;
@end

@protocol  HRCommentStatisticsM <NSObject>
@end
@interface HRCommentStatisticsM : JSONModel
@property (nonatomic, copy) NSString<Optional> * comment_count;
@property (nonatomic, copy) NSString<Optional> * comment_title;
@property (nonatomic, copy) NSString<Optional> * user_id;
@end

@interface HRInfoM : JSONModel
@property (nonatomic, strong) HRBoleDetailM<Optional> * boledetail;
@property (nonatomic, copy) NSString<Optional> * bolestatus;
@property (nonatomic, strong) NSArray<HRCommentStatisticsM, Optional> * commentStatistics;
@end
