//
//  RefreshTableView.m
//  MaiYaDai
//
//  Created by Baby on 16/6/14.
//  Copyright © 2016年 maiya. All rights reserved.
//

#import "RefreshTableView.h"
#import "MJRefresh.h"

@implementation RefreshTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configRefreshTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configRefreshTableView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configRefreshTableView];
    }
    return self;
}

- (void)configRefreshTableView{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticeNew)];
    
    // Enter the refresh status immediately
//    [self.header beginRefreshing];
    
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(noticeNew)];
//    // 设置普通状态的动画图片
//    [header setImages:@[[UIImage imageNamed:@"Refresh1"]] forState:MJRefreshStateIdle];
//    
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    NSMutableArray *refreshingImages = [NSMutableArray array];
//    for (NSUInteger i = 1; i<=3; i++) {
//        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Refresh%zd", i]];
//        [refreshingImages addObject:image];
//    }
//    [header setImages:refreshingImages forState:MJRefreshStatePulling];
//    
//    // 设置正在刷新状态的动画图片
//    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
//    
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
//    // Set header
//    self.header = header;
    
//    // 上拉加载
//    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeMore)];
//    // 设置刷新图片
//    //    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
////    [footer setTitle:@"" forState:MJRefreshStateIdle];
//    // 设置尾部
//    self.footer = footer;
    
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(noticeMore)];
}

/**
 *  刷新数据
 */
- (void)noticeNew{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(loadNewData)]) {
        [self.refreshDelegate loadNewData];
    }
}

/**
 *  加载更多
 */
- (void)noticeMore{
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(loadMoreData)]) {
        [self.refreshDelegate loadMoreData];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
