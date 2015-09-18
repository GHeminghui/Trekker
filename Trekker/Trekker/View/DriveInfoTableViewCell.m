//
//  DriveInfoTableViewCell.m
//  Trekker
//
//  Created by MS on 15-9-18.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "DriveInfoTableViewCell.h"

@interface DriveInfoTableViewCell ()
{
    
    IBOutlet UIView *labelTag;
}
@end


@implementation DriveInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    labelTag.layer.cornerRadius = 30/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
