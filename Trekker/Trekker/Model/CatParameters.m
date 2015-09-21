//
//  CatParameters.m
//  Trekker
//
//  Created by MS on 15-9-20.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "CatParameters.h"

//property (nonatomic,copy) NSString *city_id;
//@property (nonatomic,copy) NSString *cat_ids;
//@property (nonatomic,copy) NSString *subcat_ids;
//@property (nonatomic,copy) NSString *district_ids;
//@property (nonatomic,copy) NSString *keyword;
//@property (nonatomic,copy) NSString *radius;
//@property (nonatomic,copy) NSString *page;
//@property (nonatomic,copy) NSString *page_size;
//@property (nonatomic,copy) NSString *location;

@implementation CatParameters
-(NSDictionary *)retDicParameter
{
    return @{@"city_id":self.city_id,@"cat_ids":self.cat_ids,@"subcat_ids":self.subcat_ids,@"district_ids":self.district_ids,@"page":self.page,@"page_size":self.page_size};
}
@end
