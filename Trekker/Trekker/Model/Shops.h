//
//  Shops.h
//  Trekker
//
//  Created by MS on 15-9-20.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shops : NSObject
@property (nonatomic,copy) NSString * shopName;
@property (nonatomic,copy) NSString * distance;
@property (nonatomic,strong) NSMutableArray * deals;
@property (nonatomic,copy) NSString * url;
@end
