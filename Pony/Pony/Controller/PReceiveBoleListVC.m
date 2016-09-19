//
//  PReceiveBoleListVC.m
//  Pony
//
//  Created by 杜文 on 16/8/9.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PReceiveBoleListVC.h"
#import "BoleQDNoticM.h"
#import "HRInfoVC.h"
#import "PReceiveBoleListCell.h"

@interface PReceiveBoleListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray * dataSourceArr;
@end

@implementation PReceiveBoleListVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BOLE_QIANGDAN_NOTIC object:nil];
}

- (void)click_backBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSourceArr = [[NSMutableArray alloc] init];
    [self.dataSourceArr addObject:self.entity];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBoleQDNotic:) name:BOLE_QIANGDAN_NOTIC object:nil];
}

- (void)getBoleQDNotic:(NSNotification *)noti{
    NSDictionary * dic = [self toArrayOrNSDictionary:[noti.object dataUsingEncoding:NSASCIIStringEncoding]];
    BoleQDNoticM * model = [[BoleQDNoticM alloc] initWithDictionary:dic error:nil];
    [self.dataSourceArr addObject:model];
    [self.tableView reloadData];
//    [self.tableView beginUpdates];
//    NSArray *arrInsertRows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [self.tableView insertRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationTop];
//    [self.tableView endUpdates];
}

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(PReceiveBoleListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.entity = (BoleQDNoticM *)self.dataSourceArr[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"PReceiveBoleListCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PReceiveBoleListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BoleQDNoticM * model = (BoleQDNoticM *)self.dataSourceArr[indexPath.row];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"HR" bundle:[NSBundle mainBundle]];
    HRInfoVC * vc = [sb instantiateViewControllerWithIdentifier:@"HRInfoVC"];
    vc.userId = model.userid;
    vc.isRepeatCall = YES;
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
