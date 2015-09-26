//
//  FileOwner.m
//  Trekker
//
//  Created by MS on 15-9-24.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "FileOwner.h"
#import "SpotProfile.h"
#import "spotGalleryImage.h"
#import "UIImageView+WebCache.h"

#define SCROLLWHIDTH [[UIScreen mainScreen] bounds].size.width
#define SCROLLHEIGHT [[UIScreen mainScreen] bounds].size.height
@implementation FileOwner
{
    NSMutableArray * _Source;
    NSInteger  _currentIndex;
    
}

-(instancetype)init

{
    if (self  = [super init]) {
        [[NSBundle mainBundle] loadNibNamed:@"MyView" owner:self options:nil];
    }
    return self;
}
//传入全部数据 供以后使用
-(void)reloadDataForScroll:(NSMutableArray *)dataSource
{
    
    _Source = [[NSMutableArray alloc] init];
    [_Source addObjectsFromArray:dataSource];
   
}



@end
