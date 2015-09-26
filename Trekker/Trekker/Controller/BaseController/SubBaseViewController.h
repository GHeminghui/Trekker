//
//  SubBaseViewController.h
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubBaseViewController : UIViewController<MBProgressHUDDelegate>
@property (nonatomic,strong) UITableView * baseTableView;//基础
 ;//基础tableView 需要刷新的界面 将tableview给该基础tableView
@property (nonatomic,strong) MBProgressHUD *HUD;//定义成属性 子类可以继承
- (void)pullToUpdateDataForTableView;
-(void)loadMoreData;//子类中需要重写
-(void)showProgressHud;//显示进度条
-(void)hiddenProgressHud;//隐藏进度条
@end
