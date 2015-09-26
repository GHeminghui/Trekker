//
//  DataBase.m
//  Trekker
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "DataBase.h"
#import "Entity.h"

@implementation DataBase
+(void)setUpMagicalRecord
{
    //初始化
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"mydatabase.sqlite"];
}

+(void)saveLocation:(NSString *)position withDec:(NSString *)desc
{
    Entity * en = [Entity MR_createEntity];
    en.time = [NSDate date];
    en.desc = desc;
    en.position = position;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
+(NSArray *)findAllTracks
{
    NSArray * arr = [Entity MR_findAllSortedBy:@"time" ascending:NO];
    return arr;
}
+(void)deleteTreacks:(NSDate *)date
{
    NSArray * arr = [Entity MR_findByAttribute:@"time" withValue:date];
    if (arr) {
        Entity * en = [arr objectAtIndex:0];
        [en MR_deleteEntity];
    }
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
@end
