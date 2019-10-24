//
//  YMModel.h
//  MusicPlayer
//
//  Created by Andrew on 2019/10/22.
//  Copyright © 2019 余默. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMModel : NSObject

/** 歌名 */
@property (nonatomic, copy) NSString                    *name;
/** url */
@property (nonatomic, copy) NSString                    *url;

@end

NS_ASSUME_NONNULL_END
