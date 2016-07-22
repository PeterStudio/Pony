//
//  PCallVC.m
//  Pony
//
//  Created by 杜文 on 16/7/6.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PCallVC.h"

@interface PCallVC ()
@property (weak, nonatomic) IBOutlet UILabel *professonLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end

@implementation PCallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.professonLab.text = _name1;
    self.companyLab.text = _name2?_name2:@"公司";
    self.positionLab.text = _name3?_name3:@"职位";
    [self requestToService];
}

- (void)requestToService{
    NSString * obj1 = [@"不限" isEqualToString:_name1]?@"":_name1;
    NSString * obj2 = [@"不限" isEqualToString:_name2]?@"":_name2;
    NSString * obj3 = [@"不限" isEqualToString:_name3]?@"":_name3;
    NSDictionary * dic = @{@"industry":obj1,@"company":obj2,@"jobPost":obj3};
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wPost:kAPIUserjobsSearch parameters:dic success:^(NSArray * responseObject) {
        @strongify(self)
        [self startCountTime];
    } error:^(NSError *err) {
        @strongify(self)
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        @strongify(self)
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)startCountTime{
    __block int timeout = 10 * 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
//            dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            int minutes = timeout / 60;
            int seconds = timeout % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeLab.text = [NSString stringWithFormat:@"%.2d:%.2d",minutes,seconds];
            });
            timeout--;
        }  
    });  
    dispatch_resume(_timer);
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
