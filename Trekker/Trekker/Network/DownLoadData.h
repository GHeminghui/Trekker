//
//  DownLoadData.h
//  Trekker
//
//  Created by MS on 15-9-19.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadData : NSObject
+(void)getCategorys:(void (^) (id obj, NSError *err))block;
+(void)getdistricts:(void (^) (id obj, NSError *err))block withCityId:(NSString *)city_id;
+(void)getShopsLists:(void (^) (id obj, NSError *err))block withDicParams:(NSDictionary *)params;
+(void)getCites:(void (^) (id obj, NSError *err))block;
+(void)getHtmlData:(void (^) (id obj, NSError *err))block withUrl:(NSString *)url;
+(NSURLSessionDataTask *)getSpoteList:(void (^) (id obj, NSError *err))block andParaDic:(NSDictionary *)paraDic;
+(NSURLSessionDataTask *)getSpoteImages:(void (^) (id obj, NSError *err))block andParaDic:(NSDictionary *)paraDic andtype:(NSString *)type andId:(NSString *)iid;
@end
