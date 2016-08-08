//
//  HRChatVC.m
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRChatVC.h"
#import "HRChatVM.h"

#import "JCHATConversationListCell.h"
#import "JCHATConversationViewController.h"
#import "JCHATSelectFriendsCtl.h"
#import "MBProgressHUD+LangExt.h"
#import "JCHATAlertViewWait.h"
#import "AppDelegate.h"

#define kHRBackBtnFrame CGRectMake(0, 0, 50, 30)
#define kHRBubbleBtnColor UIColorFromRGB(0x4880d7)

@interface HRChatVC ()
{
    __block NSMutableArray *_conversationArr;
    UIButton *_rightBarButton;
    NSInteger _unreadCount;
    UILabel *_titleLabel;
}
@property (nonatomic, strong) HRChatVM * hrChatVM;
@end

@implementation HRChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDLogDebug(@"Action - viewDidLoad");
    
    [self addNotifications];
    [self setupChatTable];
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (!appDelegate.isDBMigrating) {
        [self addDelegate];
    } else {
        NSLog(@"is DBMigrating don't get allconversations");
        [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
    }
    
}

#pragma mark - Private

- (void)bindViewModel{
    RAC(self, title) = RACObserve(_hrChatVM, title);
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJPFNetworkDidSetupNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnecting)
                                                 name:kJPFNetworkIsConnectingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dBMigrateFinish)
                                                 name:kDBMigrateFinishNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alreadyLoginClick)
                                                 name:kLogin_NotifiCation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creatGroupSuccessToPushView:)
                                                 name:kCreatGroupState
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skipToSingleChatView:)
                                                 name:kSkipToSingleChatViewState
                                               object:nil];
}

- (void)setupChatTable {
    [_chatTableView setBackgroundColor:[UIColor whiteColor]];
    _chatTableView.dataSource=self;
    _chatTableView.delegate=self;
    _chatTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _chatTableView.touchDelegate = self;
    
    [_chatTableView registerNib:[UINib nibWithNibName:@"JCHATConversationListCell" bundle:nil] forCellReuseIdentifier:@"JCHATConversationListCell"];
}

- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}

- (void)skipToSingleChatView :(NSNotification *)notification {
    JMSGUser *user = [[notification object] copy];
    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];//!!
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:user.username completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            DDLogDebug(@"createSingleConversationWithUsername");
        }
    }];
}

- (void)dBMigrateFinish {
    NSLog(@"Migrate is finish  and get allconversation");
    JCHATMAINTHREAD(^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    [self addDelegate];
    [self getConversationList];
}

- (JMSGConversation *)getConversationWithTargetId:(NSString *)targetId {
    for (NSInteger i=0; i< [_conversationArr count]; i++) {
        JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
        
        if (conversation.conversationType == kJMSGConversationTypeSingle) {
            if ([((JMSGUser *)conversation.target).username isEqualToString:targetId]) {
                return conversation;
            }
        } else {
            if ([((JMSGGroup *)conversation.target).gid isEqualToString:targetId]) {
                return conversation;
            }
        }
    }
    DDLogDebug(@"Action getConversationWithTargetId  fail to meet conversation");
    return nil;
}

- (void)reloadConversationInfo:(JMSGConversation *)conversation {
    DDLogDebug(@"Action - creatGroupSuccessToPushView - %@", conversation);
    for (NSInteger i=0; i<[_conversationArr count]; i++) {
        JMSGConversation *conversationObject = [_conversationArr objectAtIndex:i];
        if ([conversationObject.target isEqualToConversation:conversation.target]) {
            [_conversationArr removeObjectAtIndex:i];
            [_conversationArr insertObject:conversation atIndex:i];
            [_chatTableView reloadData];
            return;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getConversationList];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    }
}

- (void)netWorkConnectClose {
    DDLogDebug(@"Action - netWorkConnectClose");
    _titleLabel.text =@"未连接";
}

- (void)netWorkConnectSetup {
    DDLogDebug(@"Action - netWorkConnectSetup");
    _titleLabel.text =@"收取中...";
}

- (void)connectSucceed {
    DDLogDebug(@"Action - connectSucceed");
    _titleLabel.text =@"会话";
}

- (void)isConnecting {
    DDLogDebug(@"Action - isConnecting");
    _titleLabel.text =@"连接中...";
}


#pragma mark JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    DDLogDebug(@"Action -- onReceivemessage %@",message);
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    DDLogDebug(@"Action -- onConversationChanged");
    [self getConversationList];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    DDLogDebug(@"Action -- onGroupInfoChanged");
    [self getConversationList];
}

- (void)viewDidAppear:(BOOL)animated {
    DDLogDebug(@"Action - viewDidAppear");
    [super viewDidAppear:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    DDLogDebug(@"Action - viewDidDisappear");
    [super viewDidDisappear:YES];
}

- (void)getConversationList {
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        JCHATMAINTHREAD(^{
            if (error == nil) {
                _conversationArr = [self sortConversation:resultObject];
                _unreadCount = 0;
                for (NSInteger i=0; i < [_conversationArr count]; i++) {
                    JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
                    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
                }
                [self saveBadge:_unreadCount];
            } else {
                _conversationArr = nil;
            }
            [self.chatTableView reloadData];
        });
    }];
}

NSInteger sortHRType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortHRType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

- (void)alreadyLoginClick {
    [self getConversationList];
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    _rightBarButton.selected=NO;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DDLogDebug(@"Action - tableView");
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username];
    } else {
        [JMSGConversation deleteGroupConversationWithGroupId:((JMSGGroup *)conversation.target).gid];
    }
    
    [_conversationArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_conversationArr count] > 0) {
        return [_conversationArr count];
    } else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JCHATConversationListCell";
    JCHATConversationListCell *cell = (JCHATConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell setCellDataWithConversation:conversation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

#pragma mark - SearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)_searchBar {
    
}

//响应点击索引时的委托方法
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_conversationArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    sendMessageCtl.superViewController = self;
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    sendMessageCtl.conversation = conversation;
    [self.navigationController pushViewController:sendMessageCtl animated:YES];
    
    NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
    [self saveBadge:badge];
}

- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Via Jack Lucky
- (void)searchBarCancelButtonClicked:(UISearchBar *)_searchBar {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
}

@end
