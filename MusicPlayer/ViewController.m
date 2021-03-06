//
//  ViewController.m
//  MusicPlayer
//
//  Created by Andrew on 2019/9/6.
//  Copyright © 2019 余默. All rights reserved.
//

#import "ViewController.h"
#import "YMMainMusicViewController.h"
#import "YMModel.h"
#import <MJExtension.h>

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
    
    [self loadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self loadData].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    YMModel *model = [self loadData][indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YMMainMusicViewController *mainVC = [[YMMainMusicViewController alloc] init];
    mainVC.index = indexPath.row;
    mainVC.musicModels = [self loadData];
    [self.navigationController pushViewController:mainVC animated:YES];
}

- (NSArray *)loadData {
    NSArray *array = @[
                       @{@"name":@"01 Frozen Heart",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/09/02/92EEFCB91D544D53B58D7932D9FCD5CD.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/02/2AFFD6EF59EB4194AE778E55C15CE329.jpg"},
                       @{@"name":@"02 Do You Want to Bulid a Snowman",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/09/02/C091160A63D2414EA1C3CF5FD070EEC6.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/04/B90D26B19F044CDBBAAE6337A82636A3.jpg"},
                       @{@"name":@"05 Let It Go",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/09/02/8E8185D1752D4A42860422A07728127A.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/04/75FE7FE7C88E4AD6BEA4CE427919906B.jpg"},
                       @{@"name":@"第二回：孙悟空潜心学本领",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/10/09/3215ABE9851548A38F32BE5131963CEE.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/04/7A1D4123A9FB4A3FAF3CFB5622B036A7.jpg"},
                       @{@"name":@"第五十二回：碧波潭斩妖取宝贝",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/10/09/05CB5D6BD2A24272B0C273B2FD45990F.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/04/64AD5FE7757F41BCBD6633342901C142.jpg"},
                       @{@"name":@"第三十六回：陈家庄变身救小孩",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/10/09/882B8648A2A843AB90816ED9B2A3A0A9.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/04/9FC76EDC62AA47AD8579DAFB6CAA1EFD.jpg"},
                       @{@"name":@"第一回：石头里生出美猴王",@"url":@"http://resource.harrykid.com/harrykid-file/audio/common/2019/10/09/74AB6FCC2B40455A87ABF27E5DBC5A90.mp3",@"imageUrl":@"http://resource.harrykid.com/harrykid-file/images/album/2019/09/04/43B2B528BEAE4D75ACFB67A1C7533E11.jpg"}
                       ];
    
    NSMutableArray *models = [YMModel mj_objectArrayWithKeyValuesArray:array];
    
    return models;
}

@end
