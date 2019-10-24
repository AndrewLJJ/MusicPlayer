//
//  LJJLrcTool.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "LJJLrcTool.h"
#import "LJJLrcLine.h"

@implementation LJJLrcTool

+ (NSArray *)lrcToolWithName:(NSString *)lrcName
{
    //1.获取路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    
    //2.获取歌词
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    //3.转化为歌词数组
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSMutableArray *tempArray = [NSMutableArray array];
    
    for (NSString *lrcLineString in lrcArray) {
        
        /*
         [ti:简单爱]
         [ar:周杰伦]
         [al:范特西]
         [
         */
        
        //4.过滤不需要的字符串
        if ([lrcLineString hasPrefix:@"[ti:"] ||
            [lrcLineString hasPrefix:@"[al:"] ||
            [lrcLineString hasPrefix:@"[ar:"] ||
            ![lrcLineString hasPrefix:@"["]) {
            continue;
        }
        
        //5.将歌词转化成模型
        LJJLrcLine *lrcLine = [LJJLrcLine lrcLineString:lrcLineString];
        [tempArray addObject:lrcLine];
    }
    
    return tempArray;
}

@end
