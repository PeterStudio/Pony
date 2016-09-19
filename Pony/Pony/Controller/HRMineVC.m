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
#import "SearchBindAlipayM.h"
#import "BindZhiFuBaoVC.h"
#import "GetMoneyFormPonyVC.h"
#import "BillVC.h"

@interface HRMineVC ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@property (weak, nonatomic) IBOutlet UILabel *todayCallNumLab;
@property (weak, nonatomic) IBOutlet UILabel *todayMoneyLab;


@property (nonatomic, strong) HRMineVM * hrMineVM;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (strong, nonatomic) UserInfoM * uModel;
@property (copy, nonatomic) NSString * money;
@end

@implementation HRMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.uModel = [USERMANAGER userInfoM];
    [self.headBtn setImage:[UIImage imageNamed:_uModel.user_img] forState:UIControlStateNormal];
    self.nameLab.text = _uModel.user_phone;

    [self refreshMoneyLab:_uModel.balance];
    [self getBoleMoney];
    [self getBoleStatics];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popToSelf:) name:@"PMineVC" object:nil];
}

- (void)popToSelf:(NSNotification *)notic{
    [self.navigationController popToViewController:self animated:YES];
}

- (void)refreshMoneyLab:(NSString *)_money{
    NSString *testString = [NSString stringWithFormat:@"我的伯乐币:%@伯乐币",_money];
    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, testAttriString.length - 9)];
    self.moneyLab.attributedText = testAttriString;
}

- (void)refreshGrapLab:(NSString *)_num{
    NSString *testString = [NSString stringWithFormat:@"今天抢单：%@单",_num];
    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, testAttriString.length - 6)];
    self.todayCallNumLab.attributedText = testAttriString;
}

- (void)refreshPayLab:(NSString *)_money{
    NSString *testString = [NSString stringWithFormat:@"今日流水：%@伯乐币",_money];
    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, testAttriString.length - 8)];
    self.todayMoneyLab.attributedText = testAttriString;
}

- (void)getBoleMoney{
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneyGet parameters:@{@"moneyUserId":_uModel.user_id} success:^(NSDictionary * responseObject) {
        @strongify(self)
        PMoneyM * model = [[PMoneyM alloc] initWithDictionary:responseObject error:nil];
        self.money = model.moneyBalance;
        [self refreshMoneyLab:model.moneyBalance];
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
        [self refreshGrapLab:model.bole_count];
        [self refreshPayLab:model.bole_consume];
//        self.todayCallNumLab.text = [NSString stringWithFormat:@"今天抢单：%@单",model.bole_count];
//        self.todayMoneyLab.text = [NSString stringWithFormat:@"今日流水：%@伯乐币",model.bole_consume];
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
    [MBProgressHUD showMessage:nil];
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [MBProgressHUD hideHUD];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.row) {
        // 提现
        [MBProgressHUD showMessage:nil];
        @weakify(self)
        [APIHTTP wwPost:kAPIAlipayInfo parameters:@{} success:^(NSDictionary * responseObject) {
            @strongify(self)
            SearchBindAlipayM * searchBindAlipayM = [[SearchBindAlipayM alloc] initWithDictionary:responseObject error:nil];
            if ([@"0" isEqualToString:searchBindAlipayM.alipaystatus]) {
                // 未绑定
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Pony" bundle:[NSBundle mainBundle]];
                BindZhiFuBaoVC * vc = [sb instantiateViewControllerWithIdentifier:@"BindZhiFuBaoVC"];
                vc.searchBindAlipayM = searchBindAlipayM;
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([@"1" isEqualToString:searchBindAlipayM.alipaystatus]){
                //  已绑定
                UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Pony" bundle:[NSBundle mainBundle]];
                GetMoneyFormPonyVC * vc = [sb instantiateViewControllerWithIdentifier:@"GetMoneyFormPonyVC"];
                vc.bindAlipayM = searchBindAlipayM;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } error:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } failure:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } completion:^{
            [MBProgressHUD hideHUD];
        }];
    }
    if (2 == indexPath.row) {
        // 账单查询
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"HR" bundle:[NSBundle mainBundle]];
        BillVC * vc = [sb instantiateViewControllerWithIdentifier:@"BillVC"];
        vc.myMoney = self.money?self.money:@"0.0";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
