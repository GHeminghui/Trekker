//
//  MineViewController.m
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "MineViewController.h"
#import "AddInfoViewController.h"
#import "TrackTableViewCell.h"
#import "Entity.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableView *_tableView;
    NSMutableArray * _dataSource;
}
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的足迹";
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMyLine:)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataSource = [[NSMutableArray alloc] init];
    NSArray * arr = [DataBase findAllTracks];
    [_dataSource addObjectsFromArray:arr];
}

-(void)addMyLine:(id)sender
{
    NSLog(@"开始添加记录");
    AddInfoViewController * addInfo = [[AddInfoViewController alloc] init];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:addInfo];
    [addInfo reLoadMyTrackData:^{
        //添加回调
        [_dataSource removeAllObjects];
        NSArray * arr = [DataBase findAllTracks];
        [_dataSource addObjectsFromArray:arr];
        [_tableView reloadData];
    }];
    //模态视图方式跳转
    [self presentViewController:nav animated:YES completion:nil];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entity * en = [_dataSource objectAtIndex:indexPath.row];
    NSString * desc = en.desc;
   CGRect rect = [desc boundingRectWithSize:CGSizeMake(_tableView.bounds.size.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    return rect.size.height + 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"track";
    TrackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"TrackTableViewCell" bundle:nil] forCellReuseIdentifier:str];
        cell = [tableView dequeueReusableCellWithIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entity * en = [_dataSource objectAtIndex:indexPath.row];
    
    TrackTableViewCell * tCell  = (TrackTableViewCell *)cell;
    tCell.desc.text = en.desc;
    tCell.location.text = en.position;
    tCell.time.text = [Help DateChangeToString:en.time andFormatter:@"yyyy-MM-dd HH:mm:ss"];
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
