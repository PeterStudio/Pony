//
//  HRInfoVC.m
//  Pony
//
//  Created by 杜文 on 16/8/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRInfoVC.h"
#import "HRInfoM.h"

@interface HRInfoVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *workLab;
@property (weak, nonatomic) IBOutlet UILabel *hangYeLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *startArray;
@property (nonatomic, strong) HRInfoM * hrInfoM;
@end

@implementation HRInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setHidden:YES];
    [self requestToService];
}

- (void)refrashUI{
    [self.tableView setHidden:NO];
    HRBoleDetailM * boleDetailM = self.hrInfoM.boledetail;
    [self.headIV setImage:[UIImage imageNamed:boleDetailM.user_img]];
    self.nameLab.text = boleDetailM.user_nickname;
    self.workLab.text = boleDetailM.job_year;
    self.hangYeLab.text = boleDetailM.industry;
    self.companyLab.text = boleDetailM.company;
    self.positionLab.text = boleDetailM.job_post;
    
    for (int i = 0; i < [boleDetailM.user_level integerValue]; i++) {
        UIButton * btn = (UIButton *)self.startArray[i];
        [btn setSelected:YES];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setExclusiveTouch:YES];
    [btn setTitle:@"开始咨询" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [btn setBackgroundColor:[UIColor blueColor]];
    
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    UIBarButtonItem *offerbuyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[leftBarButtonItem, offerbuyButtonItem, rightBarButtonItem]];
    
}

- (void)requestToService{
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wPost:kAPIGetBoleDetail parameters:@{@"userId": self.userId} success:^(NSDictionary * data) {
        @strongify(self)
        self.hrInfoM = [[HRInfoM alloc] initWithDictionary:data error:nil];
        [self refrashUI];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view];
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
