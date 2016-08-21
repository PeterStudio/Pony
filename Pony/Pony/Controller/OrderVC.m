//
//  OrderVC.m
//  Pony
//
//  Created by Baby on 16/5/13.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "OrderVC.h"
#import "MJRefresh.h"
#import "OrderCell.h"
#import "HROrderM.h"
#import "OrderDetailVC.h"

@interface OrderVC ()

@property (strong, nonatomic) NSMutableArray * dataSourceArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL      isPulling;
@property (assign, nonatomic) BOOL      hasMore;

@end

@implementation OrderVC

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
    [APIHTTP wwPost:kAPITalkGetlist parameters:@{@"pageNum": [NSString stringWithFormat:@"%ld",(long)page],@"pageSize": @"10",@"requestUserId": @"requestUserId"} success:^(NSArray * data) {
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
- (void)configureCell:(OrderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dic = self.dataSourceArray[indexPath.row];
    cell.entity = [[HROrderM alloc] initWithDictionary:dic error:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"OrderCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OrderCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = self.dataSourceArray[indexPath.row];
    HROrderM * model = [[HROrderM alloc] initWithDictionary:dic error:nil];
    [self performSegueWithIdentifier:@"OrderDetailVC" sender:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    id object = [segue destinationViewController];
    if ([object isKindOfClass:[OrderDetailVC class]]) {
        OrderDetailVC * vc = (OrderDetailVC *)object;
        vc.model = (HROrderM *)sender;
    }
}


@end
