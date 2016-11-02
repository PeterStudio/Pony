//
//  BillVC.m
//  Pony
//
//  Created by Baby on 16/5/13.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BillVC.h"
#import "BillCell.h"

@interface BillVC ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;
@property (strong, nonatomic) NSMutableArray * dataSourceArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *testString = [NSString stringWithFormat:@"我的钱包:%@伯乐币",self.myMoney];
//    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
//    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, testAttriString.length - 3)];
//    self.moneyLab.attributedText = testAttriString;
    self.moneyLab.text = testString;
    
    // 提现
    [self reloadData:@"2"];
}

- (void)reloadData:(NSString *)_type{
    UserInfoM * uModel = [USERMANAGER userInfoM];
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneylogGetlist parameters:@{@"logType":_type,@"moneyFromUser":uModel.user_id,@"pageNum":@"1",@"pageSize":@"10"} success:^(NSArray * responseObject) {
        @strongify(self)
        self.dataSourceArr = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView reloadData];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (IBAction)changeBtnClicked:(UIButton *)sender {
    if (sender == self.leftBtn) {
        // 提现
        [self reloadData:@"2"];
        self.lineLeftConstraint.constant = 12.0f;
        self.rightBtn.selected = NO;
    }else{
        // 收入
        [self reloadData:@"1"];
        self.lineLeftConstraint.constant = 12.0f + 50.0f;
        self.leftBtn.selected = NO;
    }
    sender.selected = YES;
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(BillCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.dataSourceArr[indexPath.row];
    cell.entity = [[BillM alloc] initWithDictionary:dic error:nil];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"收入明细";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BillCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
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
