//
//  SpotViewController.m
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "SpotViewController.h"
#import "SpotViewTableViewCell.h"
#import "SpotProfile.h"
#import "UIImageView+WebCache.h"
#import "SpotViewInfoViewController.h"

@interface SpotViewController ()<UITableViewDataSource,UITableViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    
    IBOutlet UITableView *_tableView;
    NSMutableArray * _dataSource;
    NSMutableDictionary * _paraDic;//请求参数
    BMKLocationService * _locService;//定位服务
    BMKGeoCodeSearch * _searcher;//地址编码检索
}
@end

@implementation SpotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"周边景点";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _dataSource = [[NSMutableArray alloc] init];
    _paraDic = [[NSMutableDictionary alloc] init];
    
    
    //注册成为观察者 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation) name:@"regSuccess" object:nil];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIBarButtonItem * barBtn = [[UIBarButtonItem alloc] initWithTitle:@"我的位置" style: UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem * barBtnFresh = [[UIBarButtonItem alloc] initWithTitle:@"刷新位置" style: UIBarButtonItemStylePlain target:self action:@selector(findYourLocation:)];
    self.navigationItem.leftBarButtonItem = barBtn;
    self.navigationItem.rightBarButtonItem = barBtnFresh;
    self.baseTableView = _tableView;
    
    [self pullToUpdateDataForTableView];//添加下拉刷新
    
    _locService = [[BMKLocationService alloc]init];

}

//设置参数同时请求数据
-(void)setUpLocationForRequestData:(CLLocationCoordinate2D) coordinate
{
    
    //参数基本配置
    NSDictionary * dic = @{@"category":@"11",@"start":@"0",@"count":@"20",@"latitude":[NSString stringWithFormat:@"%lf",coordinate.latitude],@"longitude":[NSString stringWithFormat:@"%lf",coordinate.longitude]};
    //参数初始化
    [_paraDic addEntriesFromDictionary:dic];
    //请求数据
    [self requestSpotListData];
}

-(void)updateLocation
{
    NSLog(@"接收到通知 可以请求位置了");
    [self ensureLocation];//开启定位服务
}
//不用时，设置为空
-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
}

//百度地图定位服务
-(void)ensureLocation
{

    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
}


/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"%s",__func__);
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
     NSLog(@"%s",__func__);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
   
//    //存储获取得位置
    //    //位置返回之后调用反向地址编码
    [_locService stopUserLocationService];
    //初始化参数，请求网络数据
    [self setUpLocationForRequestData:userLocation.location.coordinate];
    
    
    [self reverseGeoCodeSearch:userLocation.location.coordinate];
    NSLog(@"%@",userLocation.subtitle);
    NSLog(@"0000000   ===  %lf,%lf",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
     NSLog(@"%s",__func__);
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"%s",__func__);
}

/**
 *  反向地址编码
 */
-(void)reverseGeoCodeSearch:(CLLocationCoordinate2D) pt
{
    //反向地址编码
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
//    发起反向地理编码检索
//    CLLocationCoordinate2D ptt = (CLLocationCoordinate2D){39.915, 116.404};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
    BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
//    [reverseGeoCodeSearchOption release];
    if(flag)
    {
      NSLog(@"反geo检索发送成功");
      
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"地址解析失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
      NSLog(@"反geo检索发送失败");
    }
}

#pragma --mark BMKGeoCodeSearchDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      BMKAddressComponent* addressDetail = result.addressDetail;
      NSString * city = addressDetail.city;//城市名称
      NSString * province = addressDetail.province;//省
      NSString * district = addressDetail.district;//行政区域
      NSString * streetName = addressDetail.streetName;//街道名称
      NSString * streetNumber = addressDetail.streetNumber;//街道编号
      NSLog(@"%@ %@ %@ %@ %@",province,city,district,streetName,streetNumber);
      self.navigationItem.leftBarButtonItem.title = [NSString stringWithFormat:@"%@",city];
      
      [[NSUserDefaults standardUserDefaults] setObject:city forKey:@"city"];
      
  }
  else {
      NSLog(@"抱歉，未找到结果");
      UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"没有找到地址" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
      [alert show];
  }
}

#pragma --mark 请求网络数据
-(void)requestSpotListData
{
    [_paraDic setObject:[NSString stringWithFormat:@"%ld",(unsigned long)_dataSource.count] forKey:@"start"];
     __weak typeof(self) weakSelf = self;
    if (_dataSource.count == 0) {
        [self showProgressHud];
    }
    [DownLoadData getSpoteList:^(id obj, NSError *err) {
       
        if (obj!= nil) {
//            NSLog(@"%@",obj);
            NSArray * spotList = [obj objectForKey:@"items"];
            for (NSDictionary * spot in spotList) {
                SpotProfile * spt = [[SpotProfile alloc] init];
                [spt setValuesForKeysWithDictionary:spot];//kvc
                [_dataSource addObject:spt];
            }
            [_tableView reloadData];
            NSLog(@"count of Arraty  %ld",_dataSource.count);
        }else
        {
            NSLog(@"%@",err);
        }
        
        //如果还没隐藏 就隐藏进度条
        if (!weakSelf.HUD.isHidden) {
            [weakSelf hiddenProgressHud];//所有数据请求完毕之后，隐藏刷新进度条
        }else
        {
            //停止刷新
            [weakSelf.baseTableView.footer endRefreshing];
        }


    } andParaDic:_paraDic];
    
}

//下拉刷新时触发
-(void)loadMoreData
{
    //请求数据
    [self requestSpotListData];
}


-(void)findYourLocation:(id)sender
{
    //开启定位服务 刷新位置
    [self ensureLocation];
    
    NSLog(@"正在刷新定位");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
//    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"spotcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SpotViewTableViewCell" bundle:nil] forCellReuseIdentifier:str];
        cell = [tableView dequeueReusableCellWithIdentifier:str];
//        cell = [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//tableView添加数据
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotViewTableViewCell * SptCell = (SpotViewTableViewCell *)cell;

    SpotProfile * spot = _dataSource[indexPath.row];
    
    [SptCell setUpCellData:spot];
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpotViewInfoViewController * spotInfo = [[SpotViewInfoViewController alloc] initWithNibName:@"SpotViewInfoViewController" bundle:nil];
    spotInfo.spot = [_dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:spotInfo animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
