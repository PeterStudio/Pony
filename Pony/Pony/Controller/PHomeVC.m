//
//  PHomeVC.m
//  Pony
//
//  Created by 杜文 on 16/6/7.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PHomeVC.h"
#import "JCHATContactsViewController.h"
#import <JMessage/JMessage.h>

@interface PHomeVC ()

@property (weak, nonatomic) IBOutlet UILabel *hangYeLab;
@property (weak, nonatomic) IBOutlet UILabel *gongSiLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiYeLab;

@end

@implementation PHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)switchToHR:(id)sender {
    // 我是伯乐
    [self loginJPush];
}

- (IBAction)callButonClicked:(id)sender {
    JCHATContactsViewController *contactsViewController = [[JCHATContactsViewController alloc]
                                                           initWithNibName:@"JCHATContactsViewController" bundle:nil];
    [self.navigationController pushViewController:contactsViewController animated:YES];
}

- (void)loginJPush{
    NSString * jUsername = [USERMANAGER jPushBoleUsername];
    NSString * jPassword = [USERMANAGER jPushPassword];
    [MBProgressHUD showHUDAddedTo:DWRootView animated:YES];
    @weakify(self)
    [JMSGUser loginWithUsername:jUsername password:jPassword completionHandler:^(id resultObject, NSError *error) {
        @strongify(self)
        if (error == nil) {
            // 登录极光成功！
            [self setAlias:jUsername];
        }else{
            [MBProgressHUD hideHUDForView:DWRootView animated:YES];
            NSString *alert = @"用户登录失败";
            if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
                alert = @"用户名不存在";
            } else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
                alert = @"密码错误！";
            } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
                alert = @"用户名或者密码不合法！";
            }
            kMRCError(alert);
        }
    }];
}

/**设置alias*/
- (void)setAlias:(NSString *)_alias{
    @weakify(self)
    [JPUSHService setTags:nil alias:_alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        @strongify(self)
        if (iResCode == 0) {
            [MBProgressHUD hideHUDForView:DWRootView animated:YES];
            [USERMANAGER changeToRole:BOLE];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC object:HR_SB];
        }else{
            [self setAlias:_alias];
        }
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
