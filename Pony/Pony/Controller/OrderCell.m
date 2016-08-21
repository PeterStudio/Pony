//
//  OrderCell.m
//  Pony
//
//  Created by 杜文 on 16/8/1.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell()
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEntity:(HROrderM *)entity{
    [self.headIV setImage:[UIImage imageNamed:entity.user_img]];
    self.timeLab.text = entity.talk_end_time;
    self.nameLab.text = entity.user_nickname;
    if ([@"1" isEqualToString:entity.talk_status]) {
        self.statusLab.text = @"已完成";
    }else{
        self.statusLab.text = @"未完成";
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
