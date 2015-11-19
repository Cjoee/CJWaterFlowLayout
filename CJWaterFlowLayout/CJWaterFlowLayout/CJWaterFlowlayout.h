//
//  CJWaterFlowlayout.h
//  瀑布流
//
//  Created by cjoe on 15/11/17.
//  Copyright © 2015年 cjoe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJWaterFlowlayout;

@protocol CJWaterFlowlayoutDelegate <NSObject>

@required
//代理方法
- (CGFloat)waterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;

@optional
//瀑布流列数
- (CGFloat)columnCountInWaterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout;
//瀑布流列间距
- (CGFloat)columnMargainInWaterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout;
//瀑布流行间距
- (CGFloat)rowMargainInWaterFlowLayout:(CJWaterFlowlayout *)waterFlowLayout;
//瀑布流边距
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(CJWaterFlowlayout *)wateFlowLayout;

@end

@interface CJWaterFlowlayout : UICollectionViewLayout

//代理
@property(nonatomic,weak) id<CJWaterFlowlayoutDelegate> delegate;
@end
