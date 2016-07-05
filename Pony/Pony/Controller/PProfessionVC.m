//
//  PProfessionVC.m
//  Pony
//
//  Created by 杜文 on 16/6/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PProfessionVC.h"
#import "RefreshTableView.h"
#import "ProfessionLM.h"
#import "BaseCell.h"

static NSString * cellIdentifier = @"BaseCell";
@interface PProfessionVC ()<RefreshTableViewDelegate>

@property (weak, nonatomic) IBOutlet RefreshTableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSourceArray;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) BOOL      isPulling;
@property (assign, nonatomic) BOOL      hasMore;
@end

@implementation PProfessionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行业";
    self.page = 0;
    self.isPulling = YES;
    self.hasMore = YES;
    self.dataSourceArray = [[NSMutableArray alloc] init];
    self.tableView.refreshDelegate = self;
    [self loadNewData];
}

- (void)requestDataWithPage:(NSInteger)page{
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wPost:kAPIIndustryGetlist parameters:@{@"pageSize":[NSString stringWithFormat:@"%ld",page],@"pageNum":@"10"} success:^(NSArray * responseObject) {
        @strongify(self)
        _isPulling?[self.tableView.mj_header endRefreshing]:[self.tableView.mj_footer endRefreshing];
        if (_isPulling) {
            [self.dataSourceArray removeAllObjects];
        }
        if (responseObject.count < 10) {
            self.hasMore = NO;
        }else{
            self.hasMore = YES;
        }
        [self.dataSourceArray addObjectsFromArray:responseObject];
        if (self.dataSourceArray.count > 0) {
            [self.tableView reloadData];
        }
    } error:^(NSError *err) {
        @strongify(self)
        _isPulling?[self.tableView.mj_header endRefreshing]:[self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        @strongify(self)
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
        _isPulling?[self.tableView.mj_header endRefreshing]:[self.tableView.mj_footer endRefreshing];
    } completion:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - RefreshTableViewDelegate

- (void)loadNewData{
    self.isPulling = YES;
    self.page = 0;
    [self requestDataWithPage:self.page];
}

- (void)loadMoreData{
    if (self.hasMore) {
        [self requestDataWithPage:++self.page];
        self.isPulling = NO;
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return [tableView fd_heightForCellWithIdentifier:cellIdentifier configuration:^(UITableViewCell *cell) {
//        [self configureCell:cell atIndexPath:indexPath];
//    }];
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    XXDFoundModel * foundModel = (XXDFoundModel *)self.dataSourceArray[indexPath.row];
//    if ([@"1" isEqualToString:foundModel.clickable]) {
//        XXDCustomWebVC * webVC = [[XXDCustomWebVC alloc] init];
//        webVC.docTitle = @"发现详情";
//        webVC.docUrl = foundModel.activityUrl;
//        [self.navigationController pushViewController:webVC animated:YES];
//    }
//}



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
