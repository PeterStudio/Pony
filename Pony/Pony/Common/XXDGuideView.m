//
//  XXDGuideView.m
//  MaiYaDai
//
//  Created by Baby on 15/11/24.
//  Copyright © 2015年 maiya. All rights reserved.
//

#import "XXDGuideView.h"
#import "JChatConstants.h"
#import "Constant.h"

@interface XXDGuideView()<UIScrollViewDelegate>
@property (strong, nonatomic) NSArray * guideImgArr;
@end

@implementation XXDGuideView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createGuidePageView:frame];
    }
    return self;
}

- (void)createGuidePageView:(CGRect)frame{
    if (SCREEN_HEIGHT < 568.0f) {
        // 4、4s屏幕
        self.guideImgArr = [NSArray arrayWithObjects:@"page1",@"page2",@"page3", nil];
    }else{
        self.guideImgArr = [NSArray arrayWithObjects:@"page1",@"page2",@"page3", nil];
    }
    //引导页
    UIScrollView *guideScroll = [[UIScrollView alloc] initWithFrame:frame];
    guideScroll.delegate = self;
    guideScroll.pagingEnabled = YES;
    guideScroll.showsHorizontalScrollIndicator = NO;
    guideScroll.contentSize = CGSizeMake(SCREEN_WIDTH * [self.guideImgArr count], SCREEN_HEIGHT);
    
    for (int i = 0; i < [self.guideImgArr count]; i++) {
        UIImageView *guideView = [[UIImageView alloc] init];
        guideView.userInteractionEnabled = YES;
        guideView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        guideView.image = [UIImage imageNamed:[self.guideImgArr objectAtIndex:i]];
        if (i + 1 == [self.guideImgArr count]) {
            //添加立刻体验按钮
            UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            enterButton.backgroundColor = [UIColor clearColor];
            enterButton.frame = guideView.bounds;
            [enterButton addTarget:self action:@selector(enterButtonPress) forControlEvents:UIControlEventTouchUpInside];
            [guideView addSubview:enterButton];
        }
        [guideScroll addSubview:guideView];
    }
    
    [self addSubview:guideScroll];
}

/**
 *  点击立刻体验按钮
 */
- (void)enterButtonPress
{
    [UIView animateWithDuration:0.75 animations:^{
        self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[NSUserDefaults standardUserDefaults] setInteger:VERSION_NUM_FOR_GUIDE forKey:VERSION_NUM_FOR_GUIDE_KEY];
        [self removeFromSuperview];
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    if (offset.x < 0 || offset.x > SCREEN_WIDTH*([self.guideImgArr count] -1)) {
        //左右最边缘禁止滑动
        scrollView.scrollEnabled = NO;
    }
    else
    {
        scrollView.scrollEnabled = YES;
    }
}

@end
