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
#define API_BASE_URL_STRING      @"http://192.168.1.147:18109/myLoan-mobile/action/api/"

#else
// 正式环境
#define API_BASE_URL_STRING     @"https://mobile.maiyabank.com/myLoan-mobile/action/api/"
#endif


#endif /* APIStringMacros_h */
