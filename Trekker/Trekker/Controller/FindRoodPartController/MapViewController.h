//
//  MapViewController.h
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SubBaseViewController.h"

#import <BaiduMapAPI/BMapKit.h>


@interface MapViewController : SubBaseViewController<BMKMapViewDelegate, BMKRouteSearchDelegate>

@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong,nonatomic) BMKRouteLine* plan;
@property (copy,nonatomic) NSString * Type;
@end
