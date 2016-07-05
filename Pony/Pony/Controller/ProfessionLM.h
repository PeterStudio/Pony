//
//  ProfessionLM.h
//  Pony
//
//  Created by 杜文 on 16/7/2.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProfessionM <NSObject>
@end
@interface ProfessionM : JSONModel
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * industry;
@end

@interface ProfessionLM : JSONModel
@property (nonatomic, strong) NSArray<ProfessionM, Optional> * data;
@end
