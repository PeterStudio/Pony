//
//  HRVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRVC.h"

#import "HRVM.h"

@interface HRVC ()
@property (nonatomic, strong) HRVM * hrVM;
@end

@implementation HRVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_hrVM, title);
}

- (IBAction)switchToPony:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                        object:PONY_SB];
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
