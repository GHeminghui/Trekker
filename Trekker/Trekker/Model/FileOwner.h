//
//  FileOwner.h
//  Trekker
//
//  Created by MS on 15-9-24.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileOwner : NSObject
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *ddescription;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end
