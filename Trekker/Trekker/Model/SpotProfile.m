//
//  SpotProfile.m
//  Trekker
//
//  Created by MS on 15-9-23.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SpotProfile.h"

@implementation SpotProfile

//kvc
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.iid = [value integerValue];
    }else if([key isEqualToString:@"description"])
    {
        self.ddescription = value;
    }else
    {
        //其他没有的不处理
    }
}
@end
