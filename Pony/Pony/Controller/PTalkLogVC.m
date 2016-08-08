//
//  PTalkLogVC.m
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PTalkLogVC.h"
#import "MJRefresh.h"
#import "PTalkLogCell.h"
#import "PTalkLogM.h"
#import "HRInfoVC.h"

@interface PTalkLogVC ()<PTalkLogCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (strong, nonatomic) NSMutableArray * dataSourceArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL      isPulling;
@property (assign, nonatomic) BOOL      hasMore;
@end

@implementation PTalkLogVC

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
    [APIHTTP wPost:kAPITalkGetlist parameters:@{@"pageNum": [NSString stringWithFormat:@"%ld",(long)page],@"pageSize": @"10",@"requestUserId": @"requestUserId"} success:^(NSArray * data) {
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
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        @strongify(self)
        self.isPulling?[self.tableView.mj_header endRefreshing]:[self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - UITableViewDataSource
- (void)configureCell:(PTalkLogCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.dataSourceArray[indexPath.row];
    cell.delegate = self;
    cell.indx = indexPath;
    cell.entity = [[PTalkLogM alloc] initWithDictionary:dic error:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"PTalkLogCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PTalkLogCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.dataSourceArray.count > 0) {
        return self.headView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

#pragma mark - PTalkLogCellDelegate

- (void)showBoleDetailWithIndx:(NSIndexPath *)_indx{
    NSDictionary * dic = self.dataSourceArray[_indx.row];
    PTalkLogM * model = [[PTalkLogM alloc] initWithDictionary:dic error:nil];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"HR" bundle:[NSBundle mainBundle]];
    HRInfoVC * vc = [sb instantiateViewControllerWithIdentifier:@"HRInfoVC"];
    vc.userId = model.reponse_user_id;
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
