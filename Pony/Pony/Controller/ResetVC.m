//
//  ResetVC.m
//  Pony
//
//  Created by 杜文 on 16/5/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "ResetVC.h"
#import "ResetVM.h"

@interface ResetVC ()
@property (weak, nonatomic) IBOutlet UITextField *nPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *cPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (strong, nonatomic) ResetVM * resetVM;
@end

@implementation ResetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**确定*/
- (IBAction)sure:(id)sender {
    if (![_nPasswordTextField.text validLoginPassword]) {
        kMRCError(@"新密码输入有误");
        [_nPasswordTextField shake];
        return;
    }
    
    if (![_nPasswordTextField.text isEqualToString:_cPasswordTextField.text]) {
        kMRCError(@"确认密码输入有误");
        [_nPasswordTextField shake];
        return;
    }
    
    NSDictionary * parameters = @{@"userName":_userName,@"code":_code,@"userPassword":_nPasswordTextField.text};
    [MBProgressHUD showHUDAddedTo:DWRootView animated:YES];
    @weakify(self)
    [APIHTTP wPost:kAPIReset parameters:parameters success:^(id responseObject) {
        @strongify(self)
        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(NSError *err) {
        kMRCError(err.localizedDescription);
    } failure:^(NSError *err) {
        kMRCError(err.localizedDescription);
    } completion:^{
        [MBProgressHUD hideHUDForView:DWRootView animated:YES];
    }];
}

#pragma mark - Private

- (void)bindViewModel{
    RAC(self.resetVM, nPsw) = [self.nPasswordTextField rac_textSignal];
    RAC(self.resetVM, cPsw) = [self.cPasswordTextField rac_textSignal];
    self.sureButton.rac_command = self.resetVM.sureCommand;
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