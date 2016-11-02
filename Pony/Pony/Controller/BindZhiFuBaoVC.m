//
//  BindZhiFuBaoVC.m
//  Pony
//
//  Created by 杜文 on 16/9/8.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BindZhiFuBaoVC.h"
#import "GetMoneyFormPonyVC.h"

@interface BindZhiFuBaoVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *zhiFuBaoTF;

@end

@implementation BindZhiFuBaoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)submitBtnClicked:(id)sender {
    [self.view endEditing:YES];
    if ([self.nameTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入真是姓名"];
        return;
    }
    
    if ([self.zhiFuBaoTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入支付宝账号"];
        return;
    }
    
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPIAlipayBind parameters:@{@"alipayName":self.nameTF.text,@"alipayNo":self.zhiFuBaoTF.text,@"userId":self.userID?self.userID:@""} success:^(NSDictionary * responseObject) {
        @strongify(self)
        [MBProgressHUD showSuccess:@"绑定成功！"];
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Pony" bundle:[NSBundle mainBundle]];
        GetMoneyFormPonyVC * vc = [sb instantiateViewControllerWithIdentifier:@"GetMoneyFormPonyVC"];
        vc.bindAlipayM = self.searchBindAlipayM;
        vc.name = self.nameTF.text;
        vc.account = self.zhiFuBaoTF.text;
        [self.navigationController pushViewController:vc animated:YES];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
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
