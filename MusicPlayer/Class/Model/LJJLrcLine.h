//
//  LJJLrcLine.h
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/6.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJJLrcLine : NSObject

/* 歌词 */
@property (nonatomic, copy) NSString *text;
/* 歌词对应的时间 ([03:43.92]在雨下的泡沫　一触就破 )*/
@property (nonatomic, assign) NSTimeInterval time;

- (instancetype)initWithLrcLineString:(NSString *)lrcLineString; //对象方法

+ (instancetype)lrcLineString:(NSString *)lrcLineString; //有对象方法就创建一个类方法


@end
