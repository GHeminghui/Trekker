//
//  AddInfoViewController.m
//  Trekker
//
//  Created by MS on 15-9-25.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "AddInfoViewController.h"
#import "Entity.h"


@interface AddInfoViewController ()
{
    void (^myBlock)(void) ;
    NSString * _cityName;
}
@end

@implementation AddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style: UIBarButtonItemStylePlain target:self action:@selector(doneTrackInfo:)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    
    UIBarButtonItem *barBtnLeft = [[UIBarButtonItem alloc] initWithTitle:@"放弃" style: UIBarButtonItemStylePlain target:self action:@selector(quitTrackInfo:)];
    self.navigationItem.leftBarButtonItem = barBtnLeft;
    
    
    self.navigationItem.title = @"新足迹";
    _cityName = @"北京";
    NSString * city = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    if (city) {
        _cityName = city;
    }
    self.location.text = _cityName;
    self.time.text = [Help DateChangeToString:[NSDate date] andFormatter:@"yyyy-MM-dd"];
}

-(void)reLoadMyTrackData:(void(^)(void)) block
{
    myBlock = block;
}

-(void)doneTrackInfo:(id)sender
{
    
    [DataBase saveLocation:self.location.text withDec:self.textView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
    myBlock();
}

-(void)quitTrackInfo:(id)sender
{
    self.textView.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
//    myBlock();
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
