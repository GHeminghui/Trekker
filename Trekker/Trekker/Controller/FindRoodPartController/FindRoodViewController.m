//
//  FindRoodViewController.m
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "FindRoodViewController.h"
#import "MapViewController.h"

#import "BusRoutsTableViewCell.h"
#import "TaxiInfoTableViewCell.h"
#import "BusTrasition.h"
#import "RoodDetailViewController.h"

#import "DriveRoutsTableViewCell.h"
#import "WalkRoutsTableViewCell.h"

#import "DriveRoodDetailViewController.h"

#import "WalkRoadViewController.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


@interface FindRoodViewController ()<UITextFieldDelegate,UIAlertViewDelegate,BMKRouteSearchDelegate>
{
    IBOutlet UISegmentedControl *_checkType;
    
    IBOutlet UITextField *_startPoint;
    IBOutlet UITextField *_endPoint;
    
    IBOutlet UITableView *_tableView;
    
    NSString * _searchTypeName;//搜索类型名称
    NSString * _startLocationName;//起始地点名称
    NSString * _endLocationName;//终点名称
    
    BMKRouteSearch * _routesearch;//百度路径规划
    NSMutableArray * _dataSource;
    
    NSString * _city ;//线路检索默认城市
    
}
@end

@implementation FindRoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"线路导航";
    _startPoint.clearButtonMode = UITextFieldViewModeWhileEditing;
    _endPoint.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _startPoint.placeholder = @"起始地点名称";
    _endPoint.placeholder = @"终止地点名称";
    
    _city = @"北京市";
    
    _startPoint.delegate = self;
    _endPoint.delegate = self;
    
    UIBarButtonItem * barBtn = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(beginSearchRoadLine:)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    if (_tableView.tableFooterView == nil) {
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _dataSource = [[NSMutableArray alloc] init];
    
//    [self addTapGetsture];
    
    
    _routesearch = [[BMKRouteSearch alloc]init];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
     _routesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    _routesearch.delegate = nil;
}

//地图搜索事件，开始搜索
-(void)beginSearchRoadLine:(id)sender
{
    //获取城市
   NSString * cityN = [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
   
    if (cityN) {
        _city = cityN;
    }
    UIBarButtonItem * bar = [[UIBarButtonItem alloc] initWithTitle:_city style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = bar;
    
    [_startPoint resignFirstResponder];
    [_endPoint resignFirstResponder];
    if ([_startPoint.text isEqualToString:@""]) {
        [self alert:_startPoint.placeholder];
        return;
    }else if([_endPoint.text isEqualToString:@""])
    {
        [self alert:_endPoint.placeholder];
        return;
    }
    
    _startLocationName = _startPoint.text;
    _endLocationName = _endPoint.text;
    
    switch (_checkType.selectedSegmentIndex) {
        case 0://公交线路查询
            [self busSearch];
            break;
        case 1://步行线路查询
            [self walkSearch];
            break;
        default://驾车路线查询
            [self driveSearch];
            break;
    }
}

-(void)alert:(NSString *)type//提示警告框
{
    NSString * str = [NSString stringWithFormat:@"%@不能为空",type];
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
}
-(void)addTapGetsture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [_startPoint resignFirstResponder];
    [_endPoint resignFirstResponder];
}


#pragma --mark UITextFieldDelegate
 
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选择查询线路类型
- (IBAction)checkTypeChanged:(id)sender {
    UISegmentedControl * seg = (UISegmentedControl *)sender;
    if (seg.selectedSegmentIndex == 0) {
        _searchTypeName = @"公交";
    }else if(seg.selectedSegmentIndex == 1)
    {
        _searchTypeName = @"步行";
    }else
    {
        _searchTypeName = @"驾车";
    }
    
    [_dataSource removeAllObjects];
    [_tableView reloadData];
}

//公交路线检索
-(void)busSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.name = _startLocationName;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.name = _endLocationName;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city= _city;
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;

    BOOL flag = [_routesearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }

}

