//
//  SearchBindAlipayM.h
//  Pony
//
//  Created by 杜文 on 16/9/8.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol AlipayInfoM <NSObject>
@end

@interface AlipayInfoM : JSONModel
@property (nonatomic, copy) NSString<Optional> * alipayNo;
@property (nonatomic, copy) NSString<Optional> * alipayName;
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * userId;
@end

@interface SearchBindAlipayM : JSONModel
@property (nonatomic, copy) NSString<Optional> * alipaystatus;
@property (nonatomic, copy) NSString<Optional> * money;
@property (nonatomic, strong) AlipayInfoM<Optional> * alipayinfo;
@end
