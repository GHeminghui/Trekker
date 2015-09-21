//
//  loadDataFromNet.h
//  Trekker
//
//  Created by MS on 15-9-19.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface loadDataFromNet : NSObject
+(void)request: (NSString*)httpUrl withHttpArg: (NSDictionary *)HttpArg withCompletion: (void (^) (id obj, NSError *err))block ;
@end
