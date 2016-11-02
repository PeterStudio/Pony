//
//  HRAboutMeVC.m
//  Pony
//
//  Created by 杜文 on 16/9/20.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRAboutMeVC.h"
#import "HRInfoM.h"
#import "HRInfoVC.h"

@interface HRAboutMeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;
@end

@implementation HRAboutMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self requestToService];
}

- (void)requestToService{
    UserInfoM * uModel = [USERMANAGER userInfoM];
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wwPost:kAPIGetBoleDetail parameters:@{@"userId": uModel.user_id} success:^(NSDictionary * data) {
        @strongify(self)
        HRInfoM * hrInfoM = [[HRInfoM alloc] initWithDictionary:data error:nil];
        HRBoleDetailM * bD = hrInfoM.boledetail;
        self.headIV.image = [UIImage imageNamed:bD.user_img];
        self.nameLab.text = bD.user_nickname;
        self.positionLab.text = [NSString stringWithFormat:@"%@ %@",bD.company,bD.job_post];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (IBAction)myStar:(id)sender {
    UserInfoM * uModel = [USERMANAGER userInfoM];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"HR" bundle:[NSBundle mainBundle]];
    HRInfoVC * vc = [sb instantiateViewControllerWithIdentifier:@"HRInfoVC"];
    vc.userId = uModel.user_id;
    vc.isRepeatCall = NO;
    vc.title = @"我的星级";
    [self.navigationController pushViewController:vc animated:YES];
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
