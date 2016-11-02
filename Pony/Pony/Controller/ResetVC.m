//
//  ResetVC.m
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "ResetVC.h"
#import "ResetVM.h"

@interface ResetVC ()
@property (weak, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *cPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) ResetVM * resetVM;
@end

@implementation ResetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**确定*/
- (IBAction)sure:(id)sender {
    if (![_nPasswordTextField.text validLoginPassword]) {
        [MBProgressHUD showError:@"密码，6-16位字母＋数字，支持_" toView:self.view];
        [_nPasswordTextField shake];
        return;
    }
    
    if (![_nPasswordTextField.text isEqualToString:_cPasswordTextField.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致" toView:self.view];
        [_cPasswordTextField shake];
        return;
    }
    
    NSDictionary * parameters = @{@"userName":_userName,@"code":_code,@"new_password":_nPasswordTextField.text};
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIReset parameters:parameters success:^(id responseObject) {
        @strongify(self)
        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"CurUserPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MBProgressHUD showSuccess:@"找回密码成功，请登录"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - Private

- (void)bindViewModel{
    RAC(self.resetVM, nPsw) = [self.nPasswordTextField rac_textSignal];
    RAC(self.resetVM, cPsw) = [self.cPasswordTextField rac_textSignal];
    self.sureButton.rac_command = self.resetVM.sureCommand;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![[UIApplication sharedApplication]textInputMode].primaryLanguage) {
        return NO;
    }
    
    if (textField == self.nPasswordTextField || textField == self.cPasswordTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 16) {
            return NO;
        }
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
