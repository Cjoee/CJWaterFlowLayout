//
//  CJWaterFlowlayout.m
//  瀑布流
//
//  Created by cjoe on 15/11/17.
//  Copyright © 2015年 cjoe. All rights reserved.
//

#import "CJWaterFlowlayout.h"
//默认的列数
static const NSUInteger CJDefaultColumnCount = 3;
static const NSUInteger CJDefaultColumnMargain = 10;
static const NSUInteger CJDefaltRowMargain = 10;
//默认的边缘间距
static const UIEdgeInsets CJDefaultEdgeInsets = {0,0,0,0};

@interface CJWaterFlowlayout()

//存放所有的cell布局的属性
@property(nonatomic,strong) NSMutableArray *attrArr;
//存放所有的列当前的高度
@property(nonatomic,strong) NSMutableArray *columnHeights;
//内容的高度
@property(nonatomic, assign) CGFloat contentHeight;

//声明成员变量可使用点语法
- (CGFloat)rowMargain;
- (CGFloat)columnMargain;
- (CGFloat)columnCount;
- (UIEdgeInsets)edgeInsets;

@end

@implementation CJWaterFlowlayout

#pragma mark - 常见方法的实现

- (CGFloat)rowMargain{
    if([self.delegate respondsToSelector:@selector(rowMargainInWaterFlowLayout:)]){
        return [self.delegate rowMargainInWaterFlowLayout:self];
    }else{
        return CJDefaltRowMargain;
    }
}

- (CGFloat)columnCount{
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterFlowLayout:)]) {
        return [self.delegate columnCountInWaterFlowLayout:self];
    }else
        return CJDefaultColumnCount;
}

- (CGFloat)columnMargain{
    if ([self.delegate respondsToSelector:@selector(columnMargainInWaterFlowLayout:)]) {
        return [self.delegate columnMargainInWaterFlowLayout:self];
        
    }else
        return CJDefaultColumnMargain;
}

- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterFlowLayout:)]) {
        return [self.delegate edgeInsetsInWaterFlowLayout:self];
    }else
        return CJDefaultEdgeInsets;
}



#pragma mark - lazy load

//cell属性的数组
- (NSMutableArray *)attrArr{
    if (!_attrArr) {
        _attrArr = [NSMutableArray array];
    }
    return _attrArr;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}

//初始化
- (void)prepareLayout{
   [super prepareLayout];
  
    
    //设置当前的高度为0 
    self.contentHeight = 0;
    
    //清除之前所有的高度
    [self.columnHeights removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
        
    }
    
    
    //清除之前布局的所用属性
    [self.attrArr removeAllObjects];
    //创建每个cell的布局属性
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [self.attrArr addObject:attrs];
    }
}
//
////重写这个方法调用不频繁，前提是流水布局 而不是collectionView
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}


//决定cell的排布
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //由于此方法调用比较频繁  所以 布局的属性不放这里
    return  self.attrArr;

}

//返回indexPath对应的cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //设置collectionView的宽度
    CGFloat collectionW =  self.collectionView.frame.size.width;
    
    //设置布局属性的frame
    CGFloat w = (collectionW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount -1) * self.columnMargain) / self.columnCount;
    
#pragma mark - TODO
    //调用代理方法 返回高度和宽度
//    CGFloat h = 50 + arc4random_uniform(80);
    
    CGFloat h = [self.delegate waterFlowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    // 找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargain);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargain;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    
//    attrs.frame = CGRectMake(arc4random_uniform(300), arc4random_uniform(100), arc4random_uniform(200),arc4random_uniform(200));
    
    //更新最短的那列
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    //记录内容的高度
    CGFloat  columnHeight = [self.columnHeights[destColumn] doubleValue];
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    
    return attrs;

}


- (CGSize)collectionViewContentSize
{
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);

}
@end
