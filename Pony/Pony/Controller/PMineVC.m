//
//  PMineVC.m
//  Pony
//
//  Created by Baby on 16/5/12.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PMineVC.h"

@interface PMineVC()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;

@end


@implementation PMineVC


- (IBAction)logout:(id)sender {
    [USERMANAGER logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_SWITCH_VC
                                                        object:USERLOGIC_SB];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 120.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return _headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
}


@end
