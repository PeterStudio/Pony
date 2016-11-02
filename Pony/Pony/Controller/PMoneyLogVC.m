//
//  PMoneyLogVC.m
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PMoneyLogVC.h"
#import "PMoneyLogM.h"
#import "MJRefresh.h"
#import "PMoneyLogCell.h"

@interface PMoneyLogVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSourceArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL      isPulling;
@property (assign, nonatomic) BOOL      hasMore;
@end

@implementation PMoneyLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.isPulling = YES;
    self.hasMore = YES;
    self.dataSourceArray = [[NSMutableArray alloc] init];
    
    @weakify(self)
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self)
        self.isPulling = YES;
        self.page = 1;
        self.hasMore = YES;
        self.tableView.mj_footer.state = MJRefreshStateIdle;
        [self requestDataWithPage:self.page];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        if (self.hasMore) {
            [self requestDataWithPage:++self.page];
            self.isPulling = NO;
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestDataWithPage:(NSInteger)page{
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneylogGetlist parameters:@{@"logType": @"0",@"moneyToUser": self.moneyUserId,@"pageNum": [NSString stringWithFormat:@"%ld",(long)page],@"pageSize": @"10"} success:^(NSArray * data) {
        @strongify(self)
        if (_isPulling) {
            [self.dataSourceArray removeAllObjects];
        }
        if (data.count < 10) {
            self.hasMore = NO;
        }else{
            self.hasMore = YES;
        }
        [self.dataSourceArray addObjectsFromArray:data];
        [self.tableView reloadData];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        @strongify(self)
         self.isPulling?[self.tableView.mj_header endRefreshing]:[self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


#pragma mark - UITableViewDataSource
- (void)configureCell:(PMoneyLogCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.dataSourceArray[indexPath.row];
    cell.entity = [[PMoneyLogM alloc] initWithDictionary:dic error:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"PMoneyLogCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PMoneyLogCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
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
