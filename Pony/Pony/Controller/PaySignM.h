//
//  PaySignM.h
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PaySignM : JSONModel
@property (nonatomic, copy) NSString<Optional> * order;
@property (nonatomic, copy) NSString<Optional> * orderwithsign;
@property (nonatomic, copy) NSString<Optional> * sign;
@end
