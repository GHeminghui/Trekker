//
//  Deal.h
//  Trekker
//
//  Created by MS on 15-9-20.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deal : NSObject
@property (nonatomic,copy) NSString * imagurl;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,copy) NSString * currentPrice;
@property (nonatomic,copy) NSString * markPrice;
@property (nonatomic,copy) NSString * parameterPrice;
@property (nonatomic,copy) NSString * saleNum;
@property (nonatomic,copy) NSString * url;
@end
