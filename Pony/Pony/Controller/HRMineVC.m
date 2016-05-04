//
//  HRMineVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRMineVC.h"
#import "HRMineVM.h"

@interface HRMineVC ()
@property (nonatomic, strong) HRMineVM * hrMineVM;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation HRMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_hrMineVM, title);
}

- (IBAction)logoutBtnClicked:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                        object:USERLOGIC_SB];
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
