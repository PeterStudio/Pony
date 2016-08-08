//
//  PTalkLogCell.m
//  Pony
//
//  Created by 杜文 on 16/8/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PTalkLogCell.h"

@interface PTalkLogCell()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation PTalkLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEntity:(PTalkLogM *)entity{
    if (entity.user_img) {
        [self.headBtn setImage:[UIImage imageNamed:entity.user_img] forState:UIControlStateNormal];
    }
    self.nameLab.text = entity.user_nickname;
}

- (IBAction)headBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(showBoleDetailWithIndx:)]) {
        [self.delegate showBoleDetailWithIndx:self.indx];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
