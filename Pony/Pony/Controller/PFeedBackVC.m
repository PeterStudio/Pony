//
//  PFeedBackVC.m
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PFeedBackVC.h"

@interface PFeedBackVC ()

@end

@implementation PFeedBackVC

- (void)click_backBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
