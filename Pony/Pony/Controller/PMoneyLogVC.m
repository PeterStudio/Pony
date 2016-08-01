//
//  PMoneyLogVC.m
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PMoneyLogVC.h"

@interface PMoneyLogVC ()

@end

@implementation PMoneyLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wPost:kAPIMongeylogGetlist parameters:@{} success:^(NSDictionary * responseObject) {
        @strongify(self)
       
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
