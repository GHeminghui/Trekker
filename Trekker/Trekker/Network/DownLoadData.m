//
//  DownLoadData.m
//  Trekker
//
//  Created by MS on 15-9-19.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "DownLoadData.h"
#import "loadDataFromNet.h"
#import "AFAppDotNetAPIClient.h"
#import "NSString+URLEncoding.h"

@implementation DownLoadData
+(void)getCategorys:(void (^)(id, NSError *))block
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/categories";
    NSDictionary *httpArg = @{};
    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];
}
+(void)getdistricts:(void (^) (id obj, NSError *err))block withCityId:(NSString *)city_id
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/districts";
    NSDictionary *httpArg = @{@"city_id":city_id};

    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];

}
+(void)getCites:(void (^) (id obj, NSError *err))block
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/cities";
    NSDictionary *httpArg = @{};
    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        NSArray * city_Arr = [obj objectForKey:@"cities"];
         block(city_Arr,err);
    }];
}

+(void)getShopsLists:(void (^) (id obj, NSError *err))block withDicParams:(NSDictionary *)params
{
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    NSDictionary *httpArg = params;
    NSLog(@"请求参数%@",httpArg);
    [loadDataFromNet request:httpUrl withHttpArg:httpArg withCompletion:^(id obj, NSError *err) {
        block(obj,err);
        NSLog(@"%@",err);
    }];

}

+(void)getHtmlData:(void (^) (id obj, NSError *err))block withUrl:(NSString *)url
{
    [loadDataFromNet requestWeb:url withHttpArg:@{} withCompletion:^(id obj, NSError *err) {
        block(obj,err);
    }];

}

+(NSURLSessionDataTask *)getSpoteList:(void (^) (id obj, NSError *err))block andParaDic:(NSDictionary *)paraDic
{
    //    如果是GET请求，接口中有汉字，必须转码，否则请求失败或者会崩溃
    NSString * arg = [Help JoinTogetherFromDic:paraDic];//拼接参数
    NSString *path = [[NSString stringWithFormat:@"place/pois/nearby/?%@",arg] URLEncodedString];
    
    NSLog(@"----path %@",path);
    
    return [[AFAppDotNetAPIClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    
        NSData *data = (NSData *)responseObject;
        
        NSDictionary * dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            block(dicData,nil);//解析好的数据返回
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(nil,error);
        }
    }];

}

+(NSURLSessionDataTask *)getSpoteImages:(void (^) (id obj, NSError *err))block andParaDic:(NSDictionary *)paraDic andtype:(NSString *)type andId:(NSString *)iid
{
    //    如果是GET请求，接口中有汉字，必须转码，否则请求失败或者会崩溃
    NSString * arg = [Help JoinTogetherFromDic:paraDic];//拼接参数
    NSString *path = [[NSString stringWithFormat:@"destination/place/%@/%@/photos/?%@",type,iid,arg] URLEncodedString];

    return [[AFAppDotNetAPIClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSData *data = (NSData *)responseObject;
        
        NSDictionary * dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (block) {
            block(dicData,nil);//解析好的数据返回
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (block) {
            block(nil,error);
        }
    }];
    
}

@end
