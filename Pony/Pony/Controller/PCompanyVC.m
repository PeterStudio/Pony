//
//  PCompanyVC.m
//  Pony
//
//  Created by 杜文 on 16/6/28.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PCompanyVC.h"

@interface PCompanyVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (strong,nonatomic) NSMutableArray  *dataList;
@property (strong,nonatomic) NSMutableArray  *searchList;
@end

@implementation PCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList=[[NSMutableArray alloc] init];
    for (NSInteger i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"%ld-FlyElephant",(long)i]];
    }
}

- (void)requestToService{
    [MBProgressHUD showMessage:nil toView:self.view];
    [APIHTTP wPost:kAPICompanySearch parameters:@{@"industry_id":@"1",@"pageSize":@"0",@"pageNum":@"10000"} success:^(NSArray * responseObject) {
        self.dataList = [NSMutableArray arrayWithArray:responseObject];
        [self.tableView reloadData];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    if (tableView==self.searchDisplayController.searchResultsTableView) {
        [cell.textLabel setText:self.searchList[indexPath.row]];
    }
    else{
        [cell.textLabel setText:self.dataList[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
    }else{
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索Begin");
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索End");
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    // 谓词的包含语法,之前文章介绍过http://www.cnblogs.com/xiaofeixiang/
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    return YES;
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
