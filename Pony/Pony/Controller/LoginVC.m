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
#import "LoginM.h"
#import <AdSupport/ASIdentifierManager.h>
#import "JCHATTimeOutManager.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) LoginVM * loginVM;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)loginJPush{
    NSString * jUsername = [USERMANAGER jPushUserName];
    NSString * jPassword = [USERMANAGER jPushPassword];
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [JMSGUser loginWithUsername:jUsername password:jPassword completionHandler:^(id resultObject, NSError *error) {
        @strongify(self)
        if (error == nil) {
            // 登录极光成功！
            [self setAlias:jUsername];
        }else{
            [MBProgressHUD hideHUD];
            NSString *alert = @"用户登录失败";
            if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
                alert = @"用户名不存在";
            } else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
                alert = @"密码错误！";
            } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
                alert = @"用户名或者密码不合法！";
            }
            [MBProgressHUD showError:alert toView:self.view];
            [USERMANAGER logout];
        }
    }];
}

/**登录*/
- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    if (![_userNameTextField.text validLoginPhoneNumber]) {
        [MBProgressHUD showError:@"用户名输入有误" toView:self.view];
        [_userNameTextField shake];
        return;
    }
    
    if (![_passwordTextField.text validLoginPassword]) {
        [MBProgressHUD showError:@"密码输入有误" toView:self.view];
        [_passwordTextField shake];
        return;
    }
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSDictionary * parameters = @{@"userName":_userNameTextField.text,@"userPassword":_passwordTextField.text,@"deviceName":[infoDic objectForKey:@"DTPlatformName"],@"imei":idfa,@"version":appVersion,@"os":@"1"};
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIUSERHTTP wPost:kAPILogin parameters:parameters success:^(id responseObject) {
        @strongify(self)
        LoginM * m = [[LoginM alloc] initWithDictionary:responseObject error:nil];
        [USERMANAGER saveUserInfo:m];
        // 登录极光
        [self loginJPush];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

/**设置alias*/
- (void)setAlias:(NSString *)_alias{
    @weakify(self)
    [JPUSHService setTags:nil alias:_alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        @strongify(self)
        if (iResCode == 0) {
            [MBProgressHUD hideHUDForView:DWRootView animated:YES];
            [USERMANAGER changeToRole:XIAOMA];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC object:PONY_SB];
        }else{
            [self setAlias:_alias];
        }
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
