//
//  RegistViewController.m
//  Pony
//
//  Created by Baby on 16/1/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "RegistViewController.h"
#import <JMessage/JMessage.h>

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)registButtonClicked:(id)sender {
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
}

- (IBAction)goToLoginVC:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
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
