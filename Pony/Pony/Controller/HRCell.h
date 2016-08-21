//
//  HRCell.h
//  Pony
//
//  Created by 杜文 on 16/7/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PonyHJNoticM.h"


@protocol HRCellDelegate <NSObject>
- (void)boleQDAction:(NSIndexPath *)_indx;
@end

@interface HRCell : UITableViewCell
@property (weak, nonatomic) id<HRCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath * indx;
@property (strong, nonatomic) PonyHJNoticM * entity;
@end
