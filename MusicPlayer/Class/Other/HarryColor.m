//
//  HarryColor.m
//  Enesco
//
//  Created by niki on 2019/1/24.
//  Copyright © 2019年 aufree. All rights reserved.
//

#import "HarryColor.h"
#import "UIColor+mrjColor.h"
@implementation HarryColor


+(UIColor*)Color0064E6;
{
    return [UIColor mrjColorWithHexString:@"#0064E6"];
}
+(UIColor*)Color000000{
   return [UIColor mrjColorWithHexString:@"#000000"];
}
+(UIColor*)Color00000080; //黑色半透明」
{
    return [UIColor colorWithHexString:@"#000000" andAlpha:0.6];
}
+(UIColor*)Color999999{
   return [UIColor mrjColorWithHexString:@"#999999"];
}
+(UIColor*)ColorCCCCCC{
     return [UIColor mrjColorWithHexString:@"#CCCCCC"];
}
+(UIColor*)ColorE7E7E7{
    return [UIColor mrjColorWithHexString:@"#E7E7E7"];
}
+(UIColor*)ColorF8F8F8{
    return [UIColor mrjColorWithHexString:@"#F8F8F8"];
}
+(UIColor*)ColorE54767{
    return [UIColor mrjColorWithHexString:@"#E54767"];
}
+(UIColor*)Color38C8A4{
    return [UIColor mrjColorWithHexString:@"#38C8A4"];
}

+(UIColor*)Color3383EB;//蓝色更浅
{
    return [UIColor mrjColorWithHexString:@"#3383EB"];
}

+(UIColor*)Color0064E610; //蓝色半透明
{
   return [UIColor colorWithHexString:@"#0064E6" andAlpha:0.1];
}
+(UIColor*)Color0064E680{
    return [UIColor colorWithHexString:@"#0064E6" andAlpha:0.8];
}

+(UIColor*)ColorFFFFFF80
{
    return [UIColor colorWithHexString:@"#FFFFFF" andAlpha:0.5];
}

+ (UIColor *)ColorFFFFFF
{
    return [UIColor colorWithHexString:@"#FFFFFF" andAlpha:1];
}

+(UIColor*)ColorFC6A88{
     return [UIColor mrjColorWithHexString:@"#FC6A88"];
}

+ (UIColor *)Color6E74A1 {
    return [UIColor mrjColorWithHexString:@"#6E74A1"];
}


+ (UIColor *)Color2A7AE2 {
    return [UIColor mrjColorWithHexString:@"#2A7AE2"];
}

/** 传字符串返回颜色 */
+ (UIColor *)colorWith:(NSString *)color {
    return  [UIColor mrjColorWithHexString:color];
}

@end
