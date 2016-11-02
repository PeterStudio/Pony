//
//  GetMoneyFormPonyVC.m
//  Pony
//
//  Created by 杜文 on 16/9/8.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "GetMoneyFormPonyVC.h"

@interface GetMoneyFormPonyVC ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountLab;
@property (weak, nonatomic) IBOutlet UITextField *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;
@property (strong, nonatomic) UserInfoM * uModel;
@end

@implementation GetMoneyFormPonyVC

- (void)click_backBarButtonItem{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PMineVC" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.bindAlipayM.alipayinfo.alipayName) {
        self.nameLab.text = self.bindAlipayM.alipayinfo.alipayName;
    }else{
        self.nameLab.text = self.name;
    }
    
    if (self.bindAlipayM.alipayinfo.alipayNo) {
        self.accountLab.text = self.bindAlipayM.alipayinfo.alipayNo;
    }else{
        self.accountLab.text = self.account;
    }
    
    self.uModel = [USERMANAGER userInfoM];
     [self refreshTipLab:@"0" money:@"0"];
    [self.moneyLab addTarget:self action:@selector(textFieldDidChangeValue:) forControlEvents:UIControlEventEditingChanged];
    self.moneyLab.placeholder = [NSString stringWithFormat:@"最大可提现%@伯乐币",self.bindAlipayM.money];
}

- (void)textFieldDidChangeValue:(UITextField *)sender{
    if (![sender.text validBlank]) {
        if ([@"0" isEqualToString:[sender.text substringToIndex:1]]) {
            sender.text = [sender.text substringFromIndex:1];
        }
        if ([sender.text floatValue] < 2 * [self.uModel.bolebi_rate floatValue]) {
            // 标签置0
            [self refreshTipLab:@"0" money:@"0"];
        }else{
            float money = ([sender.text floatValue] / [self.uModel.bolebi_rate floatValue]) * [self.uModel.bolebi_tax floatValue] - 1;
            float fee = ([sender.text floatValue] / [self.uModel.bolebi_rate floatValue]) - money;
            [self refreshTipLab:[NSString stringWithFormat:@"%.2f",fee] money:[NSString stringWithFormat:@"%.2f",money]];
        }
    }
}

- (void)refreshTipLab:(NSString *)_fee money:(NSString *)_money{
    NSString *testString = [NSString stringWithFormat:@"服务费：%@元，到账金额：%@元",_fee,_money];
    NSRange range1 = [testString rangeOfString:_fee];
    NSRange range2 = [testString rangeOfString:_money options:NSBackwardsSearch];
    
    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    self.infoLab.attributedText = testAttriString;
}

- (IBAction)limitMoneyBtnClicked:(id)sender {
    NSString * str = [NSString stringWithFormat:@"%.0f伯乐币起提，单笔最高提现%.0f伯乐币",2 * [self.uModel.bolebi_rate floatValue],1000 * [self.uModel.bolebi_rate floatValue]];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)submitBtnClicked:(id)sender {
    [self.moneyLab resignFirstResponder];
    if ([self.moneyLab.text validBlank]) {
        [MBProgressHUD showError:@"请输入提现伯乐币"];
        return;
    }
    
    if ([self.moneyLab.text integerValue] > [self.bindAlipayM.money integerValue]) {
        [MBProgressHUD showError:@"您的伯乐币不足以提现哦～"];
        return;
    }
    
    if ([self.moneyLab.text integerValue] < (int)(2 * [self.uModel.bolebi_rate floatValue])) {
        [self limitMoneyBtnClicked:nil];
        return;
    }
    
    UIAlertController * alertVC = [UIAlertController  alertControllerWithTitle:@"请输入交易密码"  message:nil  preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self)
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入交易密码";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"提现"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             @strongify(self)
                             [self.view endEditing:YES];
                             
                             @weakify(self)
                              UITextField * tf = alertVC.textFields[0];
                             if ([tf.text validBlank]) {
                                 [MBProgressHUD showError:@"请输入交易密码"];
                             }else{
                                 [MBProgressHUD showMessage:nil];
                                 [APIHTTP wwPost:kAPIAlipayCashOut parameters:@{@"userId":self.bindAlipayM.alipayinfo.userId,@"outBolebi":self.moneyLab.text,@"cashPassword":[tf.text md5Hex]} success:^(NSDictionary * responseObject) {
                                     @strongify(self)
                                     [MBProgressHUD showSuccess:@"提现成功！"];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"PMineVC" object:nil];
                                 } error:^(NSError *err) {
                                     [MBProgressHUD showError:err.localizedDescription toView:self.view];
                                 } failure:^(NSError *err) {
                                     [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
                                 } completion:^{
                                     [MBProgressHUD hideHUD];
                                 }];
                             }
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"取消"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 @strongify(self)
                                 NSLog(@"Resolving UIAlertActionController for tapping cancel button");
                                 [self dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
