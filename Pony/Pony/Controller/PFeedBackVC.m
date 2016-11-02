//
//  PFeedBackVC.m
//  Pony
//
//  Created by 杜文 on 16/8/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PFeedBackVC.h"
#import "RatingBar.h"
#import "PublicCustomWebVC.h"


@interface PFeedBackVC ()<RatingBarDelegate>
@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *boleLab;
@property (strong,nonatomic) NSMutableArray * btnArr;
@property (copy, nonatomic) NSString * starNum;

@end

@implementation PFeedBackVC

- (void)click_backBarButtonItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem * helpItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"help"] style:UIBarButtonItemStylePlain target:self action:@selector(helAction)];
    helpItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    self.navigationItem.rightBarButtonItem = helpItem;
    
    [self addToolButton];

    self.startTimeLab.text = self.pEndTalkM.starttime;
    self.endTimeLab.text = self.pEndTalkM.endtime;
    self.timeLab.text = [NSString stringWithFormat:@"时长：%@",self.pEndTalkM.consume_time?self.pEndTalkM.consume_time:@"0分钟"];
    
    NSString *testString = [NSString stringWithFormat:@"%@伯乐币",self.pEndTalkM.consume?self.pEndTalkM.consume:@"0.0"];
    NSMutableAttributedString * testAttriString = [[NSMutableAttributedString alloc] initWithString:testString];
    [testAttriString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, testAttriString.length - 3)];
    self.boleLab.attributedText = testAttriString;
    
    [self.ratingBar setImageDeselected:@"star01_1" halfSelected:nil fullSelected:@"star01" andDelegate:self];
    [self.ratingBar displayRating:3.0];
    self.starNum = @"3";
    
    self.btnArr = [[NSMutableArray alloc] init];
    CGFloat w = (self.view.bounds.size.width - 50)/3.0;
    CGFloat h = 40.0f;
    for (int i = 0; i < self.pEndTalkM.commentStatistics.count; i++) {
        PCommentStatisticsM * cM = self.pEndTalkM.commentStatistics[i];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (10 + w)*(i%3), 80 + 15 + (15 + h)*(i/3), w, h)];
        NSString * t = [NSString stringWithFormat:@"%@",cM.comment_title];
        [btn setTitle:t forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"userLogic_btn_bg01"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"userLogic_btn_bg01_1"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(feedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 0.1f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.scrollerView addSubview:btn];
        [self.btnArr addObject:btn];
    }
    
    self.starHeightConstraint.constant = 30 + 15 + (15 + h)*(self.pEndTalkM.commentStatistics.count/3);
}

- (void)feedBtnClicked:(UIButton *)_btn{
    _btn.selected = !_btn.selected;
}

- (void)addToolButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setExclusiveTouch:YES];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [btn setBackgroundColor:[UIColor colorWithRed:21/255.f green:118/255.f blue:182/255.f alpha:1]];
    [btn addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
    UIBarButtonItem *offerbuyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setToolbarItems:@[leftBarButtonItem, offerbuyButtonItem, rightBarButtonItem]];
    self.navigationController.toolbarHidden = NO;
}

- (void)clickSureButton{
    [MBProgressHUD showMessage:nil];
    NSString * str = @"";
    for (int i = 0; i < self.btnArr.count; i++) {
        UIButton * btn = (UIButton *)self.btnArr[i];
        if (btn.selected) {
            PCommentStatisticsM * cM = self.pEndTalkM.commentStatistics[i];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"$%@",cM.comment_title]];
        }
    }
    if (![str validBlank]) {
        str = [str stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    }
    @weakify(self)
    [APIHTTP wwPost:kAPICommentsSave parameters:@{@"commentScore":self.starNum,@"commentTalkId":self.pEndTalkM.talk_id,@"commentTitle":str,@"commentUserTo":self.boleId} success:^(NSDictionary * responseObject) {
        @strongify(self)
        [MBProgressHUD showSuccess:@"评价成功" toView:self.view];
        [self performSelector:@selector(click_backBarButtonItem) withObject:nil afterDelay:3];
//        [self.navigationController popToRootViewControllerAnimated:YES];
    } error:^(NSError *err) {
        [MBProgressHUD showError:@"评价失败" toView:self.view];
//        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)helAction{
    PublicCustomWebVC * webVC = [[PublicCustomWebVC alloc] init];
    webVC.docUrl = @"http://cdn.xiaomahome.com/protocrol/评价标准.html";
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - RatingBarDelegate

- (void)ratingChanged:(float)newRating{
    self.starNum = [NSString stringWithFormat:@"%d",(int)newRating];
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
