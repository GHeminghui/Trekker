//
//  SpotInfoTableViewCell.h
//  Trekker
//
//  Created by MS on 15-9-24.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpotProfile.h"

@interface SpotInfoTableViewCell : UITableViewCell
-(void)reloadDataForCell:(SpotProfile *)spot andBlock:(void (^)(void))block;
@end
