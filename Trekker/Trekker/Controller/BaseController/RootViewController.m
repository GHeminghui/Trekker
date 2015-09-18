//
//  RootViewController.m
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "RootViewController.h"
#import "SpotViewController.h"
#import "CateViewController.h"
#import "FindRoodViewController.h"
#import "MineViewController.h"
#import "RDVTabBarItem.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加tabbar
    [self setUpTabBarControllers];
}

-(void)setUpTabBarControllers
{
    SpotViewController * spot = [[SpotViewController alloc] initWithNibName:@"SpotViewController" bundle:nil];
    CateViewController * cate = [[CateViewController alloc] initWithNibName:@"CateViewController" bundle:nil];
    FindRoodViewController * findRoot = [[FindRoodViewController alloc] initWithNibName:@"FindRoodViewController" bundle:nil];
    MineViewController * mine = [[MineViewController alloc] initWithNibName:@"MineViewController" bundle:nil];
    
    UINavigationController * navSpot = [[UINavigationController alloc] initWithRootViewController:spot];
    UINavigationController * navCate = [[UINavigationController alloc] initWithRootViewController:cate];
    UINavigationController * navFind = [[UINavigationController alloc] initWithRootViewController:findRoot];
    UINavigationController * navMine = [[UINavigationController alloc] initWithRootViewController:mine];
    self.viewControllers = @[navSpot,navCate,navFind,navMine];
    
    //美化标签栏
    [self customizeTabBarForController];
}

//美化标签栏
-(void)customizeTabBarForController
{
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"tabbar_home", @"tabbar_feature", @"tabbar_profile",@"favorite_icon"];
    NSArray * titlArr = @[@"周边景点",@"美食街",@"线路导航",@"我的"];
    
    
    NSInteger index = 0;
    
    //设置标签栏字体样式
    NSDictionary *textAttributes_normal = nil;
    NSDictionary *textAttributes_selected = nil;
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        textAttributes_normal = @{
                                  NSFontAttributeName: [UIFont systemFontOfSize:12],
                                  NSForegroundColorAttributeName: [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0],
                                  };
        textAttributes_selected = @{
                                    NSFontAttributeName: [UIFont systemFontOfSize:14],
                                    NSForegroundColorAttributeName: [UIColor colorWithRed:60/255.0 green:169/255.0 blue:255/255.0 alpha:1.0],
                                    };
    }
    
    
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.unselectedTitleAttributes = textAttributes_normal;
        item.selectedTitleAttributes = textAttributes_selected;
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_press",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title = [titlArr objectAtIndex:index];
        index++;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
