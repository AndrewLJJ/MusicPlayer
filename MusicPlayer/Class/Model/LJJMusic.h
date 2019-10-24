//
//  LJJMusic.h
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJJMusic : NSObject

/* 歌手名 */
@property (nonatomic, copy) NSString *name;
/* 歌名 */
@property (nonatomic, copy) NSString *filename;
/* 歌词文件名 */
@property (nonatomic, copy) NSString *lrcname;
/* 歌手 */
@property (nonatomic, copy) NSString *singer;
/* 歌手头像 */
@property (nonatomic, copy) NSString *singerIcon;
/* 歌手头像 */
@property (nonatomic, copy) NSString *icon;


@end
