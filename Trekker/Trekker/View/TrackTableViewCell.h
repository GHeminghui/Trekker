//
//  TrackTableViewCell.h
//  Trekker
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *desc;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *time;
@end
