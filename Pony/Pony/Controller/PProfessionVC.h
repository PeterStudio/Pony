//
//  PProfessionVC.h
//  Pony
//
//  Created by 杜文 on 16/6/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//  行业

#import "BaseViewController.h"
#import "ProfessionLM.h"
@interface PProfessionVC : BaseViewController
@property (nonatomic, copy) void (^successBlock)(ProfessionM * professionM);
@end