//
//  CJShop.h
//  瀑布流
//
//  Created by cjoe on 15/11/18.
//  Copyright © 2015年 cjoe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJShop : NSObject

@property(nonatomic,assign) NSInteger w;
@property(nonatomic,assign) NSInteger h;

@property(nonatomic,copy) NSString *img;
@property(nonatomic,strong) NSString *price;

@end
