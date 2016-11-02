//
//  APIStringMacros.h
//  Pony
//
//  Created by 杜文 on 16/4/26.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#ifndef APIStringMacros_h
#define APIStringMacros_h

//接口名称相关
#ifdef DEBUG
//Debug状态下的测试API 
#define API_BASE_URL_STRING      @"http://api.xiaomahome.com/api/v1/"//@"http://xiaoma.weabuy.cn/api/v1/"

// @"http://192.168.1.105:8080/api/v1/"
// @"http://api.xiaomahome.com/api/v1/"

#else
// 正式环境
#define API_BASE_URL_STRING     @"http://api.xiaomahome.com/api/v1/"
#endif
  
#define POSTMethod                      @"POST"
#define GETMethod                       @"GET"

#define kAPILogin                       @"auth"                        // 登录
#define kAPIForget                      @"forget"                       // 忘记密码
#define kAPIReset                       @"reset"                        // 重置密码

#define kAPIRegister                    @"user/register"                     // 注册
#define kAPISetBalancePassowrd          @"user/setBalancePassowrd"       // 设置交易密码
#define kAPIResetBalancePassowrd        @"user/resetBalancePassowrd"     // 修改交易密码
#define kAPISearch                      @"user/search"                   // 检索用户
#define kAPIUserUpdate                  @"user/update"                   // 更新用户
#define kAPIGet                         @"user/get"                      // 获得单一用户信息
#define kAPIUploadToken                 @"user/uploadToken"              // 获得七牛云上传token
#define kAPIGetBoleDetail               @"user/getBoleDetail"              // 获取伯乐综合信息


#define kAPISave                        @"userjobs/save"                 // 新增工作经历（伯乐认证接口）
#define kAPIUserjobsUpdate              @"userjobs/update"                 // 更新工作经历（更新认证后，用户审核状态重置为未认证）
#define kAPIUserjobsGet                 @"userjobs/get"
#define kAPIGetlist                     @"userjobs/getlist"             // 搜索工作经历
#define kAPIUserjobsSearch              @"userjobs/search"             // 小马搜索伯乐触发推送接口

#define kAPIIndustryGetlist             @"industry/getlist"             // 搜索行业信息

//#define kAPICompanyGetlist              @"company/getlist"             // 搜索公司信息
#define kAPICompanySearch               @"company/search"             // 根据行业ID搜索公司信息

#define kAPIJobSearch                   @"job/search"             // 根据公司ID搜索工作岗位信息
//#define kAPIJobGetlist                  @"job/getlist"             // 搜索工作岗位信息

#define kAPIGradeGetlist             @"grade/getlist"             // 获取伯乐等级信息

#define kAPIAddTalk                 @"talk/addTalk"                 // 添加聊天
#define kAPICloseTalk               @"talk/closeTalk"             // 用户结束聊天接口
#define kAPITalkGetlist             @"talk/getlist"             // 用户聊天记录
#define kAPITalkListenTalk          @"talk/listenTalk"             // 监听小马的订单接口
#define kAPITalkGrabTalk            @"talk/grabTalk"             // 伯乐抢单接口
#define kAPIGetBoleStatics          @"talk/getBoleStatics"               // 伯乐抢单&流水

#define kAPICommentsConfigGetlist           @"commentsConfig/getlist"             // 获取评价标签配置信息（评价标签可配置）
#define kAPICommentsSave                @"comments/save"             // 新增伯乐服务评价
#define kAPICommentsGetlist             @"comments/getlist"             // 获取伯乐服务评价


#define kAPIMoneylogGetlist           @"moneylog/getlist"             // 消费流水记录
#define kAPIMongeylogSave               @"mongeylog/save"             // 新增消费流水
#define kAPIMongeylogCashout           @"mongeylog/cashout"             // 提现接口
#define kAPIHeartbeatCheck            @"heartbeat/check"             // 心跳应答接口

#define kAPIMoneyGet                @"money/get"             // 查询用户钱包余额信息
#define kAPIMoneyCashSign           @"money/cashSign"             // 客户端签名接口
#define kAPIMoneyCallback           @"money/callback"             // 支付宝回调接口

#define kAPIVersionGet              @"version/get"              // 版本更新

#define kAPIAlipayInfo              @"alipay/cashout/searchbindalipay"
#define kAPIAlipayBind              @"alipay/cashout/bindalipay"
#define kAPIAlipayCashOut           @"alipay/cashout/addCashOut"























#endif /* APIStringMacros_h */
