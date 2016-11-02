//
//  RegistVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "RegistVC.h"
#import "RegistVM.h"
#import <SMS_SDK/SMSSDK.h>
#import "PublicCustomWebVC.h"

@interface RegistVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@property (strong , nonatomic) RegistVM * registVM;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**发送验证码*/
- (IBAction)sendCode:(id)sender {
    if (![_userNameTextField.text validLoginPhoneNumber]) {
        [MBProgressHUD showError:@"用户名输入有误" toView:self.view];
        [_userNameTextField shake];
        return;
    }
    @weakify(self)
    _codeBtn.enabled = NO;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_userNameTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        @strongify(self)
        if (!error) {
            [self countTime];
            [MBProgressHUD showSuccess:@"短信验证码发送成功" toView:self.view];
        } else {
            _codeBtn.enabled = YES;
            [MBProgressHUD showError:@"获取验证码失败，请重新获取" toView:self.view];
        }
    }];
}


- (IBAction)agreedBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.sureBtn.enabled = sender.selected;
}

/**注册*/
- (IBAction)regist:(id)sender {
    if (![_userNameTextField.text validLoginPhoneNumber]) {
        [MBProgressHUD showError:@"用户名输入有误" toView:self.view];
        [_userNameTextField shake];
        return;
    }
    
    if ([_codeTextField.text validBlank]) {
        [MBProgressHUD showError:@"请输入验证码" toView:self.view];
        [_codeTextField shake];
        return;
    }
    
    if (![_passwordTextField.text validLoginPassword]) {
        [MBProgressHUD showError:@"密码输入有误" toView:self.view];
        [_passwordTextField shake];
        return;
    }
    
    NSDictionary * parameters = @{@"userName":_userNameTextField.text,@"userPassword":_passwordTextField.text,@"code":_codeTextField.text};
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIRegister parameters:parameters success:^(id responseObject) {
        @strongify(self)
        [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"CurUserPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [MBProgressHUD showSuccess:@"注册成功，请登录"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

/**
 *  倒计时
 */
- (void)countTime{
    __block int timeout = VERIFICATION_SUM_TIME - 1;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    @weakify(self)
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self)
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.codeBtn.enabled = YES;
                [self.codeBtn setTitle:VERIFICATION_NORMAL_TITLE forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % VERIFICATION_SUM_TIME;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeBtn setTitle:VERIFICATION_SELECT_TITLE(seconds) forState:UIControlStateDisabled];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark - Private

- (void)bindViewModel{
    RAC(self.registVM, username) = [self.userNameTextField rac_textSignal];
    RAC(self.registVM, code) = [self.codeTextField rac_textSignal];
    RAC(self.registVM, password) = [self.passwordTextField rac_textSignal];
    
    self.sureBtn.rac_command = self.registVM.sureCommand;
    
    @weakify(self)
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)registProtolDoc:(id)sender {
    PublicCustomWebVC * webVC = [[PublicCustomWebVC alloc] init];
    webVC.docUrl = @"http://cdn.xiaomahome.com/protocrol/用户协议.html";
    [self.navigationController pushViewController:webVC animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (![[UIApplication sharedApplication]textInputMode].primaryLanguage) {
        return NO;
    }
    
    if (textField == self.userNameTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }else if (textField == self.passwordTextField){
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
