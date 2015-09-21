//
//  CateSaleInfoViewController.m
//  Trekker
//
//  Created by MS on 15-9-21.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "CateSaleInfoViewController.h"

@interface CateSaleInfoViewController ()
{
    NSString * _webUrl;
    IBOutlet UIWebView *_cateInfoWeb;
}
@end

@implementation CateSaleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [DownLoadData getHtmlData:^(id obj, NSError *err) {
//        
//         [cateInfoWeb loadHTMLString:obj baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
//    } withUrl:_webUrl];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]];
    [_cateInfoWeb loadRequest:request];
}

-(void)loadCateInfoWebPage:(NSString *)url
{
    NSLog(@"url======%@",url);
    _webUrl = url;
//    [cateInfoWeb loadHTMLString:html baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
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
