//
//  CateViewController.m
//  Trekker
//
//  Created by MS on 15-9-17.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "CateViewController.h"
#import "CatParameters.h"
#import "DellTableViewCell.h"
#import "CateShopTableViewCell.h"
#import "Shops.h"
#import "Deal.h"
#import "UIImageView+WebCache.h"
#import "MoreDellTableViewCell.h"
#import "CateSaleInfoViewController.h"

@interface CateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * _catDataSource;
    NSMutableArray * _districts ;
    NSArray * _sortArr ;
    
    NSArray * testArray;
    CatParameters * param;
    IBOutlet UITableView *_tableView;
    
    NSMutableArray * _datasource;
}
@end

@implementation CateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"美食街";
    _catDataSource =  [[NSMutableArray alloc] init];
    _districts = [[NSMutableArray alloc] init];
    param = [[CatParameters alloc] init];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _datasource = [[NSMutableArray alloc] init];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self getDataPullDownMen];
}

-(void)setInitValueForRequestPar
{
    //设置默认请参数
    param.city_id = @"100010000";
    param.cat_ids = @"326";
    param.subcat_ids = [[_catDataSource objectAtIndex:0] objectForKey:@"subcat_id"];
    
    param.district_ids = [[_districts objectAtIndex:0] objectForKey:@"id"];
    param.page = @"1";
    param.page_size = @"5";//每页返回5条
    
}

-(void)getDataPullDownMen//下载数据
{
    static int i = 0;
    i = 0;
    [DownLoadData getCategorys:^(id obj, NSError *err) {
        NSArray * categories = [obj objectForKey:@"categories"];
        
        for (NSDictionary * catDic in categories) {
            if ([[catDic objectForKey:@"cat_name"] isEqualToString:@"美食"]) {

               
                NSArray * subcats = [catDic objectForKey:@"subcategories"];
                [_catDataSource addObjectsFromArray:subcats];
                NSMutableArray * mStrArr = [[NSMutableArray alloc] init];
                for (NSDictionary * dic in subcats) {
                    [mStrArr addObject:[dic objectForKey:@"subcat_id"]];
                }
                NSString * mStr = [mStrArr componentsJoinedByString:@","];
                 [_catDataSource insertObject:@{@"subcat_id":mStr,@"subcat_name":@"全部美食"} atIndex:0];
            }
        }
        i++;
        if(i == 2)
        {
            [self addPullDownMenu];
        }
        
    }];
    
    [DownLoadData getdistricts:^(id obj, NSError *err) {
        NSArray * districts = [obj objectForKey:@"districts"];
      
        NSMutableArray * mStrArr = [[NSMutableArray alloc] init];
        for (NSDictionary * district in districts) {
            NSDictionary * dic = @{@"district_name":[district objectForKey:@"district_name"],@"id":[district objectForKey:@"district_id"]};
            [_districts addObject:dic];
            [mStrArr addObject:[district objectForKey:@"district_id"]];
        }
        NSString * mStr = [mStrArr componentsJoinedByString:@","];
        [_districts insertObject:@{@"district_name":@"全城",@"id":mStr} atIndex:0];
        
        i++;
        if(i == 2)
        {
            [self addPullDownMenu];
        }

    }];
    
    
}

-(void)addPullDownMenu
{
    [self setInitValueForRequestPar];
    
    NSMutableArray * cats = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in _catDataSource) {
        [cats addObject:[dic objectForKey:@"subcat_name"]];
    }
    
    NSMutableArray * distrs = [[NSMutableArray alloc] init];
    for (NSDictionary * dic in _districts) {
        [distrs addObject:[dic objectForKey:@"district_name"]];
    }
    testArray = @[cats,distrs];

    MXPullDownMenu *menu = [[MXPullDownMenu alloc] initWithArray:testArray selectedColor:[UIColor greenColor] ];
    menu.delegate = self;
    menu.frame = CGRectMake(0, 64,menu.frame.size.width, menu.frame.size.height);
    [self.view addSubview:menu];
    [self requestForCatData];
}

// 实现代理.
#pragma mark - MXPullDownMenuDelegate

- (void)PullDownMenu:(MXPullDownMenu *)pullDownMenu didSelectRowAtColumn:(NSInteger)column row:(NSInteger)row
{
    if (column == 0) {//更新数据
        
        param.subcat_ids = [[_catDataSource objectAtIndex:row] objectForKey:@"subcat_id"];
        
    }else if(column == 1)
    {
        param.district_ids = [[_districts objectAtIndex:row] objectForKey:@"id"];
    }

    //重新请求数据
    [self requestForCatData];
    
}

