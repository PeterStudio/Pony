//
//  VersionM.h
//  Pony
//
//  Created by 杜文 on 16/9/5.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface VersionM : JSONModel
@property (nonatomic, copy) NSString<Optional> * sappname;
@property (nonatomic, copy) NSString<Optional> * spackagename;
@property (nonatomic, copy) NSString<Optional> * sapkurl;
@property (nonatomic, copy) NSString<Optional> * iforceupdate;      // 是否强制升级 0：否，1：是
@property (nonatomic, copy) NSString<Optional> * supdatetips;       // 升级标题
@property (nonatomic, copy) NSString<Optional> * sversiondesc;      // 升级内容
@property (nonatomic, copy) NSString<Optional> * iversioncode;
@property (nonatomic, copy) NSString<Optional> * sversionname;
@end
