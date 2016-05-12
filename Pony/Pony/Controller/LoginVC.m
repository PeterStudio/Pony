//
//  LoginVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "LoginVC.h"
#import <JMessage/JMessage.h>
#import "LoginVM.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) LoginVM * loginVM;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     [self.view endEditing:YES];
     if ([_userNameTextField.text validBlank]) {
     [MBProgressHUD showError:@"请输入用户名" toView:self.view];
     return;
     }
     
     if ([_passwordTextField.text validBlank]) {
     [MBProgressHUD showError:@"请输入密码" toView:self.view];
     return;
     }
     [MBProgressHUD showMessage:@"登录中。。。" toView:self.view];
     [JMSGUser loginWithUsername:_userNameTextField.text password:_passwordTextField.text completionHandler:^(id resultObject, NSError *error) {
     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
     if (error == nil) {
     // 登录成功！
     [self performSegueWithIdentifier:@"loginToHomeVC_ID" sender:nil];
     }else{
     NSString *alert = @"用户登录失败";
     if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
     alert = @"用户名不存在";
     } else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
     alert = @"密码错误！";
     } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
     alert = @"用户名或者密码不合法！";
     }
     [MBProgressHUD showError:alert toView:self.view];
     }
     }];

     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
}


#pragma mark - private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_loginVM, title);
    RAC(self.loginVM, username) = [self.userNameTextField rac_textSignal];
    RAC(self.loginVM, password) = [self.passwordTextField rac_textSignal];
    self.loginButton.rac_command = self.loginVM.loginCommand;
    
    @weakify(self)
    [[self.userNameTextField.rac_textSignal filter:^BOOL(NSString * value) {
        return value.length > 11;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.userNameTextField shake];
    }];
    
    [[self.passwordTextField.rac_textSignal filter:^BOOL(NSString * value) {
        return value.length > 16;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.passwordTextField shake];
    }];
    
    RAC(self.userNameTextField, textColor) = [self.loginVM.phoneValidSignal map:^id(NSNumber * value) {
        return [value boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    
    RAC(self.passwordTextField, textColor) = [self.loginVM.passwordValidSignal map:^id(NSNumber * value) {
        return [value boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        @strongify(self)
        [self.loginVM requestLogin:^(id object) {
            
        } error:^(NSError *error) {
            
        } failure:^(NSError *error) {
            
        } completion:^{
            
        }];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [self.loginVM.loginCommand.executionSignals subscribeNext:^(id x) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                            object:HR_SB];
    } error:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