//请求美食数据
-(void)requestForCatData
{
    NSLog(@"已经请求一次数据");
//    //需要传入的参数
//    city_id
//    cat_ids
//    subcat_ids
//    
//    district_ids
//    page
//    page_size
//    
//    sort
    NSLog(@"%@",[param retDicParameter]);
    [DownLoadData getShopsLists:^(id obj, NSError *err) {
        
        
        if (obj != nil) {
            [_datasource removeAllObjects];
            NSArray * shp = [[obj objectForKey:@"data"] objectForKey:@"shops"];
            for (NSDictionary * dic in shp) {
                Shops * shop = [[Shops alloc] init];
                shop.shopName = [dic objectForKey:@"shop_name"];
                shop.distance = [dic objectForKey:@"distance"];
                shop.url = [dic objectForKey:@"shop_murl"];
                
                NSLog(@"RTRRRRRR   %@ %@",shop.shopName,shop.distance);
                
                NSArray * deals = [dic objectForKey:@"deals"];
                for (NSDictionary * dicDeal in deals) {
                    Deal * dl = [[Deal alloc] init];
                    dl.imagurl = [dicDeal objectForKey:@"tiny_image"];
                    dl.desc = [dicDeal objectForKey:@"description"];
                    dl.currentPrice = [dicDeal objectForKey:@"current_price"];
                    dl.markPrice = [dicDeal objectForKey:@"market_price"];
                    dl.parameterPrice = [dicDeal objectForKey:@"promotion_price"];
                    dl.saleNum = [dicDeal objectForKey:@"sale_num"];
                    dl.url = [dicDeal objectForKey:@"deal_murl"];
                    if (shop.deals == nil) {
                        shop.deals = [[NSMutableArray alloc] init];
                    }
                    [shop.deals addObject:dl];
                    
                    NSLog(@"++++++++++   %@ ",dl.desc);
                }
                //是否要加载完全 用来实现折叠效果
                if (deals.count > 2) {
                    shop.isLoadAll = NO;
                }else
                {
                    shop.isLoadAll = YES;
                }
                [_datasource addObject:shop];
                
            }
            
          [_tableView reloadData];
        }
        
    } withDicParams:[param retDicParameter]];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _datasource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     Shops * shop = _datasource[section];
    if (!shop.isLoadAll && shop.deals.count > 2) {
        NSLog(@"moremoremore");
        return 4;
    }
    return shop.deals.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    static NSString * str = nil;
    Shops * shp = _datasource[indexPath.section];
    if (indexPath.row == 0) {
        str = @"shops";
        cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            
            [tableView registerNib:[UINib nibWithNibName:@"CateShopTableViewCell" bundle:nil] forCellReuseIdentifier:str];
            cell = [tableView dequeueReusableCellWithIdentifier:str];
        }
    }else
    {
        if (!shp.isLoadAll && indexPath.row == 3) {
            
                str = @"MoreDells";
                cell = [tableView dequeueReusableCellWithIdentifier:str];
                if (!cell) {
                    
                    [tableView registerNib:[UINib nibWithNibName:@"MoreDellTableViewCell" bundle:nil] forCellReuseIdentifier:str];
                    cell = [tableView dequeueReusableCellWithIdentifier:str];
                }
    
        }else
        {
            str = @"dells";
            cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                
                [tableView registerNib:[UINib nibWithNibName:@"DellTableViewCell" bundle:nil] forCellReuseIdentifier:str];
                cell = [tableView dequeueReusableCellWithIdentifier:str];
            }

        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Shops * shp = _datasource[indexPath.section];
    
    if (indexPath.row == 0) {
        return 50;
    }else if(indexPath.row == 3 && !shp.isLoadAll)
    {
        return 30;
    }
    
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
     Shops * shp = _datasource[indexPath.section];
    if (indexPath.row == 0) {
        CateShopTableViewCell * cs = (CateShopTableViewCell *)cell;
        cs.shopName.text = shp.shopName;
//        cs.distance.text = [NSString stringWithFormat:@"<%@米",shp.distance];
        cs.distance.text = @"";
        NSLog(@"section:%ld",indexPath.section);
        NSLog(@"%@ %@",shp.shopName,shp.distance);
    }else
    {
        NSLog(@"row:%ld",indexPath.row - 1);
        
        if (!shp.isLoadAll && indexPath.row == 3) {
            MoreDellTableViewCell * moreC = (MoreDellTableViewCell *)cell;
            NSInteger numMore = shp.deals.count - 2;
//            NSLog(@"%还有-----%ld",moreC.cate)
            [moreC setCatNum:numMore];
            
        }else
        {
        
            DellTableViewCell * dellC = (DellTableViewCell *)cell;
     
            Deal * dl = [shp.deals objectAtIndex:indexPath.row - 1];
    //        
    //        [dellC.img setImageWithURL:[NSURL URLWithString:dl.imagurl] placeholderImage:[UIImage imageNamed:@"holder.png"] options:SDWebImageRetryFailed];
    //        dellC.desc.text = dl.desc;
    //        dellC.currentProice.text =[NSString stringWithFormat:@"%@",dl.currentPrice];
    //        dellC.markPrice.text = [NSString stringWithFormat:@"%@",dl.markPrice];
    //        dellC.promotePrice.text = [NSString stringWithFormat:@"%@",dl.parameterPrice];
    //        dellC.saleNum.text = [NSString stringWithFormat:@"已售%@",dl.saleNum];
            [dellC loadDataFromModel:dl];
            
            NSLog(@"%@ %@ %@ %@ %@ %@ %@",dl.imagurl,dl.desc,dl.currentPrice,dl.currentPrice,dl.markPrice,dl.parameterPrice,dl.saleNum);
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     Shops * shp = _datasource[indexPath.section];

    if (indexPath.row == 0) {
        //跳转到商户
        CateSaleInfoViewController * cateSale = [[CateSaleInfoViewController alloc] initWithNibName:@"CateSaleInfoViewController" bundle:nil];
        [cateSale loadCateInfoWebPage:shp.url];
        [self.navigationController pushViewController:cateSale animated:YES];
    }else
    {
        if (!shp.isLoadAll && indexPath.row == 3) {
            //展开剩余的美食条目
            shp.isLoadAll = YES;
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationTop];
        }else
        {
            //跳转到相应的美食团购界面
            CateSaleInfoViewController * cateSale = [[CateSaleInfoViewController alloc] initWithNibName:@"CateSaleInfoViewController" bundle:nil];
            Deal * dl = shp.deals[indexPath.row - 1];
            [cateSale loadCateInfoWebPage:dl.url];
            [self.navigationController pushViewController:cateSale animated:YES];
        }
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
