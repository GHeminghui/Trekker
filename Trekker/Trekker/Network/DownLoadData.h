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
+(void)getdistricts:(void (^) (id obj, NSError *err))block;
+(void)getShopsLists:(void (^) (id obj, NSError *err))block withDicParams:(NSDictionary *)params;
+(void)getHtmlData:(void (^) (id obj, NSError *err))block withUrl:(NSString *)url;
@end
