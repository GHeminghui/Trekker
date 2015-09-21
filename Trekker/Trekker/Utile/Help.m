//
//  Help.m
//  Trekker
//
//  Created by MS on 15-9-19.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "Help.h"

@implementation Help
/**
 *  将字典类型的参数 拼接成url
 *
 *  @param dic 请求参数的字典形式
 *
 *  @return 返回拼接好的字符串
 */
+(NSString *)JoinTogetherFromDic:(NSDictionary *)dic
{
    NSArray * keys = [dic allKeys];
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    for (NSString * key in keys) {
        [arr addObject:[NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]]];
    }
    
    return [arr componentsJoinedByString:@"&"];
}
@end
