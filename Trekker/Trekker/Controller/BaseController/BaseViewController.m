//
//  BaseViewController.m
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma --mark  上拉刷新（使用MJRefresh第三方封装库）
- (void)pullToUpdateDataForTableView
{
    
    //避免循环引用(即：自己引用自己)
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.baseTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    // 此时self.tableView.footer == self.tableView.gifFooter
}

//刷新请求数据 子类中重写
-(void)loadMoreData
{
    
}

//显示加载进度条
-(void)showProgressHud
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
    _HUD.labelText = @"玩命加载中";
    
    [_HUD show:YES];
    
}

//隐藏加载进度条
-(void)hiddenProgressHud
{
    _HUD.hidden = YES;
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
