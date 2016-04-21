//
//  HomeViewController.m
//  Pony
//
//  Created by Baby on 16/1/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HomeViewController.h"
#import "JCHATChatViewController.h"
#import <JMessage/JMessage.h>

@interface HomeViewController ()



@property (strong, nonatomic) IBOutlet UIView *footerView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)callButonClicked:(id)sender {
    JCHATChatViewController *chatViewController = [[JCHATChatViewController alloc] initWithNibName:@"JCHATChatViewController"
                                                                                            bundle:nil];
    [self.navigationController pushViewController:chatViewController animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 400.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footerView;
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
