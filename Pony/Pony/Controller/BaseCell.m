//
//  BaseCell.m
//  Pony
//
//  Created by 杜文 on 16/7/5.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@end

@implementation BaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setName:(NSString *)name{
    self.nameLab.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
