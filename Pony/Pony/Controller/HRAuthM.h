//
//  HRAuthM.h
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HRAuthM : JSONModel
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * userId;
@property (nonatomic, copy) NSString<Optional> * industryId;
@property (nonatomic, copy) NSString<Optional> * companyId;
@property (nonatomic, copy) NSString<Optional> * jobId;
@property (nonatomic, copy) NSString<Optional> * startTime;
@property (nonatomic, copy) NSString<Optional> * endTime;
@property (nonatomic, copy) NSString<Optional> * companyComment;
@property (nonatomic, copy) NSString<Optional> * userAuthorityImg;
@property (nonatomic, copy) NSString<Optional> * userAgeImg;
@property (nonatomic, copy) NSString<Optional> * userAuth;
@property (nonatomic, copy) NSString<Optional> * industry;
@property (nonatomic, copy) NSString<Optional> * company;
@property (nonatomic, copy) NSString<Optional> * job;
@property (nonatomic, copy) NSString<Optional> * realName;
@property (nonatomic, copy) NSString<Optional> * authReason;

@end
