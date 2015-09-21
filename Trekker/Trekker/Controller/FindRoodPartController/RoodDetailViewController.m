//
//  RoodDetailViewController.m
//  Trekker
//
//  Created by MS on 15-9-18.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "RoodDetailViewController.h"

#import "BusTrasitionTableViewCell.h"
#import "BusRoutsItemTableViewCell.h"
#import "MapViewController.h"

@interface RoodDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UITableView *_tableView;
    NSMutableArray * _dataSource;
}
@end

@implementation RoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [[NSMutableArray alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
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
    mapC.Type = @"bus";
    [self.navigationController pushViewController:mapC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;
    static NSString * str ;
    BMKTransitStep * trStep = [_dataSource objectAtIndex:indexPath.row];
//    BMKTransitStep
    if (trStep.stepType == BMK_WAKLING) {
        str = @"walking";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"BusTrasitionTableViewCell" bundle:nil] forCellReuseIdentifier:str];
            cell = [tableView dequeueReusableCellWithIdentifier:str];
        }
        BusTrasitionTableViewCell * busCell = (BusTrasitionTableViewCell *)cell;
        busCell.detailInfo.text = trStep.instruction;
        
        NSLog(@"%@ %@ %@ %d %d元 %d元",trStep.instruction,trStep.entrace.title,trStep.exit.title,trStep.vehicleInfo.passStationNum,trStep.vehicleInfo.totalPrice,trStep.vehicleInfo.zonePrice);
    }else
    {
        str = @"bus";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"BusRoutsItemTableViewCell" bundle:nil] forCellReuseIdentifier:str];
            cell = [tableView dequeueReusableCellWithIdentifier:str];
        }
        BusRoutsItemTableViewCell * busRoutCell = (BusRoutsItemTableViewCell *)cell;
        busRoutCell.detailInfo.text = trStep.instruction;
        
        NSLog(@"%@ %@ %@ %d %d元 %d元",trStep.instruction,trStep.entrace.title,trStep.exit.title,trStep.vehicleInfo.passStationNum,trStep.vehicleInfo.totalPrice,trStep.vehicleInfo.zonePrice);
    }
    return  cell;
}

@end
