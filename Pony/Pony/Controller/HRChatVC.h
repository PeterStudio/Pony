//
//  HRChatVC.h
//  Pony
//
//  Created by 杜文 on 16/5/3.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseTableViewController.h"
#import "JCHATChatTable.h"
@interface HRChatVC : BaseTableViewController<UISearchBarDelegate,UISearchControllerDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,TouchTableViewDelegate,UIGestureRecognizerDelegate,JMessageDelegate,JMSGConversationDelegate>
@property (weak, nonatomic) IBOutlet JCHATChatTable *chatTableView;
@end
