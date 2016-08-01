//
//  UIColor+Hex.h
//  Frbao
//
//  Created by ZhangMing on 14-5-8.
//  Copyright (c) 2014年 Leisure. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(NSInteger)hex;

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end
