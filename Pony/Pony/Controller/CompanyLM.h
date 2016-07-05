//
//  CompanyLM.h
//  Pony
//
//  Created by 杜文 on 16/7/2.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol CompanyM <NSObject>

@end
@interface CompanyM : JSONModel
@property (nonatomic, copy) NSString<Optional> * id;
@property (nonatomic, copy) NSString<Optional> * company;
@property (nonatomic, copy) NSString<Optional> * companyDescription;
@end

@interface CompanyLM : JSONModel
@property (nonatomic, strong) NSArray<CompanyM, Optional> * data;
@end
