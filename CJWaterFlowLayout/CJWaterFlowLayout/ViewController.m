//
//  ViewController.m
//  瀑布流
//
//  Created by cjoe on 15/11/17.
//  Copyright © 2015年 cjoe. All rights reserved.
//

#import "ViewController.h"
#import "CJWaterFlowlayout.h"
#import "CJCollectionViewCell.h"
#import "CJShop.h"
#import "MJExtension.h"
#import "MJRefresh.h"



static  NSString *  const CJShopId = @"shop";

@interface ViewController ()<UICollectionViewDataSource,CJWaterFlowlayoutDelegate>
@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *shops;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpLayout];
    [self setupRefresh];
    
    
   }

#pragma mark -lazy load

- (NSMutableArray *)shops
{

    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

//设置布局
- (void)setUpLayout
{
    //创建一个流水布局
    CJWaterFlowlayout *layout = [[CJWaterFlowlayout alloc]init];
    
    //布局的时候数据不显示 因为没设置自己的代理导致没有高度  所以frame不显示
    layout.delegate = self;

    //创建collectionview
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    //设置布局背景为白色
    collectionView.backgroundColor = [UIColor whiteColor];
    //设置数据源
    collectionView.dataSource = self;
    
    [self.view addSubview:collectionView];
    
    
    //注册 从xib中创建
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CJCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:CJShopId];
    
    self.collectionView = collectionView;
//    //注册
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CJShopId];
}

//使用MJReresh刷新数据
- (void)setupRefresh
{
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewShops)];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreShops)];
    self.collectionView.footer.hidden = YES;
}


//CGD加载新数据
- (void)loadNewShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [CJShop objectArrayWithFilename:@"1.plist"];
        [self.shops removeAllObjects];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.header endRefreshing];
    });


}

//GCD主线程刷新数据
- (void)loadMoreShops
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *shops = [CJShop objectArrayWithFilename:@"1.plist"];
        [self.shops addObjectsFromArray:shops];
        
        // 刷新数据
        [self.collectionView reloadData];
        
        [self.collectionView.footer endRefreshing];
    });

}


#pragma mark - 实现数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{  //返回50个item；
//    return 50;
    self.collectionView.footer.hidden = self.shops.count == 0;
    return self.shops.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   CJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CJShopId forIndexPath:indexPath];
    
    cell.shop = self.shops[indexPath.item];
    
//
//    cell.backgroundColor = [UIColor orangeColor];
//    NSInteger tag = 10;
//    UILabel *label = (UILabel *)[cell.contentView viewWithTag:tag];
//    if (label == nil) {
//        label = [[UILabel alloc] init];
//        label.tag = tag;
//        [cell.contentView addSubview:label];
//    }
//    label.text = [NSString stringWithFormat:@"%zd",indexPath.item];
//    [label sizeToFit];
//    
    
    
    
    return cell;
}


#pragma mark - 代理的实现
- (CGFloat)waterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    CJShop *shop = self.shops[index];
    return itemWidth * shop.h / shop.w;

}

- (CGFloat)rowMargainInWaterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout
{
    return 20;
}

- (CGFloat)columnCountInWaterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout{
    if (self.shops.count < 50) {
        return 2;
    }else
        return 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(CJWaterFlowlayout *)wateFlowLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
