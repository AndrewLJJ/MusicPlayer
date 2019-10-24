//
//  AppDelegate.m
//  MusicPlayer
//
//  Created by 刘家俊 on 17/4/4.
//  Copyright © 2017年 Andrew. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //如果让音乐可以在后台播放还需要设置会话
    //1.获取音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    //2.设置为后台类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //3.激活会话
    [session setActive:YES error:nil];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //因为在控制器里一开始先播放音乐时就开始执行动画，当切换到后台，从新进入app，那么又从重执行一次动画，所以这里用一个标识来判断app是否有节换到后台，从而判断是否要发送通知
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iconViewAnimate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //app是否切换到后台之后从重启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iconViewAnimate"]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LJJIconViewNotification" object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
