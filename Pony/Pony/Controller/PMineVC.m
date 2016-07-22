//
//  PMineVC.m
//  Pony
//
//  Created by Baby on 16/5/12.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PMineVC.h"

@interface PMineVC()
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end


@implementation PMineVC


- (void)viewDidLoad{
    [super viewDidLoad];
    UserInfoM * uModel = [USERMANAGER userInfoM];
    [self.headBtn setImage:[UIImage imageNamed:uModel.user_img] forState:UIControlStateNormal];
    self.nameLab.text = uModel.user_phone;
    self.moneyLab.text = [NSString stringWithFormat:@"我的伯乐币:%@¥",uModel.balance];
}

- (IBAction)logout:(id)sender {
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [USERMANAGER logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                            object:USERLOGIC_SB];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 150.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
}


@end
