//
//  PDealPasswordVC.m
//  Pony
//
//  Created by 杜文 on 16/7/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PDealPasswordVC.h"

@interface PDealPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *dealPswTF;
@property (weak, nonatomic) IBOutlet UITextField *sureDealPswTF;

@end

@implementation PDealPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sureBtnClicked:(id)sender {
    if ([self.dealPswTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
    
    if ([self.sureDealPswTF.text validBlank]) {
        [MBProgressHUD showError:@"请确认交易密码"];
        return;
    }
    
    if (![self.dealPswTF.text isEqualToString:self.sureDealPswTF.text]) {
        [MBProgressHUD showError:@"密码不一致"];
        return;
    }
    
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPISetBalancePassowrd parameters:@{@"chargepassword":self.dealPswTF.text} success:^(NSDictionary * responseObject) {
        @strongify(self)
        [MBProgressHUD showSuccess:@"设置成功！"];
        [USERMANAGER saveUserDealStatus:@"1"];
        [self.navigationController popViewControllerAnimated:YES];
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
