//
//  loadDataFromNet.m
//  Trekker
//
//  Created by MS on 15-9-19.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "loadDataFromNet.h"
#import "NSString+URLEncoding.h"

#define APIKEY @"db05609582bebb204dfbdad5e818d45a"

@implementation loadDataFromNet

+(void)request: (NSString*)httpUrl withHttpArg: (NSDictionary *)HttpArg withCompletion: (void (^) (id obj, NSError *err))block  {
    NSString * arg = [Help JoinTogetherFromDic:HttpArg];//拼接参数
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl,arg];
    NSLog(@"====url   +++ %@",[urlStr URLEncodedString]);
    NSURL *url = [NSURL URLWithString: [urlStr URLEncodedString]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];//超时时间10s
    [request setHTTPMethod: @"GET"];
    [request addValue:APIKEY forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   block(nil,error);
                               } else {
//                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSLog(@"HttpResponseBody %@",responseString);
                                   NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   block(dic,nil);//以字典形式返回数据
                               }
                           }];
}
@end
