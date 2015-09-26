//
//  SpotProfile.h
//  Trekker
//
//  Created by MS on 15-9-23.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotProfile : NSObject
@property (nonatomic,copy) NSString * name;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger iid;
@property (nonatomic,copy) NSString * cover_s;
@property (nonatomic,copy) NSString * recommended_reason;//推荐原因
@property (nonatomic,assign) NSInteger visited_count;//参观人数
@property (nonatomic,assign) double distance;//距离我的距离
//基本信息
@property (nonatomic,copy) NSString * ddescription;//概况
@property (nonatomic,copy) NSString * address;//地址
@property (nonatomic,copy) NSString * arrival_type;//到达方式
@property (nonatomic,copy) NSString * opening_time;//开放时间
@property (nonatomic,copy) NSString * tel;//联系方式

@end
