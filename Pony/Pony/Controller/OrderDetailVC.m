//
//  OrderDetailVC.m
//  Pony
//
//  Created by 杜文 on 16/8/1.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "OrderDetailVC.h"

@interface OrderDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@end

@implementation OrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startTimeLab.text = self.model.talk_start_time;
    self.endTimeLab.text = self.model.talk_end_time;
    self.moneyLab.text = self.model.talk_fee;
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
