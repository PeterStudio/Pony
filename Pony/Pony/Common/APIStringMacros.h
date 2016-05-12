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
#define API_BASE_URL_STRING      @"http://api.xiaomahome.com/api/v1/"

#else
// 正式环境
#define API_BASE_URL_STRING     @"http://api.xiaomahome.com/api/v1/"
#endif

#define POSTMethod                      @"POST"
#define GETMethod                       @"GET"

#define kAPILogin                       @"auth"                        // 登录
#define kAPIRegister                    @"register"                     // 注册
#define kAPILogout                      @"logout"

#endif /* APIStringMacros_h */
