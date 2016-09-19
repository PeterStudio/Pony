//
//  BillCell.m
//  Pony
//
//  Created by 杜文 on 16/9/19.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BillCell.h"

@interface BillCell()
@property (weak, nonatomic) IBOutlet UILabel *tipLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
