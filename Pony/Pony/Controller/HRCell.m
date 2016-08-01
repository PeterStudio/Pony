//
//  HRCell.m
//  Pony
//
//  Created by 杜文 on 16/7/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRCell.h"

@interface HRCell()

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *grapBtn;

@end

@implementation HRCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)grapAction:(id)sender {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
