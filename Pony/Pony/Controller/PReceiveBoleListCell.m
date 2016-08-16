//
//  PReceiveBoleListCell.m
//  Pony
//
//  Created by 杜文 on 16/8/15.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PReceiveBoleListCell.h"

@interface PReceiveBoleListCell()
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation PReceiveBoleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEntity:(BoleQDNoticM *)entity{
    [self.headIV setImage:[UIImage imageNamed:entity.user_img]];
    self.nameLab.text = entity.nickName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
