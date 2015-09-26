//
//  SpotInfoTableViewCell.m
//  Trekker
//
//  Created by MS on 15-9-24.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SpotInfoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GalleryViewController.h"

@interface SpotInfoTableViewCell ()
{
 
    IBOutlet UIImageView *_imageView;
    
    IBOutlet UILabel *_name;
    
    IBOutlet UILabel *_recommed;
    
    IBOutlet UILabel *_profileInfo;
    IBOutlet UILabel *_address;
    
    
    IBOutlet UILabel *_arrivieType;
    
    IBOutlet UILabel *_openTime;
    IBOutlet UILabel *_tel;
    void (^b_block)(void);
}
@end

@implementation SpotInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)reloadDataForCell:(SpotProfile *)spot andBlock:(void (^)(void))block
{
    b_block = block;
    [_imageView setImageWithURL:[NSURL URLWithString:spot.cover_s] placeholderImage:[UIImage imageNamed:@"holder.png"]];
    
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImageGallary:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_imageView addGestureRecognizer:tap];
    
    _name.text = spot.name;
    _recommed.text = spot.recommended_reason;
    _profileInfo.text = spot.ddescription;
    
    CGSize size =  [spot.ddescription boundingRectWithSize:CGSizeMake(self.bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    _profileInfo.bounds = CGRectMake(0, 0, size.height, size.width);
    _address.text = spot.address;
    
    _arrivieType.text = spot.arrival_type;
    _openTime.text = spot.opening_time;
    _tel.text = spot.tel;
}

-(void)checkImageGallary:(UITapGestureRecognizer *)tap
{
    if (b_block) {
        b_block();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
