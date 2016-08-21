//
//  PProfessionVC.m
//  Pony
//
//  Created by 杜文 on 16/6/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PProfessionVC.h"
#import "RefreshTableView.h"
#import "BaseCell.h"

static NSString * cellIdentifier = @"BaseCell";
@interface PProfessionVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSourceArray;
@end

@implementation PProfessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行业";
    self.dataSourceArray = [[NSMutableArray alloc] init];
    [self requestData];
}

- (void)requestData{
    [MBProgressHUD showMessage:nil toView:self.tableView];
    @weakify(self)
    [APIHTTP wwPost:kAPIIndustryGetlist parameters:@{@"pageSize":@"0",@"pageNum":@""} success:^(NSArray * responseObject) {
        @strongify(self)
        [self.dataSourceArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } error:^(NSError *err) {
        @strongify(self)
        [MBProgressHUD showError:err.localizedDescription toView:self.tableView];
    } failure:^(NSError *err) {
        @strongify(self)
        [MBProgressHUD showError:err.localizedDescription toView:self.tableView];
    } completion:^{
        [MBProgressHUD hideHUDForView:self.tableView];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(BaseCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfessionM * baseM = [[ProfessionM alloc] initWithDictionary:self.dataSourceArray[indexPath.row] error:nil];
    cell.name = baseM.industry;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfessionM * baseM = [[ProfessionM alloc] initWithDictionary:self.dataSourceArray[indexPath.row] error:nil];
    if (self.successBlock) {
        self.successBlock(baseM);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
