//
//  PFeedBackVC.h
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseViewController.h"
#import "PEndTalkM.h"


@interface PFeedBackVC : BaseViewController
@property (nonatomic, copy) NSString * boleId;
@property(nonatomic, strong) PEndTalkM * pEndTalkM;
@end
