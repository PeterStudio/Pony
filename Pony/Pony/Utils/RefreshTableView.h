//
//  RefreshTableView.h
//  MaiYaDai
//
//  Created by Baby on 16/6/14.
//  Copyright © 2016年 maiya. All rights reserved.
//

#import "BaseTableView.h"
#import "MJRefresh.h"

@protocol RefreshTableViewDelegate <NSObject>

@optional
/**获取最新数据*/
- (void)loadNewData;
/**加载更多数据*/
- (void)loadMoreData;
@end

@interface RefreshTableView : BaseTableView
@property (nonatomic, weak) id<RefreshTableViewDelegate> refreshDelegate;
@end
