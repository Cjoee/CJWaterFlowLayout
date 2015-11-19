//
//  CJCollectionViewCell.m
//  瀑布流
//
//  Created by cjoe on 15/11/18.
//  Copyright © 2015年 cjoe. All rights reserved.
//

#import "CJCollectionViewCell.h"
#import "CJShop.h"
#import "UIImageView+WebCache.h"

@interface CJCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
@implementation CJCollectionViewCell



-(void)setShop:(CJShop *)shop
{
    _shop = shop;
   
    //图片
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"psb"]];
    
//    self.imageV.image = [UIImage imageNamed:@"psb"];
    //价格
    self.priceLabel.text = shop.price;
    

}


@end
