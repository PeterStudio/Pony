//
//  PublicCustomWebVC.h
//  Pony
//
//  Created by 杜文 on 16/8/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseViewController.h"

@interface PublicCustomWebVC : BaseViewController
/**标题*/
@property (nonatomic, copy) NSString * docTitle;
/**链接*/
@property (nonatomic, copy) NSString * docUrl;
/**手机号*/
@property (nonatomic, copy) NSString * telPhone;
@end
