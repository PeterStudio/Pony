//
//  HRMineVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRMineVC.h"
#import "HRMineVM.h"
#import "PMoneyM.h"
#import "TodayBoleStaticsM.h"

@interface HRMineVC ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (weak, nonatomic) IBOutlet UILabel *todayCallNumLab;
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLab;


@property (nonatomic, strong) HRMineVM * hrMineVM;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (strong, nonatomic) UserInfoM * uModel;
@end

@implementation HRMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.uModel = [USERMANAGER userInfoM];
    [self.headBtn setImage:[UIImage imageNamed:_uModel.user_img] forState:UIControlStateNormal];
    self.nameLab.text = _uModel.user_phone;
    self.moneyLab.text = [NSString stringWithFormat:@"我的伯乐币:%@¥",_uModel.balance];
    
    [self getBoleMoney];
    [self getBoleStatics];
}

- (void)getBoleMoney{
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneyGet parameters:@{@"moneyUserId":_uModel.user_id} success:^(NSDictionary * responseObject) {
        @strongify(self)
        PMoneyM * model = [[PMoneyM alloc] initWithDictionary:responseObject error:nil];
        self.moneyLab.text = [NSString stringWithFormat:@"我的伯乐币:%@¥",model.moneyBalance];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

- (void)getBoleStatics{
    @weakify(self)
    [APIHTTP wwPost:kAPIGetBoleStatics parameters:@{} success:^(NSDictionary * responseObject) {
        @strongify(self)
        TodayBoleStaticsM * model = [[TodayBoleStaticsM alloc] initWithDictionary:responseObject error:nil];
        self.todayCallNumLab.text = [NSString stringWithFormat:@"今天抢单：%@单",model.bole_count];
        self.todayMoneyLab.text = [NSString stringWithFormat:@"今日流水：%@¥",model.bole_consume];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

#pragma mark - Private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_hrMineVM, title);
}

- (IBAction)logoutBtnClicked:(id)sender {
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [USERMANAGER logout];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                            object:USERLOGIC_SB];
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 18;
    }else{
        return 1;
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
