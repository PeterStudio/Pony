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
#import <AlipaySDK/AlipaySDK.h>
#import "PaySignM.h"
#import "SearchBindAlipayM.h"

#import "BindZhiFuBaoVC.h"
#import "GetMoneyFormPonyVC.h"

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

- (void)paySuccess:(NSNotification *)noti{
    [self grapUserInfo];
}

- (void)payMoney:(NSString *)_money{
    NSString * title = @"晓马过河充值";
    NSString * body = [NSString stringWithFormat:@"充值金额:%@元",_money];
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneyCashSign parameters:@{@"subject":title,@"body":body,@"total":_money} success:^(NSDictionary * responseObject) {
        @strongify(self)
        PaySignM * model = [[PaySignM alloc] initWithDictionary:responseObject error:nil];
        if (model.orderwithsign) {
            [[AlipaySDK defaultService] payOrder:model.orderwithsign fromScheme:@"pony" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

- (void)refreshMoneyLab:(NSString *)_money{
    NSString *testString = [NSString stringWithFormat:@"我的伯乐币:%@伯乐币",_money];
    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, testAttriString.length - 9)];
    self.moneyLab.attributedText = testAttriString;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.uModel = [USERMANAGER userInfoM];
    [self.headBtn setImage:[UIImage imageNamed:self.uModel.user_img] forState:UIControlStateNormal];
    self.nameLab.text = self.uModel.user_phone;
    [self refreshMoneyLab:@"0.0"];
    
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurUserPhone"];
    if (![TEST_PHONE_NUMBER isEqualToString:str]) {
        UIBarButtonItem * helpItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStylePlain target:self action:@selector(click_helpBarButtonItem)];
        helpItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        self.navigationItem.rightBarButtonItem = helpItem;
    }
    
    self.mAlertController = [UIAlertController  alertControllerWithTitle:@"充值金额"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    [self.mAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text = @"";
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
                             [self payMoney:tf.text];
                             NSLog(@"Resolving UIAlert Action for tapping OK Button");
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    ok.enabled = NO;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess:) name:@"PAY_SUCCESS" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToSelf:) name:@"PMineVC" object:nil];
}

- (void)popToSelf:(NSNotification *)notic{
    [self.navigationController popToViewController:self animated:YES];
}

- (IBAction)logout:(id)sender {
    [MBProgressHUD showMessage:nil];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [MBProgressHUD hideHUD];
        [USERMANAGER logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                            object:USERLOGIC_SB];
    }];
}

- (void)grapUserInfo{
//    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneyGet parameters:@{@"moneyUserId":self.uModel.user_id} success:^(NSDictionary * responseObject) {
        @strongify(self)
        self.model = [[PMoneyM alloc] initWithDictionary:responseObject error:nil];
        [self refreshMoneyLab:self.model.moneyBalance];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
//        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurUserPhone"];
    if ([TEST_PHONE_NUMBER isEqualToString:str]) {
        return 3;
    }else{
        return 4;
    }
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
    }else if (3 == indexPath.row){
        // 关于
        PublicCustomWebVC * webVC = [[PublicCustomWebVC alloc] init];
        webVC.docUrl = @"http://cdn.xiaomahome.com/protocrol/关于我们.html";
        [self.navigationController pushViewController:webVC animated:YES];
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
        if ([@"0" isEqualToString:[sender.text substringToIndex:1]]) {
            sender.text = [sender.text substringFromIndex:1];
            if (sender.text.length == 0) {
                ok.enabled = NO;
            }else{
                ok.enabled =YES;
            }
        }else{
            ok.enabled =YES;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0) return YES;
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 8) {
        // 最大限制8位
        return NO;
    }
    return YES;
}

// 提现
- (IBAction)outMoney:(id)sender {
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIAlipayInfo parameters:@{} success:^(NSDictionary * responseObject) {
        @strongify(self)
        SearchBindAlipayM * searchBindAlipayM = [[SearchBindAlipayM alloc] initWithDictionary:responseObject error:nil];
        if ([@"0" isEqualToString:searchBindAlipayM.alipaystatus]) {
            // 未绑定
            [self performSegueWithIdentifier:@"BindZhiFuBaoVC" sender:searchBindAlipayM];
        }else if ([@"1" isEqualToString:searchBindAlipayM.alipaystatus]){
            //  已绑定
            [self performSegueWithIdentifier:@"GetMoneyFormPonyVC" sender:searchBindAlipayM];
        }
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];

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
    if ([obj isKindOfClass:[PMoneyLogVC class]]){
        PMoneyLogVC * vc = (PMoneyLogVC *)obj;
        vc.moneyUserId = self.model.moneyUserId;
    }else if ([obj isKindOfClass:[BindZhiFuBaoVC class]]){
        BindZhiFuBaoVC * vc = (BindZhiFuBaoVC *)obj;
        vc.searchBindAlipayM = sender;
        vc.userID = self.uModel.user_id;
    }else if ([obj isKindOfClass:[GetMoneyFormPonyVC class]]){
        GetMoneyFormPonyVC * vc = (GetMoneyFormPonyVC *)obj;
        vc.bindAlipayM = sender;
    }
}

@end
