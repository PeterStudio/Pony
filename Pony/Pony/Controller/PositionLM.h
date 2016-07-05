//
//  PositionLM.h
//  Pony
//
//  Created by 杜文 on 16/7/2.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol PositionM <NSObject>

@end
@interface PositionM : JSONModel
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * jobPost;
@end

@interface PositionLM : JSONModel
@property (nonatomic, strong) NSArray<PositionM, Optional> * data;
@end
