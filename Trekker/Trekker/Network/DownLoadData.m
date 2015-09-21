//
//  DownLoadData.m
//  Trekker
//
//  Created by MS on 15-9-19.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "DownLoadData.h"
#import "loadDataFromNet.h"

@implementation DownLoadData
+(void)getCategorys:(void (^)(id, NSError *))block
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/categories";
    NSDictionary *httpArg = @{};
    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];
}
+(void)getdistricts:(void (^) (id obj, NSError *err))block
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/districts";
    NSDictionary *httpArg = @{@"city_id":@"100010000"};

    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];

}

+(void)getShopsLists:(void (^) (id obj, NSError *err))block withDicParams:(NSDictionary *)params
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    NSDictionary *httpArg = params;
    
    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        block(obj,err);
        NSLog(@"%@",err);
    }];

}
@end
