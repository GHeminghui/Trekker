//
//  CatParameters.h
//  Trekker
//
//  Created by MS on 15-9-20.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

////获取糯米选着参数
//NSString * city_id;//城市id
//NSString * cat_ids;//分类id 默认326 美食
//NSString * subcat_ids;//二级分类id
//NSString * district_ids;//行政区域id
//NSString * location;//用户所在位置
//NSString * keyword;//关键词搜索
//NSString * radius;//半径范围
//NSString * page;//页码
//NSString * page_size;//每页返回的团单结果条数 默认为5
//NSString * sort;//排序

@interface CatParameters : NSObject
@property (nonatomic,copy) NSString *city_id;
@property (nonatomic,copy) NSString *cat_ids;
@property (nonatomic,copy) NSString *subcat_ids;
@property (nonatomic,copy) NSString *district_ids;
@property (nonatomic,copy) NSString *keyword;
@property (nonatomic,copy) NSString *radius;
@property (nonatomic,copy) NSString *page;
@property (nonatomic,copy) NSString *page_size;
@property (nonatomic,copy) NSString *location;
-(NSDictionary *)retDicParameter;
@end
