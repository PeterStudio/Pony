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
#import <AdSupport/ASIdentifierManager.h>
#import "TWMessageBarManager.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) LoginVM * loginVM;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

//     [MBProgressHUD showMessage:@"登录中。。。" toView:self.view];
//     [JMSGUser loginWithUsername:_userNameTextField.text password:_passwordTextField.text completionHandler:^(id resultObject, NSError *error) {
//     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
//     if (error == nil) {
//     // 登录成功！
//     [self performSegueWithIdentifier:@"loginToHomeVC_ID" sender:nil];
//     }else{
//     NSString *alert = @"用户登录失败";
//     if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
//     alert = @"用户名不存在";
//     } else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
//     alert = @"密码错误！";
//     } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
//     alert = @"用户名或者密码不合法！";
//     }
//     [MBProgressHUD showError:alert toView:self.view];
//     }
//     }];
    
}

/**登录*/
- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    if (![_userNameTextField.text validLoginPhoneNumber]) {
        kMRCError(@"用户名输入有误");
        [_userNameTextField shake];
        return;
    }
    
    if (![_passwordTextField.text validLoginPassword]) {
        kMRCError(@"密码输入有误");
        [_passwordTextField shake];
        return;
    }
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSDictionary * parameters = @{@"userName":_userNameTextField.text,@"userPassword":_passwordTextField.text,@"deviceName":[infoDic objectForKey:@"DTPlatformName"],@"imei":idfa,@"version":appVersion,@"os":@"1"};
    
    [MBProgressHUD showHUDAddedTo:DWRootView animated:YES];
    [APIHTTP wPost:kAPILogin parameters:parameters success:^(id responseObject) {
        
    } error:^(NSError *err) {
        kMRCError(err.localizedDescription);
    } failure:^(NSError *err) {
        kMRCError(err.localizedDescription);
    } completion:^{
        [MBProgressHUD hideHUDForView:DWRootView animated:YES];
    }];
}


#pragma mark - private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_loginVM, title);
    RAC(self.loginVM, username) = [self.userNameTextField rac_textSignal];
    RAC(self.loginVM, password) = [self.passwordTextField rac_textSignal];
    self.loginButton.rac_command = self.loginVM.loginCommand;
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
