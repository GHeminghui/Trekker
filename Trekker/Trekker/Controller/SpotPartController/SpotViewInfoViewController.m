//
//  SpotViewInfoViewController.m
//  Trekker
//
//  Created by MS on 15-9-23.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SpotViewInfoViewController.h"
#import "SpotProfile.h"
#import "SpotInfoTableViewCell.h"
#import "GalleryViewController.h"

@interface SpotViewInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_tableView;
}
@end

@implementation SpotViewInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * ddsecription = self.spot.ddescription;
    NSString * arrType = self.spot.arrival_type;
  CGSize ddscriptionSize = [ddsecription boundingRectWithSize:CGSizeMake(_tableView.bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    CGSize arriveTypeSize = [arrType boundingRectWithSize:CGSizeMake(_tableView.bounds.size.width - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    return 580 + ddscriptionSize.height + arriveTypeSize.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"spotInfo";
    SpotInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SpotInfoTableViewCell" bundle:nil] forCellReuseIdentifier:str];
        cell = [tableView dequeueReusableCellWithIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //执行点击图片跳转
    [cell reloadDataForCell:self.spot andBlock:^{
        
        GalleryViewController * gallery = [[GalleryViewController alloc] initWithNibName:@"GalleryViewController" bundle:nil];
        gallery.spot = self.spot;//传值
        
        [self.navigationController pushViewController:gallery animated:YES];
        
    }];
    return cell;
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
