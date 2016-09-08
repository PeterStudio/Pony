//
//  PayReturnM.h
//  Pony
//
//  Created by 杜文 on 16/9/7.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PayReturnM : JSONModel
@property (nonatomic, copy) NSString<Optional> * memo;
@property (nonatomic, copy) NSString<Optional> * result;
@property (nonatomic, copy) NSString<Optional> * resultStatus;
@end
