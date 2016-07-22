//
//  PPositionVC.h
//  Pony
//
//  Created by 杜文 on 16/6/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//  职位

#import "BaseViewController.h"
#import "CompanyLM.h"
#import "PositionLM.h"
@interface PPositionVC : BaseViewController
@property (nonatomic, strong) CompanyM * obj;
@property (nonatomic, copy) void (^successBlock)(PositionM * positionM);
@end
