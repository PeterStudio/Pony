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

@interface RegistVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (strong , nonatomic) RegistVM * registVM;
@end

@implementation RegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     if ([_userNameTextField.text validBlank]) {
     [MBProgressHUD showError:@"请输入用户名" toView:self.view];
     return;
     }
     
     if ([_passwordTextField.text validBlank]) {
     [MBProgressHUD showError:@"请输入密码" toView:self.view];
     return;
     }
     [MBProgressHUD showMessage:@"注册中。。。" toView:self.view];
     [JMSGUser registerWithUsername:_userNameTextField.text password:_passwordTextField.text  completionHandler:^(id resultObject, NSError *error) {
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     if (error == nil) {
     // 注册成功！
     [self.navigationController popViewControllerAnimated:YES];
     }else{
     NSString *alert = @"用户登录失败";
     if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
     alert = @"用户名不存在";
     }else if (error.code == JCHAT_ERROR_REGISTER_EXIST){
     alert = @"用户名存在";
     }
     else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
     alert = @"密码错误！";
     } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
     alert = @"用户名或者密码不合法！";
     }
     [MBProgressHUD showError:alert toView:self.view];
     }
     
     }];
     */
}

/**发送验证码*/
- (IBAction)sendCode:(id)sender {
    if (![_userNameTextField.text validLoginPhoneNumber]) {
        kMRCError(@"用户名输入有误");
        [_userNameTextField shake];
        return;
    }
    @weakify(self)
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_userNameTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        @strongify(self)
        if (!error) {
            [self countTime];
            kMRCSuccess(@"获取验证码成功");
        } else {
            kMRCError(@"获取验证码失败，请重新获取");
        }
    }];
}

/**注册*/
- (IBAction)regist:(id)sender {
    if (![_userNameTextField.text validLoginPhoneNumber]) {
        kMRCError(@"用户名输入有误");
        [_userNameTextField shake];
        return;
    }
    
    if ([_codeTextField.text validBlank]) {
        kMRCError(@"请输入验证码");
        [_codeTextField shake];
        return;
    }
    
    if (![_passwordTextField.text validLoginPassword]) {
        kMRCError(@"密码输入有误");
        [_passwordTextField shake];
        return;
    }
    
    NSDictionary * parameters = @{@"userName":_userNameTextField.text,@"userPassword":_passwordTextField.text,@"code":_codeTextField.text};
    [MBProgressHUD showHUDAddedTo:DWRootView animated:YES];
    @weakify(self)
    [APIHTTP wPost:kAPIRegister parameters:parameters success:^(id responseObject) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *err) {
        kMRCError(err.localizedDescription);
    } failure:^(NSError *err) {
        kMRCError(err.localizedDescription);
    } completion:^{
        [MBProgressHUD hideHUDForView:DWRootView animated:YES];
    }];
}

/**
 *  倒计时
 */
- (void)countTime{
    _codeBtn.enabled = NO;
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
