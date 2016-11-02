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
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation BillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEntity:(BillM *)entity{
    if ([@"1" isEqualToString:entity.logType]) {
        // 收入
        self.tipLab.text = @"收入";
    }else{
        // 提现
        self.tipLab.text = @"提现";
    }
    self.timeLab.text = entity.logTime;
    self.moneyLab.text = [NSString stringWithFormat:@"+%@",entity.logMoneyFee];
    
    if ([@"0" isEqualToString:entity.moneyStatus]) {
        self.contentLab.text = [@"发起交易:" stringByAppendingString:entity.moneyStatusName];
    }else if ([@"1" isEqualToString:entity.moneyStatus]){
        self.contentLab.text = [@"交易成功:" stringByAppendingString:entity.moneyStatusName];
    }else if ([@"2" isEqualToString:entity.moneyStatus]){
        self.contentLab.text = [@"交易失败:" stringByAppendingString:entity.moneyStatusName];
    }else if ([@"3" isEqualToString:entity.moneyStatus]){
        self.contentLab.text = [@"退款,当前系统不支持:" stringByAppendingString:entity.moneyStatusName];
    }else if ([@"4" isEqualToString:entity.moneyStatus]){
        self.contentLab.text = [@"等待用户付款:" stringByAppendingString:entity.moneyStatusName];
    }else{
        self.contentLab.text =@"";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