//驾车路线查询
-(void)driveSearch
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.cityName = _city;
    start.name = _startLocationName;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = @"北京";
    end.name = _endLocationName;
    
    BMKDrivingRoutePlanOption * drivingRoutePlanOption = [[BMKDrivingRoutePlanOption alloc] init];
    drivingRoutePlanOption.from = start;
    drivingRoutePlanOption.to = end;
    
    BOOL flag = [_routesearch drivingSearch:drivingRoutePlanOption];
    
    if(flag)
    {
        NSLog(@"驾车检索发送成功");
    }
    else
    {
        NSLog(@"驾车检索发送失败");
    }

}
//步行路线检索
-(void)walkSearch
{
//    BMKWalkingRoutePlanOption
    
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.cityName = _city;
    start.name = _startLocationName;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = _city;
    end.name = _endLocationName;
    
    BMKWalkingRoutePlanOption * walkingRoutePlanOption = [[BMKWalkingRoutePlanOption alloc] init];
    walkingRoutePlanOption.from = start;
    walkingRoutePlanOption.to = end;
    
    BOOL flag = [_routesearch walkingSearch:walkingRoutePlanOption];
    
    if(flag)
    {
        NSLog(@"步行检索发送成功");
    }
    else
    {
        NSLog(@"步行检索发送失败");
    }

}

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        [_dataSource removeAllObjects];
        
        
        NSArray * routesCount = result.routes;
        BMKTaxiInfo* taxiInfo = result.taxiInfo;
        
//        NSString* _desc;
//        int       _distance;
//        int       _duration;
//        float     _perKMPrice;
//        int       _totalPrice;
        
