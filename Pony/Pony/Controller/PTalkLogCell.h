//
//  PTalkLogCell.h
//  Pony
//
//  Created by 杜文 on 16/8/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTalkLogM.h"

@protocol PTalkLogCellDelegate <NSObject>
- (void)showBoleDetailWithIndx:(NSIndexPath *)_indx;
@end

@interface PTalkLogCell : UITableViewCell
@property (nonatomic, strong) PTalkLogM * entity;
@property (nonatomic, weak) id<PTalkLogCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath * indx;
@end
