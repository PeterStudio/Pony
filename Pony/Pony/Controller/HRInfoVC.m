//
//  HRInfoVC.m
//  Pony
//
//  Created by 杜文 on 16/8/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRInfoVC.h"
#import "HRInfoM.h"
#import "JCHATConversationViewController.h"
#import "PAddTalkM.h"

@interface HRInfoVC ()

@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *workLab;
@property (weak, nonatomic) IBOutlet UILabel *hangYeLab;
@property (weak, nonatomic) IBOutlet UILabel *companyLab;
@property (weak, nonatomic) IBOutlet UILabel *positionLab;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *startArray;
@property (nonatomic, strong) HRInfoM * hrInfoM;
@property (nonatomic, strong) PAddTalkM * pAddTalkM;
@end

@implementation HRInfoVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.toolbarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self.tableView reloadData];
    
    if (!self.isRepeatCall) {
        return;
    }
    
    if ([@"1" isEqualToString:self.hrInfoM.bolestatus]) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setExclusiveTouch:YES];
        [btn setTitle:@"开始咨询" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        [btn setBackgroundColor:[UIColor colorWithRed:21/255.f green:118/255.f blue:182/255.f alpha:1]];
        [btn addTarget:self action:@selector(addTalk) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        UIBarButtonItem *offerbuyButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [self setToolbarItems:@[leftBarButtonItem, offerbuyButtonItem, rightBarButtonItem]];
        self.navigationController.toolbarHidden = NO;
    }else{
        self.navigationController.toolbarHidden = YES;
    }
}

- (void)requestToService{
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wwPost:kAPIGetBoleDetail parameters:@{@"userId": self.userId} success:^(NSDictionary * data) {
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

- (void)addTalk{
    [MBProgressHUD showMessage:nil toView:self.view];
    @weakify(self)
    [APIHTTP wwPost:kAPIAddTalk parameters:@{@"bole_userid": self.userId} success:^(NSDictionary * data) {
        @strongify(self)
        self.pAddTalkM = [[PAddTalkM alloc] initWithDictionary:data error:nil];
        [self callBole];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        @strongify(self)
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)callBole{
    HRBoleDetailM * boleDetailM = self.hrInfoM.boledetail;
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];//!!
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:boleDetailM.jpush_bole_id completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                sendMessageCtl.pTalkM = strongSelf.pAddTalkM;
                sendMessageCtl.bole_ID = strongSelf.userId;
                sendMessageCtl.isShowInputView = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            DDLogDebug(@"createSingleConversationWithUsername");
        }
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger num = self.hrInfoM.commentStatistics.count / 3 + 1;
    return self.hrInfoM.commentStatistics.count>0?(num * 40.0f + 30.0f + 25.0f) : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 150)];
    
    UILabel * infoLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 15)];
    [infoLab setText:@"用户评价"];
    [infoLab setTextColor:[UIColor blackColor]];
    [infoLab setFont:[UIFont systemFontOfSize:15.0f]];
    [infoLab setBackgroundColor:[UIColor clearColor]];
    [v addSubview:infoLab];
    
    CGFloat w = (self.tableView.bounds.size.width - 50)/3.0;
    CGFloat h = 40.0f;
    
    for (int i = 0; i < self.hrInfoM.commentStatistics.count; i++) {
        HRCommentStatisticsM * cM = self.hrInfoM.commentStatistics[i];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(15 + (10 + w)*(i%3), 25 + 15 + (15 + w)*(i/3), w, h)];
        NSString * t = [NSString stringWithFormat:@"%@(%@)",cM.comment_title,cM.comment_count];
        [btn setTitle:t forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 2;
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor darkGrayColor].CGColor;
        [v addSubview:btn];
    }
    
    return v;
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