//        //路线信息
//
        NSMutableArray * lineArr = [[NSMutableArray alloc] init];
        [lineArr addObjectsFromArray:routesCount];
        [_dataSource addObject:lineArr];
        [_dataSource addObject:@[taxiInfo]];
        [_tableView reloadData];
        
    }else
    {
//        BMK_OPEN_NO_ERROR = 0,///<正常
//        BMK_OPEN_WEB_MAP,///打开的是web地图
//        BMK_OPEN_OPTION_NULL,///<传入的参数为空
//        BMK_OPEN_NOT_SUPPORT,///<没有安装百度地图，或者版本太低
//        BMK_OPEN_POI_DETAIL_UID_NULL,///<poi详情 poiUid为空
//        BMK_OPEN_POI_NEARBY_KEYWORD_NULL,///<poi周边 keyWord为空
//        BMK_OPEN_ROUTE_START_ERROR,///<路线起点有误
//        BMK_OPEN_ROUTE_END_ERROR,///<路线终点有误
        
        switch (error) {
            case BMK_OPEN_WEB_MAP:
                NSLog(@"打开的是web地图");
                break;
            case BMK_OPEN_OPTION_NULL:
                NSLog(@"传入的参数为空");
                break;
            case BMK_OPEN_NOT_SUPPORT:
                NSLog(@"没有安装百度地图，或者版本太低");
                break;
            case BMK_OPEN_POI_DETAIL_UID_NULL:
                NSLog(@"poi详情 poiUid为空");
                break;
            case BMK_OPEN_POI_NEARBY_KEYWORD_NULL:
                NSLog(@"poi周边 keyWord为空");
                break;
            case BMK_OPEN_ROUTE_START_ERROR:
                NSLog(@"路线起点有误");
                break;
            case BMK_OPEN_ROUTE_END_ERROR:
                NSLog(@"路线终点有误");
                break;
            default:
                break;
        }
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
      if (error == BMK_SEARCH_NO_ERROR) {
          
          [_dataSource removeAllObjects];
          NSArray * routesCount = result.routes;
          
          NSLog(@"么有错误   ------- 共有方案数为 %ld", routesCount.count);
          NSMutableArray * lineArr = [[NSMutableArray alloc] init];
          [lineArr addObjectsFromArray:routesCount];
          [_dataSource addObject:lineArr];
//          [_dataSource addObject:@[taxiInfo]];
          [_tableView reloadData];
//          for (BMKDrivingRouteLine * line in routesCount) {
//              
//          }
//          NSLog(@"")

      }else
      {
          NSLog(@"驾车路线查找失败");
          switch (error) {
              case BMK_OPEN_WEB_MAP:
                  NSLog(@"打开的是web地图");
                  break;
              case BMK_OPEN_OPTION_NULL:
                  NSLog(@"传入的参数为空");
                  break;
              case BMK_OPEN_NOT_SUPPORT:
                  NSLog(@"没有安装百度地图，或者版本太低");
                  break;
              case BMK_OPEN_POI_DETAIL_UID_NULL:
                  NSLog(@"poi详情 poiUid为空");
                  break;
              case BMK_OPEN_POI_NEARBY_KEYWORD_NULL:
                  NSLog(@"poi周边 keyWord为空");
                  break;
              case BMK_OPEN_ROUTE_START_ERROR:
                  NSLog(@"路线起点有误");
                  break;
              case BMK_OPEN_ROUTE_END_ERROR:
                  NSLog(@"路线终点有误");
                  break;
              default:
                  break;
          }

      }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        [_dataSource removeAllObjects];
        
        BMKTaxiInfo*        _taxiInfo = result.taxiInfo;
        BMKSuggestAddrInfo* _suggestAddrResult = result.suggestAddrResult;

        NSArray * routes = result.routes;
        
        //数据源中添加数据
        NSMutableArray * lineArr = [[NSMutableArray alloc] init];
        [lineArr addObjectsFromArray:routes];
        [_dataSource addObject:lineArr];
        [_tableView reloadData];
        
        NSLog(@"么有错误   ------- 共有方案数为 %ld", routes.count);
        
//        NSString* _desc;
//        int       _distance;
//        int       _duration;
//        float     _perKMPrice;
//        int       _totalPrice;
        NSLog(@"%@ %d %d %f %d",_taxiInfo.desc,_taxiInfo.distance,_taxiInfo.duration,_taxiInfo.perKMPrice,_taxiInfo.totalPrice);
        
//        NSArray* _startPoiList;
//        NSArray* _endPoiList;
//        NSArray* _startCityList;
//        NSArray* _endCityList;
//        NSArray* _wayPointsPoiList;
//        NSArray* _wayPointsCityList;
        
        NSLog(@"%ld %ld %ld %ld %ld %ld",_suggestAddrResult.startPoiList.count,_suggestAddrResult.endPoiList.count,_suggestAddrResult.startCityList.count,_suggestAddrResult.endCityList.count,_suggestAddrResult.wayPointPoiList.count,_suggestAddrResult.wayPointCityList.count);
        
        int i = 0;
        for (BMKWalkingRouteLine * line in routes) {
//            int                  _distance;
//            BMKTime*             _duration;
//            BMKRouteNode*        _starting;
//            BMKRouteNode*        _terminal;
//            NSString*            _title;
//            NSArray*             _steps;
            
//            int       _dates;
//            int       _hours;
//            int       _minutes;
//            int       _seconds;
            
            NSLog(@"路线%d",++i);
            NSLog(@"%d %d:%d:%d:%d %@ %@ %@",line.distance,line.duration.dates,line.duration.hours,line.duration.minutes,line.duration.seconds,line.starting.title,line.terminal.title,line.title);
            for (BMKWalkingStep * wStep in line.steps) {
//                int                  _direction;
//                BMKRouteNode*        _entrace;
//                NSString*            _entraceInstruction;
//                BMKRouteNode*        _exit;
//                NSString*            _exitInstruction;
//                NSString*            _instruction;
                NSLog(@"%@ %@-->%@ %@ ++ %@",wStep.entrace.title,wStep.entraceInstruction,wStep.exit.title,wStep.exitInstruction,wStep.instruction);
            }
        }

    }else
    {
        NSLog(@"步行路线查找失败");
        switch (error) {
            case BMK_OPEN_WEB_MAP:
                NSLog(@"打开的是web地图");
                break;
            case BMK_OPEN_OPTION_NULL:
                NSLog(@"传入的参数为空");
                break;
            case BMK_OPEN_NOT_SUPPORT:
                NSLog(@"没有安装百度地图，或者版本太低");
                break;
            case BMK_OPEN_POI_DETAIL_UID_NULL:
                NSLog(@"poi详情 poiUid为空");
                break;
            case BMK_OPEN_POI_NEARBY_KEYWORD_NULL:
                NSLog(@"poi周边 keyWord为空");
                break;
            case BMK_OPEN_ROUTE_START_ERROR:
                NSLog(@"路线起点有误");
                break;
            case BMK_OPEN_ROUTE_END_ERROR:
                NSLog(@"路线终点有误");
                break;
            default:
                break;
        }

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
      return @"路线方案";
    }else if(section == 1)
    {
      return @"打车贴士";
    }
    
    return @"bbn";
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    static NSString * str = nil;
    
    NSString * nibName = nil;
    
    if (_checkType.selectedSegmentIndex ==  0) {
        
        if (indexPath.section == 0) {
            str = @"str01";
            nibName = @"BusRoutsTableViewCell";
        }else if(indexPath.section == 1)
        {
            str = @"str02";
            nibName = @"TaxiInfoTableViewCell";
        }
        
    }else if(_checkType.selectedSegmentIndex == 1)
    {
        if (indexPath.section == 0) {
            str = @"str11";
            nibName = @"WalkRoutsTableViewCell";
        }else if(indexPath.section == 1)
        {
            str = @"str12";
            nibName = @"WalkRoutsTableViewCell";
        }

    }else//驾车
    {
        if (indexPath.section == 0) {
            str = @"str21";
            nibName = @"DriveRoutsTableViewCell";
        }else if(indexPath.section == 1)
        {
            str = @"str22";
            nibName = @"DriveRoutsTableViewCell";
        }

    }
    
    cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:str];
        cell = [tableView dequeueReusableCellWithIdentifier:str];
    }

    
    return cell;
}

