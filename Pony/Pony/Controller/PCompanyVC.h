//
//  PCompanyVC.h
//  Pony
//
//  Created by 杜文 on 16/6/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//  公司

#import "BaseViewController.h"
#import "ProfessionLM.h"
#import "CompanyLM.h"
@interface PCompanyVC : BaseViewController
@property (nonatomic, strong) ProfessionM * obj;
@property (nonatomic, copy) void (^successBlock)(CompanyM * companyM);
@end
