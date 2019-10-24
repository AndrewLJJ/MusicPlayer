//
//  YMLocalCacheInfo.h
//  MusicPlayer
//
//  Created by Andrew on 2019/10/23.
//  Copyright © 2019 余默. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMLocalCacheInfo : NSObject

/** 保存播放模式 */
+ (void)savePlayMode:(NSString *)playMode;
/** 取出播放模式 */
+ (NSInteger)getPlayMode;

@end

NS_ASSUME_NONNULL_END
