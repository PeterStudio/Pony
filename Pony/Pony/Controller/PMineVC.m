//
//  PMineVC.m
//  Pony
//
//  Created by Baby on 16/5/12.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PMineVC.h"
#import "PPayVC.h"
#import "PMoneyM.h"
#import "PMoneyLogVC.h"
@interface PMineVC()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (strong, nonatomic) UIAlertView * cusAlertV;
@property (strong, nonatomic) UserInfoM * uModel;
@property (strong, nonatomic) PMoneyM * model;
@end


@implementation PMineVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self grapUserInfo];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.uModel = [USERMANAGER userInfoM];
    [self.headBtn setImage:[UIImage imageNamed:self.uModel.user_img] forState:UIControlStateNormal];
    self.nameLab.text = self.uModel.user_phone;
    self.moneyLab.text = @"我的伯乐币:0.0¥";//[NSString stringWithFormat:@"我的伯乐币:%@¥",self.uModel.balance];
    
    self.cusAlertV = [[UIAlertView alloc] initWithTitle:@"充值金额" message:nil delegate:self cancelButtonTitle:@"取消充值" otherButtonTitles:@"立即充值", nil];
    [self.cusAlertV setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *moneyField = [self.cusAlertV textFieldAtIndex:0];
    moneyField.placeholder = @"请输入充值金额";
    moneyField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (IBAction)logout:(id)sender {
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [USERMANAGER logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                            object:USERLOGIC_SB];
    }];
}

- (void)grapUserInfo{
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneyGet parameters:@{@"moneyUserId":self.uModel.user_id} success:^(NSDictionary * responseObject) {
        @strongify(self)
        self.model = [[PMoneyM alloc] initWithDictionary:responseObject error:nil];
        self.moneyLab.text = [NSString stringWithFormat:@"我的伯乐币:%@¥",self.model.moneyBalance];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - UITableViewDataSource

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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.row) {
        // 交易密码
        if ([@"1" isEqualToString:self.uModel.charge_status]) {
            // 已设置
            [self performSegueWithIdentifier:@"PRDealPswVC" sender:nil];
        }else{
            // 未设置
            [self performSegueWithIdentifier:@"PDealPasswordVC" sender:nil];
        }
    }else if (2 == indexPath.row){
        // 充值记录
        if (self.model) {
            [self performSegueWithIdentifier:@"PMoneyLogVC" sender:nil];
        }
    }
}

#pragma mark - Private

// 充值
- (IBAction)enterMoney:(id)sender {
    [self.cusAlertV show];
}

// 提现
- (IBAction)outMoney:(id)sender {
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *moneyField = [alertView textFieldAtIndex:0];
        //TODO
        if ([moneyField.text floatValue] > 0) {
            [moneyField resignFirstResponder];
            NSString * sum = moneyField.text;
            [self performSegueWithIdentifier:@"PPayVC" sender:sum];
        }else{
            [MBProgressHUD showError:@"请输入充值金额"];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id obj = [segue destinationViewController];
    if ([obj isKindOfClass:[PPayVC class]]) {
        PPayVC * vc = (PPayVC *)obj;
        vc.sum = sender;
    }else if ([obj isKindOfClass:[PMoneyLogVC class]]){
        PMoneyLogVC * vc = (PMoneyLogVC *)obj;
        vc.moneyUserId = self.model.moneyUserId;
    }
}

@end
