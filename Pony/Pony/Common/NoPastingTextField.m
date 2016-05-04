//
//  NoPastingTextField.m
//  Pony
//
//  Created by 杜文 on 16/5/4.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "NoPastingTextField.h"

@implementation NoPastingTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
