//
//  DataBase.h
//  Trekker
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBase : NSObject
+(void)setUpMagicalRecord;//初始化
+(void)saveLocation:(NSString *)position withDec:(NSString *)desc;
+(NSArray *)findAllTracks;
+(void)deleteTreacks:(NSDate *)date;
@end
