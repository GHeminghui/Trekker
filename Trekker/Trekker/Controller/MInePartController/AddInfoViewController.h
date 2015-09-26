//
//  AddInfoViewController.h
//  Trekker
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SubBaseViewController.h"

@interface AddInfoViewController : SubBaseViewController
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UILabel *time;
-(void)reLoadMyTrackData:(void(^)(void)) block;
@end
