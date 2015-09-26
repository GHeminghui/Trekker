//
//  Entity.h
//  Trekker
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * desc;

@end
