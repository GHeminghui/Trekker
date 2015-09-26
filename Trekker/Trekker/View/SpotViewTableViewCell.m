//
//  SpotViewTableViewCell.m
//  Trekker
//
//  Created by MS on 15-9-23.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SpotViewTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface SpotViewTableViewCell ()
{
    
    IBOutlet UIImageView *_imageView;
    IBOutlet UILabel *_title;
    IBOutlet UILabel *_profile;
    
    IBOutlet UILabel *_otherLabel;
}
@end

@implementation SpotViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setUpCellData:(SpotProfile *)spt
{
     [_imageView setImageWithURL:[NSURL URLWithString:spt.cover_s] placeholderImage:[UIImage imageNamed:@"holder.png"]];
    _title.text =  spt.name;
    _profile.text = spt.recommended_reason;
    _otherLabel.text = [NSString stringWithFormat:@"距我 %.1lf千米  /  %ld 人去过",spt.distance,spt.visited_count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
