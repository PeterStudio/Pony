//
//  PublicCustomWebVC.m
//  Pony
//
//  Created by 杜文 on 16/8/29.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "PublicCustomWebVC.h"
#import "Masonry.h"


@interface PublicCustomWebVC ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@end

@implementation PublicCustomWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.webView setBackgroundColor:kClearColor];
    [self.webView setScalesPageToFit:YES];
    self.webView.delegate = self;
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_webView];
    
    @weakify(self)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.edges.equalTo(self.view);
    }];
    
    NSURL * url = [NSURL URLWithString:[self.docUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showMessage:nil toView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    if (self.docTitle) {
        self.title = self.docTitle;
    }else{
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view];
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
