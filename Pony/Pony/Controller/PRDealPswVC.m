//
//  PRDealPswVC.m
//  Pony
//
//  Created by 杜文 on 16/8/1.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PRDealPswVC.h"

@interface PRDealPswVC ()
@property (weak, nonatomic) IBOutlet UITextField *dealTF1;
@property (weak, nonatomic) IBOutlet UITextField *dealTF2;
@property (weak, nonatomic) IBOutlet UITextField *dealTF3;

@end

@implementation PRDealPswVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)sureBtnClicked:(id)sender {
    if ([self.dealTF1.text validBlank]) {
        [MBProgressHUD showError:@"请输入原交易密码"];
        return;
    }
    
    if ([self.dealTF2.text validBlank]) {
        [MBProgressHUD showError:@"请输入交易密码"];
        return;
    }
    
    if (![self.dealTF2.text isEqualToString:self.dealTF3.text]) {
        [MBProgressHUD showError:@"请确认交易密码"];
        return;
    }
    
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIResetBalancePassowrd parameters:@{@"oldpassword":self.dealTF1.text,@"newpassword":self.dealTF2.text} success:^(NSDictionary * responseObject) {
        @strongify(self)
        [MBProgressHUD showSuccess:@"重置交易密码成功！"];
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
