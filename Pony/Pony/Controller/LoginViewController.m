//
//  LoginViewController.m
//  Pony
//
//  Created by Baby on 16/1/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "LoginViewController.h"
#import <JMessage/JMessage.h>
#import "LoginVM.h"


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;


@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (strong, nonatomic) LoginVM * viewModel;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.viewModel = [LoginVM new];
    [self bindViewModel];
}

- (IBAction)loginButtonClicked:(id)sender {
//    [self.view endEditing:YES];
//    if ([_userNameTextField.text validBlank]) {
//        [MBProgressHUD showError:@"请输入用户名" toView:self.view];
//        return;
//    }
//    
//    if ([_passwordTextField.text validBlank]) {
//        [MBProgressHUD showError:@"请输入密码" toView:self.view];
//        return;
//    }
//    [MBProgressHUD showMessage:@"登录中。。。" toView:self.view];
//    [JMSGUser loginWithUsername:_userNameTextField.text password:_passwordTextField.text completionHandler:^(id resultObject, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//        if (error == nil) {
//            // 登录成功！
//            [self performSegueWithIdentifier:@"loginToHomeVC_ID" sender:nil];
//        }else{
//            NSString *alert = @"用户登录失败";
//            if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
//                alert = @"用户名不存在";
//            } else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
//                alert = @"密码错误！";
//            } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
//                alert = @"用户名或者密码不合法！";
//            }
//            [MBProgressHUD showError:alert toView:self.view];
//        }
//    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 130.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
}


#pragma mark - private

- (void)bindViewModel{
    RAC(self.viewModel, username) = [self.userNameTextField rac_textSignal];
    RAC(self.viewModel, password) = [self.passwordTextField rac_textSignal];
    self.loginButton.rac_command = self.viewModel.loginCommand;
    
//    [[self.userNameTextField.rac_textSignal filter:^BOOL(NSString * value) {
//        return value.length < 11;
//    }] subscribeNext:^(NSString * x) {
//        self.userNameTextField.text = x;
//    }];
    
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
