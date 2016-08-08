//
//  PMoneyLogCell.m
//  Pony
//
//  Created by 杜文 on 16/8/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PMoneyLogCell.h"

@interface PMoneyLogCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end

@implementation PMoneyLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEntity:(PMoneyLogM *)entity{
    self.timeLab.text = entity.logTime;
    self.moneyLab.text = entity.logMoneyFee;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
