//
//  MoreDellTableViewCell.m
//  Trekker
//
//  Created by MS on 15-9-21.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "MoreDellTableViewCell.h"

@interface MoreDellTableViewCell ()
{
    NSInteger _catNumber;
    IBOutlet UILabel *moreCateLabel;
}
@end

@implementation MoreDellTableViewCell

- (void)awakeFromNib {
}
-(void)setCatNum:(NSInteger)num
{
    _catNumber = num;
    
    moreCateLabel.text = [NSString stringWithFormat:@"其他%ld个美食  V",_catNumber];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
