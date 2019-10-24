//
//  HarryColor.h
//  Enesco
//
//  Created by niki on 2019/1/24.
//  Copyright © 2019年 aufree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HarryColor : NSObject
/** 蓝色 */
+(UIColor*)Color0064E6;
/** 黑色 */
+(UIColor*)Color000000;
/** 黑色半透明 */
+(UIColor*)Color00000080;
/** 浅黑 */
+(UIColor*)Color999999;
/** 浅灰 */
+(UIColor*)ColorCCCCCC;
/** 更浅灰 */
+(UIColor*)ColorE7E7E7;
 /** 淡白 */
+(UIColor*)ColorF8F8F8;
/** 深红 */
+(UIColor*)ColorE54767;
/** 绿色 */
+(UIColor*)Color38C8A4;
/** 蓝色半透明 */
+(UIColor*)Color0064E680;
/** 蓝色透明的更高的半透明 */
+(UIColor*)Color0064E610;
/** 蓝色更浅 */
+(UIColor*)Color3383EB;
/** 白色带透明 */
+(UIColor*)ColorFFFFFF80;
+ (UIColor *)ColorFFFFFF;
 /** 淡一点的深红 */
+(UIColor*)ColorFC6A88;
+ (UIColor *)Color6E74A1;
+ (UIColor *)Color2A7AE2;

/** 传字符串返回颜色 */
+ (UIColor *)colorWith:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
