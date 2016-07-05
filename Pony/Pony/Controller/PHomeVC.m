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
#import "PProfessionVC.h"
#import "PCompanyVC.h"
#import "PPositionVC.h"

#import "ProfessionLM.h"
#import "CompanyLM.h"
#import "PositionLM.h"

@interface PHomeVC ()

@property (nonatomic, strong) ProfessionM * professionM;
@property (nonatomic, strong) CompanyM * companyM;
@property (nonatomic, strong) PositionM * positionM;
@property (weak, nonatomic) IBOutlet UILabel *hangYeLab;
@property (weak, nonatomic) IBOutlet UILabel *gongSiLab;
@property (weak, nonatomic) IBOutlet UILabel *zhiYeLab;

@end

@implementation PHomeVC

- (void)setProfessionM:(ProfessionM *)professionM{
    if (professionM) {
        self.hangYeLab.text = professionM.industry;
    }else{
        self.hangYeLab.text = @"未选择";
    }
}

- (void)setCompanyM:(CompanyM *)companyM{
    if (companyM) {
        self.gongSiLab.text = companyM.company;
    }else{
        self.gongSiLab.text = @"未选择";
    }
}

- (void)setPositionM:(PositionM *)positionM{
    if (positionM) {
        self.zhiYeLab.text = positionM.jobPost;
    }else{
        self.zhiYeLab.text = @"未选择";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)switchToHR:(id)sender {
    // 我是伯乐
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [MBProgressHUD hideHUD];
        @strongify(self)
        if (error == nil) {
            // 退出极光成功！
            [self loginJPush];
        }else{
            [MBProgressHUD showError:@"切换失败，请稍后再试" toView:self.view];
        }
    }];
}

- (IBAction)callButonClicked:(id)sender {
    JCHATContactsViewController *contactsViewController = [[JCHATContactsViewController alloc]
                                                           initWithNibName:@"JCHATContactsViewController" bundle:nil];
    [self.navigationController pushViewController:contactsViewController animated:YES];
}

- (void)loginJPush{
    NSString * jUsername = [USERMANAGER jPushBoleUsername];
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
        }
    }];
}

/**设置alias*/
- (void)setAlias:(NSString *)_alias{
    @weakify(self)
    [JPUSHService setTags:nil alias:_alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        @strongify(self)
        if (iResCode == 0) {
            [MBProgressHUD hideHUD];
            [USERMANAGER changeToRole:BOLE];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC object:HR_SB];
        }else{
            [self setAlias:_alias];
        }
    }];
}


- (IBAction)goToProfessVC:(id)sender {
    [self performSegueWithIdentifier:@"PProfessionVC" sender:nil];
}

- (IBAction)goToCompanyVC:(id)sender {
    if (self.professionM) {
        [self performSegueWithIdentifier:@"PCompanyVC" sender:nil];
    }else{
        [MBProgressHUD showError:@"请选择行业" toView:self.view];
    }
}

- (IBAction)goToPositionVC:(id)sender {
    if (self.professionM) {
        [self performSegueWithIdentifier:@"PPositionVC" sender:nil];
    }else{
        [MBProgressHUD showError:@"请选择行业" toView:self.view];
    }
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
