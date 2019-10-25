//
//  YMMainMusicViewController.m
//  MusicPlayer
//
//  Created by Andrew on 2019/9/6.
//  Copyright © 2019 余默. All rights reserved.
//

#import "YMMainMusicViewController.h"
#import "UIView+YMExtension.h"
#import "HarryColor.h"
#import "YMPhonePlayerViewController.h"
#import "YMEquipPlayerViewController.h"

@interface YMMainMusicViewController () <UIScrollViewDelegate>
{
    NSInteger index;
    CGFloat indicatorView_width;
    CGFloat titleViewH;
}
/* titltView */
@property (nonatomic, weak) UIView *titleView;
/* UIScrollView */
@property (nonatomic, weak) UIScrollView *scrollView;
/* 标题按鑄底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的标题按钮 */
@property (nonatomic, weak) UIButton *selectedTitleButton;

@end

@implementation YMMainMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navBackgroundColor = YMColor(7, 100, 118);

    [self setupTitlView];
    [self setupScrollView];
    [self setupChildViewControllers];
    //默认添加子控制器View
    [self addChildVcView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitle:) name:@"reloadTitle" object:nil];
}

- (void)reloadTitle:(NSNotification *)noti {
    NSDictionary *dict = noti.userInfo;
    NSString *title = dict[@"name"];
    self.gk_navTitle = title;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - titlView
- (void)setupTitlView
{
    CGFloat btnX = SCREEN_WIDTH * 0.05;
    titleViewH = 50;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Height_NavBar, SCREEN_WIDTH, 10)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
    //titleView
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - titleViewH, SCREEN_WIDTH, titleViewH)];
    titleView.backgroundColor = YMColor(5, 82, 95);
    [self.view addSubview:titleView];
    self.titleView = titleView;
    NSArray *arr = @[@"手机播放器",@"设备播放器"];
    
    CGFloat btnH = titleViewH;
    CGFloat btnW = (SCREEN_WIDTH - btnX * 2) / arr.count;
    for (NSInteger i = 0; i < arr.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.ym_x = btnX + btnW * i;
        btn.ym_y = 0;
        btn.ym_width = btnW;
        btn.ym_height = btnH;
        
        NSString *title = [NSString stringWithFormat:@"%@",arr[i]];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = LabelFontRegular(15);
        [btn setTitleColor:YMColorA(138, 178, 185, 1) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        btn.tag = i;
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:btn];
    }
    
    //按钮的选中颜色
    UIButton *firstTileButton = self.titleView.subviews.firstObject;
    
    //底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [firstTileButton titleColorForState:UIControlStateSelected];
    indicatorView.ym_height = 2;
    indicatorView.ym_y = self.titleView.ym_height - indicatorView.ym_height;
    
    //立该根据文字内容计算label的宽度
    [firstTileButton.titleLabel sizeToFit];//计算文字的size
    //    indicatorView.ym_width = firstTileButton.titleLabel.ym_width;
    indicatorView.ym_width = indicatorView_width;
    indicatorView.ym_centerX = firstTileButton.ym_centerX;
    [self.titleView addSubview:indicatorView];
    self.indicatorView = indicatorView;
    
    //默认情况：选中最前面的标题按钮
    firstTileButton.selected = YES;
    self.selectedTitleButton = firstTileButton;
}

#pragma mark - 监听点击
- (void)titleClick:(UIButton *)titleButton
{
    self.selectedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    index = titleButton.tag;//记录按钮选中
    
    //指示器
    [UIView animateWithDuration:0.25 animations:^{
        //计算文字宽度
        self.indicatorView.ym_width = titleButton.titleLabel.ym_width;
        self.indicatorView.ym_centerX = titleButton.ym_centerX;
    }];
    [self titleToolClick:titleButton.tag];
}

#pragma mark - 初始化
//设置scrollView
- (void)setupScrollView
{
    //不允许scrollView调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat scrollViewY = 0;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.ym_x = 0;
    scrollView.ym_y = scrollViewY;
    scrollView.ym_width = SCREEN_WIDTH;
    scrollView.ym_height = SCREEN_HEIGHT - titleViewH;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    scrollView.backgroundColor = [HarryColor colorWith:@"#049AB1"];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //添加所有子控制器的view到scrollview中
    NSUInteger count = self.childViewControllers.count;
    self.scrollView.contentSize = CGSizeMake(count * scrollView.ym_width, 0);
}

- (void)setupChildViewControllers
{
    YMPhonePlayerViewController *phoneVC = [[YMPhonePlayerViewController alloc] init];
    phoneVC.viewHeight = self.scrollView.ym_height;
    phoneVC.index = self.index;
    phoneVC.musicModels = self.musicModels;
    [self addChildViewController:phoneVC];
    
    YMEquipPlayerViewController *equipVC = [[YMEquipPlayerViewController alloc] init];
    equipVC.viewHeight = self.scrollView.ym_height;
    [self addChildViewController:equipVC];
}

#pragma mark - 添加子控制器的view
- (void)addChildVcView
{
    //子控制器的索引
    NSUInteger index = self.scrollView.contentOffset.x / self.scrollView.ym_width;
    //取出子控制器(当用户点击某一个标题按钮的时候，那么这个view就创建出来)
    UIViewController *childVc = self.childViewControllers[index];
    childVc.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:childVc.view];
}

- (void)titleToolClick:(NSInteger)index
{
    //让scrollView滚动对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = index * self.scrollView.ym_width;
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * 在scrollview滚动动画结束时，就会调用这个方法
 *前提：使用setContOffset:animated:或者scrollRecVisble:方法让scollview产生滚动动画
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //添加子控制器
    [self addChildVcView];
}

/**
 * 在scrollView滚动动画结束时，就会调用这个方法
 *前提：人为拖拽scrollView产生的滚动动画
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //选中点击对应的按钮
    NSUInteger index = scrollView.contentOffset.x / scrollView.ym_width;
    UIButton *titleButton = self.titleView.subviews[index];
    [self titleClick:titleButton];
    
    //添加子控制器
    [self addChildVcView];
}

@end