//加载cell上得数据
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //将要显示数据
    if (_checkType.selectedSegmentIndex == 0) {
        //公交换乘
        if (indexPath.section == 0) {
            BusRoutsTableViewCell * busRC = (BusRoutsTableViewCell *)cell;
            busRC.RoutNumber.text = [NSString stringWithFormat:@"线路%ld.",indexPath.row + 1];
            
            BMKTransitRouteLine * line = [_dataSource[indexPath.section] objectAtIndex:indexPath.row ];
            NSMutableArray * strArr = [[NSMutableArray alloc] init];
            for (BMKTransitStep * step in line.steps) {
                if (step.stepType != BMK_WAKLING) {
                    [strArr addObject:step.vehicleInfo.title];
                }
            }
            busRC.RoutInfo.text = [strArr componentsJoinedByString:@"(--换乘--)"];
            
        }else
        {
            TaxiInfoTableViewCell * taxiRC = (TaxiInfoTableViewCell *)cell;
            
            BMKTaxiInfo* taxiInfo = [_dataSource[indexPath.section] objectAtIndex:indexPath.row];
            
            //        NSString* _desc;
            //        int       _distance;
            //        int       _duration;
            //        float     _perKMPrice;
            //        int       _totalPrice;
            
            
            taxiRC.taxiInfoLabel.text = [NSString stringWithFormat:@"共%d米 大约%d分钟 平均价格%f元 总价%d元 提醒：%@",taxiInfo.distance,taxiInfo.duration/60,taxiInfo.perKMPrice,taxiInfo.totalPrice,taxiInfo.desc];

        }
        
    }else if(_checkType.selectedSegmentIndex == 1)
    {
        //步行
        
        BMKWalkingRouteLine * WRLine = [[_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        //显示数据
        WalkRoutsTableViewCell * drivCell = (WalkRoutsTableViewCell *)cell;
        drivCell.title.text = [NSString stringWithFormat:@"步行方案%ld",indexPath.row + 1];
        drivCell.detailInfo.text = [NSString stringWithFormat:@"用时约 %d天 %d:%d:%d,约 %d米",WRLine.duration.dates,WRLine.duration.hours,WRLine.duration.minutes,WRLine.duration.seconds,WRLine.distance];

    }else//驾车
    {
//        int                  _distance;
//        BMKTime*             _duration;
//        BMKRouteNode*        _starting;
//        BMKRouteNode*        _terminal;
//        NSString*            _title;
//        NSArray*             _steps;
    
        NSArray * lineArr = [_dataSource objectAtIndex:indexPath.section];
        NSLog(@"======方案%ld========",indexPath.row + 1);
       
            BMKDrivingRouteLine * drRLine = [lineArr objectAtIndex:indexPath.row];
            NSArray * arr = drRLine.steps;
//        int       _dates;
//        int       _hours;
//        int       _minutes;
//        int       _seconds;
         NSLog(@"该方案总体描述：%d米 耗时约%d天%d:%d:%d  %@ %@ %@",drRLine.distance,drRLine.duration.dates,drRLine.duration.hours,drRLine.duration.minutes,drRLine.duration.seconds,drRLine.title,drRLine.starting.title,drRLine.terminal.title);
        
//
//        int                  _direction;
//        BMKRouteNode*        _entrace;
//        NSString*            _entraceInstruction;
//        BMKRouteNode*        _exit;
//        NSString*            _exitInstruction;
//        NSString*            _instruction;
//        int                  _numTurns;
    
        
            for (BMKDrivingStep * dStep in arr) {
                NSArray * traffic = dStep.traffics;
                NSLog(@"路况 %d",dStep.hasTrafficsInfo);
                for (int i = 0; i<traffic.count; i++) {
                    NSLog(@"%d",[[traffic objectAtIndex:i] intValue]);
                }
                NSLog(@"（路段入口的指示信息）%@  （路段出口的指示信息）%@  （路段总体指示信息）%@  （转弯数）%d  (入口信息)%@ (出口信息)%@",dStep.entraceInstruction,dStep.exitInstruction,dStep.instruction,dStep.numTurns,dStep.entrace.title,dStep.exit.title);
            }
        
        //显示数据
        DriveRoutsTableViewCell * drivCell = (DriveRoutsTableViewCell *)cell;
        drivCell.routNumber.text = [NSString stringWithFormat:@"方案%ld",indexPath.row + 1];
        drivCell.detailInfo.text = [NSString stringWithFormat:@"用时约 %d天 %d:%d:%d,约 %d米",drRLine.duration.dates,drRLine.duration.hours,drRLine.duration.minutes,drRLine.duration.seconds,drRLine.distance];
            
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_checkType.selectedSegmentIndex == 0)//公交
    {
        if (indexPath.section == 0) {
            
            RoodDetailViewController * roodDetailC = [[RoodDetailViewController alloc] initWithNibName:@"RoodDetailViewController" bundle:nil];
            roodDetailC.line = [_dataSource[indexPath.section] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:roodDetailC animated:YES];
            
        }

    }else if(_checkType.selectedSegmentIndex == 1)//步行
    {
        
        
        WalkRoadViewController * roodDetailC = [[WalkRoadViewController alloc] initWithNibName:@"WalkRoadViewController" bundle:nil];
        roodDetailC.line = [_dataSource[indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:roodDetailC animated:YES];
        
    }else//驾车
    {
        
        
       DriveRoodDetailViewController * roodDetailC = [[DriveRoodDetailViewController alloc] initWithNibName:@"DriveRoodDetailViewController" bundle:nil];
        roodDetailC.line = [_dataSource[indexPath.section] objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:roodDetailC animated:YES];
    }
    
    
}
@end
