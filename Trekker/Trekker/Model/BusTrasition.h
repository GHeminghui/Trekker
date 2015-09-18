//
//  BusTrasition.h
//  Trekker
//
//  Created by MS on 15-9-18.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

//公交换乘方案模型
@interface BusTrasition : NSObject

//                BMK_BUSLINE                 = 0,///公交
//                BMK_SUBWAY                  = 1,///地铁
//                BMK_WAKLING                 = 2,///步行
@property (nonatomic,strong) BMKTime* duration;//
@property (nonatomic,assign) int distance;//距离
@property (nonatomic,strong) NSArray* steps;//具体换乘方案
@property (nonatomic,copy) NSString * trasitonProfil;//换乘概述
@end
