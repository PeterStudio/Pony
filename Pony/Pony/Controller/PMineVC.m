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
#import "PublicCustomWebVC.h"

@interface PMineVC()<UIAlertViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (strong, nonatomic) UIAlertController *mAlertController;
@property (strong, nonatomic) UserInfoM * uModel;
@property (strong, nonatomic) PMoneyM * model;
@end


@implementation PMineVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self grapUserInfo];
}

- (void)click_helpBarButtonItem{
    PublicCustomWebVC * webVC = [[PublicCustomWebVC alloc] init];
    webVC.docUrl = @"http://cdn.xiaomahome.com/protocrol/使用手册.html";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.uModel = [USERMANAGER userInfoM];
    [self.headBtn setImage:[UIImage imageNamed:self.uModel.user_img] forState:UIControlStateNormal];
    self.nameLab.text = self.uModel.user_phone;
    self.moneyLab.text = @"我的伯乐币:0.0¥";//[NSString stringWithFormat:@"我的伯乐币:%@¥",self.uModel.balance];
    
    UIBarButtonItem * helpItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStylePlain target:self action:@selector(click_helpBarButtonItem)];
    helpItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.rightBarButtonItem = helpItem;
    
    
    self.mAlertController = [UIAlertController  alertControllerWithTitle:@"充值金额"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    [self.mAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text = @"1";
        textField.placeholder = @"最低充值金额1元";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    UITextField * tf = self.mAlertController.textFields[0];
    tf.delegate = self;
    [tf addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"立即充值"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             @strongify(self)
                             [tf resignFirstResponder];
                             [self performSegueWithIdentifier:@"PPayVC" sender:tf.text];
                             NSLog(@"Resolving UIAlert Action for tapping OK Button");
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"取消充值"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 @strongify(self)
                                 NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [self.mAlertController addAction:cancel];
    [self.mAlertController addAction:ok];
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
    [self presentViewController:self.mAlertController animated:YES completion:nil];
}

- (void)textFieldDidChangeValue:(UITextField *)sender{
    UIAlertAction * ok = self.mAlertController.actions[1];
    if ([sender.text validBlank]) {
        ok.enabled = NO;
    }else{
        ok.enabled =YES;
    }
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
