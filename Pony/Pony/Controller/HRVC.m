//
//  HRVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRVC.h"
#import "HRVM.h"
#import <JMessage/JMessage.h>
#import "SingleUserInfoM.h"
#import "HRCell.h"
#import "PonyHJNoticM.h"

@interface HRVC ()<HRCellDelegate>
@property (nonatomic, strong) HRVM * hrVM;

@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UIButton *listenBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray * dataSourceArr;
@property (strong, nonatomic) UserInfoM * uModel;
@end

@implementation HRVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTICE_SWITCH_VC object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.listenBtn.hidden) {
        if (!self.listenBtn.selected) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getXiaoMaNotic:) name:XIAOMA_CALL_NOTIC object:nil];
        }
    }
    [self singleUserInfo];
}

- (void)refrashUI{
    self.uModel = [USERMANAGER userInfoM];
    [self.headIV setImage:[UIImage imageNamed:_uModel.user_img]];
    self.nameLab.text = _uModel.user_phone;
    self.moneyLab.text = [NSString stringWithFormat:@"我的伯乐币:%@¥",_uModel.balance];
    if ([@"0" isEqualToString:_uModel.user_auth]) {
        self.statusLab.text = @"未认证";
    }else if ([@"1" isEqualToString:_uModel.user_auth]){
        self.statusLab.text = @"已认证";
    }else if ([@"2" isEqualToString:_uModel.user_auth]){
        self.statusLab.text = @"待审核";
    }else if ([@"3" isEqualToString:_uModel.user_auth]){
        self.statusLab.text = @"审核失败";
    }
    
    if ([@"1" isEqualToString:_uModel.user_auth]) {
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getXiaoMaNotic:) name:XIAOMA_CALL_NOTIC object:nil];
        self.listenBtn.hidden = NO;
    }else{
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
        self.listenBtn.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    self.dataSourceArr = [[NSMutableArray alloc] init];
    [self refrashUI];
//    [self singleUserInfo];
}

#pragma mark - private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_hrVM, title);
}

- (void)singleUserInfo{
    @weakify(self)
    [APIHTTP wwPost:kAPIGet parameters:@{@"userId":_uModel.user_id} success:^(NSDictionary * responseObject) {
        @strongify(self)
        SingleUserInfoM * m = [[SingleUserInfoM alloc] initWithDictionary:responseObject error:nil];
        [USERMANAGER saveUserAuth:m.userAuth];
        [self refrashUI];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
//        [MBProgressHUD hideHUD];
    }];
}

- (IBAction)switchToPony:(id)sender {
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [JMSGUser logout:^(id resultObject, NSError *error) {
        [MBProgressHUD hideHUD];
        @strongify(self)
        if (error == nil) {
            // 退出极光成功！
            [self loginJPush];
        }else{
            [MBProgressHUD showError:@"切换失败，请稍后再试" toView:self.view];
        }
    }];
}

/**登录小马极光帐号*/
- (void)loginJPush{
    NSString * jUsername = [USERMANAGER jPushUserName];
    NSString * jPassword = [USERMANAGER jPushPassword];
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [JMSGUser loginWithUsername:jUsername password:jPassword completionHandler:^(id resultObject, NSError *error) {
        @strongify(self)
        if (error == nil) {
            // 登录极光成功！
            [self setAlias:jUsername];
        }else{
            [MBProgressHUD hideHUD];
            NSString *alert = @"用户登录失败";
            if (error.code == JCHAT_ERROR_USER_NOT_EXIST) {
                alert = @"用户名不存在";
            } else if (error.code == JCHAT_ERROR_USER_WRONG_PASSWORD) {
                alert = @"密码错误！";
            } else if (error.code == JCHAT_ERROR_USER_PARAS_INVALID) {
                alert = @"用户名或者密码不合法！";
            }
            [MBProgressHUD showError:alert toView:self.view];
        }
    }];
}

/**设置alias*/
- (void)setAlias:(NSString *)_alias{
    @weakify(self)
    [JPUSHService setTags:nil alias:_alias fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
        @strongify(self)
        if (iResCode == 0) {
            [MBProgressHUD hideHUDForView:DWRootView animated:YES];
            [USERMANAGER changeToRole:XIAOMA];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC object:PONY_SB];
        }else{
            [self setAlias:_alias];
        }
    }];
}

#pragma mark - private

- (IBAction)authVC:(id)sender {
    if ([@"2" isEqualToString:_uModel.user_auth]) {
        [MBProgressHUD showError:@"您的资料待审核中，请稍候再试"];
    }else{
        [self performSegueWithIdentifier:@"HRAuthTVC" sender:nil];
    }
}

- (IBAction)listenTalkClicked:(id)sender {
    if (!self.listenBtn.selected) {
        [MBProgressHUD showMessage:nil];
        @weakify(self)
        [APIHTTP wwPost:kAPITalkListenTalk parameters:@{@"status":@"1"} success:^(NSDictionary * responseObject) {
            @strongify(self)
            self.listenBtn.selected = YES;
            [MBProgressHUD showSuccess:@"听单成功！"];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getXiaoMaNotic:) name:XIAOMA_CALL_NOTIC object:nil];
        } error:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } failure:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } completion:^{
            [MBProgressHUD hideHUD];
        }];
    }else{
        [MBProgressHUD showMessage:nil];
        @weakify(self)
        [APIHTTP wwPost:kAPITalkListenTalk parameters:@{@"status":@"0"} success:^(NSDictionary * responseObject) {
            @strongify(self)
            self.listenBtn.selected = NO;
            [MBProgressHUD showSuccess:@"取消听单成功！"];
            [self.dataSourceArr removeAllObjects];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:XIAOMA_CALL_NOTIC object:nil];
        } error:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } failure:^(NSError *err) {
            [MBProgressHUD showError:err.localizedDescription toView:self.view];
        } completion:^{
            [MBProgressHUD hideHUD];
        }];
    }
}

- (void)getXiaoMaNotic:(NSNotification *)noti{
    PonyHJNoticM * model = (PonyHJNoticM *)noti.object;
    if ([@"2" isEqualToString:model.mode]) {
        [self.dataSourceArr addObject:model];
        [self.tableView beginUpdates];
        NSArray *arrInsertRows = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.tableView insertRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(HRCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.delegate = self;
    cell.indx = indexPath;
    cell.entity = (PonyHJNoticM *)self.dataSourceArr[indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView dequeueReusableCellWithIdentifier:@"HRCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(HRCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self configureCell:cell atIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60.0f;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100.0f;
}

#pragma mark- HRCellDelegate

- (void)boleQDAction:(NSIndexPath *)_indx{
    PonyHJNoticM * model = (PonyHJNoticM *)self.dataSourceArr[_indx.row];
    [MBProgressHUD showMessage:nil];
    @weakify(self)
    [APIHTTP wwPost:kAPITalkGrabTalk parameters:@{@"virtualTalkid":model.virtualTalkid} success:^(NSDictionary * responseObject) {
        @strongify(self)
        [MBProgressHUD showSuccess:@"抢单成功！"];
        [self.dataSourceArr removeObjectAtIndex:_indx.row];
        [self.tableView beginUpdates];
        NSArray *arrInsertRows = [NSArray arrayWithObject:_indx];
        [self.tableView deleteRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationRight];
        [self.tableView endUpdates];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
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
