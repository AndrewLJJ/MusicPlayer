//
//  YMEquipPlayerViewController.m
//  MusicPlayer
//
//  Created by Andrew on 2019/9/6.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMEquipPlayerViewController.h"
#import "KTGradientView.h"

@interface YMEquipPlayerViewController ()

/** 渐变背景 */
@property (nonatomic, weak) KTGradientView                 *backView;

@end

@implementation YMEquipPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationBar.hidden = YES;
    
    [self initView];
}

#pragma mark - 初始化空间
- (void)initView {
    KTGradientView *backView = [[KTGradientView alloc] initWithFromColor:YMColor(5, 82, 95) toColor:YMColor(7, 100, 118) direction:KTGradientDirectionToTop];
    backView.frame = CGRectMake(0, Height_NavBar, SCREEN_WIDTH, self.viewHeight);
    [self.view addSubview:backView];
    self.backView = backView;
}

@end
