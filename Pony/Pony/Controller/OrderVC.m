//
//  OrderVC.m
//  Pony
//
//  Created by Baby on 16/5/13.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "OrderVC.h"

@interface OrderVC ()


@end

@implementation OrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wPost:kAPITalkGetlist parameters:@{} success:^(NSDictionary * responseObject) {
        @strongify(self)
//        PMoneyM * model = [[PMoneyM alloc] initWithDictionary:responseObject error:nil];
//        self.moneyLab.text = [NSString stringWithFormat:@"我的伯乐币:%@¥",model.moneyBalance];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];

    
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
