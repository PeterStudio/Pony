//
//  ForgetVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "ForgetVC.h"

@interface ForgetVC ()
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (strong, nonatomic) IBOutlet UIView *footerView;
@end

@implementation ForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
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
