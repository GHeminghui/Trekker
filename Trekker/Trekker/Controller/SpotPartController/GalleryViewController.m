//
//  GalleryViewController.m
//  Trekker
//
//  Created by MS on 15-9-24.
//  Copyright (c) 2015年 hmh. All rights reserved.
//

#import "GalleryViewController.h"

#import "spotGalleryImage.h"
#import "UIImageView+WebCache.h"
#import "FileOwner.h"

#import "ImgeCellCollectionViewCell.h"
#import "UIButton+WebCache.h"
#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface GalleryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    IBOutlet UICollectionView *_collectionView;
    NSMutableArray * _dataSource;
    double de_Width;
    NSMutableDictionary * _paraDic;//请求参数表
    FileOwner * owner;
}
@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];

    _collectionView.showsVerticalScrollIndicator = NO;
    _dataSource = [[NSMutableArray alloc] init];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    de_Width = [[UIScreen mainScreen] bounds].size.width;
     [_collectionView registerNib:[UINib nibWithNibName:@"ImgeCellCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"galleryCell"];
    _paraDic = [[NSMutableDictionary alloc] init];
    owner = [[FileOwner alloc] init];
    [self setUpParaDic];
    
    [self reqestGalleryImgs];
    
    [self setUpPullToRefresh];//设置下拉刷新
}

-(void)setUpParaDic
{
    //初始化参数表
    NSDictionary * dic = @{@"start":@"0",@"count":@"21",@"gallery_mode":@"true"};
    [_paraDic addEntriesFromDictionary:dic];
}

-(void)skanLargImgOnScroll:(NSIndexPath *)indexPath
{
     owner.myView.alpha = 1;
    owner.myView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    [self.view addSubview:owner.myView];
    owner.scroll.delegate = self;
    owner.scroll.showsHorizontalScrollIndicator = NO;
    owner.scroll.showsVerticalScrollIndicator = NO;
    owner.scroll.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    owner.scroll.contentSize = CGSizeMake(WIDTH * _dataSource.count, HEIGHT);
    owner.scroll.contentOffset = CGPointMake(WIDTH * indexPath.row, 0);
    owner.scroll.bounces = NO;
    
    owner.scroll.pagingEnabled = YES;
    NSInteger i = 0;
    
//     ImgeCellCollectionViewCell * cell = (ImgeCellCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    for (spotGalleryImage * imgs in _dataSource) {
        
//        ImgeCellCollectionViewCell * cell = [_collectionView cellForItemAtIndexPath:indexPath];
        

        UIButton * btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImage setImageWithURL:[NSURL URLWithString:imgs.photo]];
        btnImage.tag = ++i;
        btnImage.frame = CGRectMake(WIDTH * (i-1), 0, WIDTH, HEIGHT);
        [owner.scroll addSubview:btnImage];
        [btnImage addTarget:self action:@selector(exitLargImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    spotGalleryImage * imgs = [_dataSource objectAtIndex:indexPath.row];
    owner.title.text = imgs.trip_name;
    owner.ddescription.text = imgs.text;
    owner.time.text = imgs.local_time;

}

-(void)exitLargImage:(id)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    for (int i = 0; i<_dataSource.count; i++) {
        UIView * view = [owner.scroll viewWithTag:i+1];
        [view removeFromSuperview];//移除
    }
    [owner.myView removeFromSuperview];//移除
    }

-(void)reqestGalleryImgs
{
    [_paraDic setValue:[NSString stringWithFormat:@"%ld",_dataSource.count] forKey:@"start"];
    NSLog(@"%ld",_dataSource.count);
    [DownLoadData getSpoteImages:^(id obj, NSError *err) {
        NSArray * items = [obj objectForKey:@"items"];
        for (NSDictionary * dicItem in items) {
            spotGalleryImage * imgs = [[spotGalleryImage alloc] init];
            [imgs setValuesForKeysWithDictionary:dicItem];//kvc
            [_dataSource addObject:imgs];
            
            [_collectionView reloadData];
        }
        
        [_collectionView.footer endRefreshing];//停止刷新
    } andParaDic:_paraDic andtype:[NSString stringWithFormat:@"%ld",self.spot.type] andId:[NSString stringWithFormat:@"%ld",self.spot.iid]];
}

-(void)setUpPullToRefresh
{
    //避免循环引用(即：自己引用自己)
    __weak typeof(self) weakSelf = self;
    
    // 添加传统的上拉刷新
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [_collectionView addLegendFooterWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

}

//刷新请求数据 子类中重写
-(void)loadMoreData
{
    NSLog(@"正在请求刷新");
    [self reqestGalleryImgs];//请求数据
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    NSInteger index = point.x / WIDTH;
    spotGalleryImage * imgs = [_dataSource objectAtIndex:index];
    owner.title.text = imgs.trip_name;
    owner.ddescription.text = imgs.text;
    owner.time.text = imgs.local_time;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((de_Width -20) / 3.0, (de_Width -20) / 3.0);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self skanLargImgOnScroll:indexPath];
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * str = @"galleryCell";
    ImgeCellCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
       NSString * path = [[_dataSource objectAtIndex:indexPath.row] photo_s];
    [cell.imgs setImageWithURL:[NSURL URLWithString:path]];
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
