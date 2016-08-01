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
#import "PCallVC.h"


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
    if (self.professionM) {
        @weakify(self)
        [MBProgressHUD showMessage:@"开始呼叫"];
        [APIHTTP wPost:kAPIUserjobsSearch parameters:@{@"industry":self.professionM.industry,@"company":self.companyM.company?self.companyM.company:@"",@"jobPost":self.positionM.jobPost?self.positionM.jobPost:@""} success:^(NSDictionary * responseObject) {
            @strongify(self)
            [self performSegueWithIdentifier:@"PCallVC" sender:nil];
        } error:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } failure:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } completion:^{
            [MBProgressHUD hideHUD];
        }];
    }else{
        [MBProgressHUD showError:@"请选择行业" toView:self.view];
    }
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
    if (self.companyM) {
        [self performSegueWithIdentifier:@"PPositionVC" sender:nil];
    }else{
        [MBProgressHUD showError:@"请选择公司" toView:self.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    id object = [segue destinationViewController];
    if ([object isKindOfClass:[PProfessionVC class]]) {
        PProfessionVC * vc = object;
        @weakify(self)
        vc.successBlock = ^(ProfessionM * obj){
            @strongify(self)
            if (obj != self.professionM) {
                self.professionM = obj;
                self.hangYeLab.text = self.professionM.industry;
                self.companyM = nil;
                self.positionM = nil;
                self.gongSiLab.text = @"未选择";
                self.zhiYeLab.text = @"未选择";
            }
        };
    }else if ([object isKindOfClass:[PCompanyVC class]]){
        PCompanyVC * vc = object;
        vc.obj = self.professionM;
        @weakify(self)
        vc.successBlock = ^(CompanyM * obj){
            @strongify(self)
            self.companyM = obj;
            self.gongSiLab.text = self.companyM.company;
        };
    }else if ([object isKindOfClass:[PPositionVC class]]){
        PPositionVC * vc = object;
        vc.obj = self.companyM;
        @weakify(self)
        vc.successBlock = ^(PositionM * obj){
            @strongify(self)
            self.positionM = obj;
            self.zhiYeLab.text = self.positionM.jobPost;
        };
    }else if ([object isKindOfClass:[PCallVC class]]){
        PCallVC * vc = object;
        vc.name1 = self.professionM.industry;
        vc.name2 = self.companyM.company;
        vc.name3 = self.positionM.jobPost;
    }
}


@end
