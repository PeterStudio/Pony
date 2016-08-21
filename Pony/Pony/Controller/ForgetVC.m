//
//  ForgetVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "ForgetVC.h"
#import "ForgetVM.h"
#import <SMS_SDK/SMSSDK.h>
#import "ResetVC.h"

@interface ForgetVC ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (strong, nonatomic) ForgetVM * forgetVM;
@end

@implementation ForgetVC

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
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_userNameTextField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        @strongify(self)
        if (!error) {
            [self countTime];
            [MBProgressHUD showSuccess:@"获取验证码成功" toView:self.view];
        } else {
            [MBProgressHUD showError:@"获取验证码失败，请重新获取" toView:self.view];
        }
    }];
}

/**验证*/
- (IBAction)check:(id)sender {
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
    
    NSDictionary * parameters = @{@"userName":_userNameTextField.text,@"code":_codeTextField.text};
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIForget parameters:parameters success:^(id responseObject) {
        @strongify(self)
        [self performSegueWithIdentifier:@"ResetVC" sender:nil];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
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
    RAC(self.forgetVM, username) = [self.userNameTextField rac_textSignal];
    RAC(self.forgetVM, code) = [self.codeTextField rac_textSignal];
    self.sureBtn.rac_command = self.forgetVM.checkCommand;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    id object = [segue destinationViewController];
    if ([object isKindOfClass:[ResetVC class]]) {
        ResetVC * vc = (ResetVC *)object;
        vc.userName = _userNameTextField.text;
        vc.code = _codeTextField.text;
    }
}


@end
