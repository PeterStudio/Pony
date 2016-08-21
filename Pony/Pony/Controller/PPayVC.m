//
//  PPayVC.m
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PPayVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PaySignM.h"
@interface PPayVC ()

@end

@implementation PPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)zhiFuBaoPay:(id)sender {
    NSString * title = @"小马过河充值";
    NSString * body = [NSString stringWithFormat:@"充值金额:%@元",self.sum];
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIMoneyCashSign parameters:@{@"subject":title,@"body":body,@"total":self.sum} success:^(NSDictionary * responseObject) {
        @strongify(self)
        PaySignM * model = [[PaySignM alloc] initWithDictionary:responseObject error:nil];
        if (model.orderwithsign) {
            [[AlipaySDK defaultService] payOrder:model.orderwithsign fromScheme:@"pony" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
            }];
        }
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
