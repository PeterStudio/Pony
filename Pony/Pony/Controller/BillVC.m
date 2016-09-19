//
//  BillVC.m
//  Pony
//
//  Created by Baby on 16/5/13.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BillVC.h"

@interface BillVC ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeftConstraint;


@end

@implementation BillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *testString = [NSString stringWithFormat:@"我的钱包:%@伯乐币",self.myMoney];
//    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
//    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4, testAttriString.length - 3)];
//    self.moneyLab.attributedText = testAttriString;
    self.moneyLab.text = testString;
}

- (IBAction)changeBtnClicked:(UIButton *)sender {
    if (sender == self.leftBtn) {
        self.lineLeftConstraint.constant = 12.0f;
        self.rightBtn.selected = NO;
    }else{
        self.lineLeftConstraint.constant = 12.0f + 50.0f;
        self.leftBtn.selected = NO;
    }
    sender.selected = YES;
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"收入明细";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"BillCell" forIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
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
