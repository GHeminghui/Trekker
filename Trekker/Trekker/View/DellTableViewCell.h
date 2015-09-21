//
//  DellTableViewCell.h
//  Trekker
//
//  Created by MS on 15-9-20.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "Deal.h"

@interface DellTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *currentProice;
@property (strong, nonatomic) IBOutlet UILabel *markPrice;
@property (strong, nonatomic) IBOutlet UILabel *promotePrice;
@property (strong, nonatomic) IBOutlet UILabel *saleNum;

-(void)loadDataFromModel:(Deal *)deal;
@end
