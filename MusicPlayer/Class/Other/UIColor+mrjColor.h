//
//  UIColor+mrjColor.h
//  myPrivateCloud
//
//  Created by ZEROLEE on 16/3/31.
//  Copyright © 2016年 laomi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (mrjColor)
/********************* Category Utils **********************/
//根据颜色码取得颜色对象


+(UIColor *)mrjColorWithHexString:(NSString *)stringToConvert;

//根据颜色码和透明度,取得颜色对象
+(UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(float)alpha;

@end
