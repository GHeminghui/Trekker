//
//  DriveRoodDetailViewController.m
//  Trekker
//
//  Created by MS on 15-9-18.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "DriveRoodDetailViewController.h"
#import "MapViewController.h"
#import "DriveInfoTableViewCell.h"

@interface DriveRoodDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_tableView;
    NSMutableArray * _dataSource;
}
@end

@implementation DriveRoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"线路详情";
    
    //初始化数据源
    [_dataSource addObjectsFromArray:self.line.steps];
    [_tableView reloadData];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom ];
    [btn setImage:[UIImage imageNamed:@"mapBarBtn.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * Barbtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = Barbtn;
}

//跳转到地图
-(void)showMap:(id)sender
{
    MapViewController * mapC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapC.plan = self.line;
    [self.navigationController pushViewController:mapC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"str";
    DriveInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"DriveInfoTableViewCell" bundle:nil] forCellReuseIdentifier:str];
        cell = [tableView dequeueReusableCellWithIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _dataSource.count) {
        DriveInfoTableViewCell * dCell = (DriveInfoTableViewCell *)cell;
        BMKDrivingStep * dStep = [_dataSource objectAtIndex:indexPath.row];
        dCell.driveInfo.text =  [NSString stringWithFormat:@"%@,需要%d次转弯",dStep.entraceInstruction,dStep.numTurns];
    }else
    {
        DriveInfoTableViewCell * dCell = (DriveInfoTableViewCell *)cell;
        dCell.driveInfo.text = @"到达终点";
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
