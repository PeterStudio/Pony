//
//  ShareVC.m
//  Pony
//
//  Created by Baby on 16/5/16.
//  Copyright © 2016年 peterstudio. All rights reserved.
// 分享

#import "ShareVC.h"
#import "UMSocial.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>


#define AppName @"小马过河"
#define AppOfficialURL  @"http://www.xiaomahome.com"
#define AppIcon [UIImage imageNamed:@"shareicon"]
#define AppInfo @"怕上当、无信任、不权威？小马过河第二板斧，通过强大的智能算法评价每一个伯乐的服务品质，为您匹配最佳咨询对象，不管你有多么彷徨，小马过河是你最坚实的后盾，让你安心无忧咨询"

@interface ShareVC ()

@end

@implementation ShareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

/**微信好友*/
- (IBAction)weChat:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    [UMSocialData defaultData].extConfig.wechatSessionData.url = AppOfficialURL;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = AppName;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:AppInfo image:AppIcon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

/**微信朋友圈*/
- (IBAction)weChatZone:(id)sender {
    if (![WXApi isWXAppInstalled]) {
        return;
    }
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = AppOfficialURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = AppName;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:AppInfo image:AppIcon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

/**新浪微博*/
- (IBAction)sina:(id)sender {
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = AppOfficialURL;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = AppName;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:AppInfo image:AppIcon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

/**QQ空间*/
- (IBAction)qqZone:(id)sender {
    if (![QQApiInterface isQQInstalled]) {
        return;
    }
    
    [UMSocialData defaultData].extConfig.qzoneData.url = AppOfficialURL;
    [UMSocialData defaultData].extConfig.qzoneData.title = AppName;
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:AppInfo image:AppIcon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

/**QQ好友*/
- (IBAction)qq:(id)sender {
    if (![QQApiInterface isQQInstalled]) {
        return;
    }
    
    [UMSocialData defaultData].extConfig.qqData.url = AppOfficialURL;
    [UMSocialData defaultData].extConfig.qqData.title = AppName;
//    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                        @"http://www.baidu.com/img/bdlogo.gif"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:AppInfo image:AppIcon location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

/**短信*/
- (IBAction)message:(id)sender {
//    [UMSocialData defaultData].extConfig.smsData.
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:AppInfo image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
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
