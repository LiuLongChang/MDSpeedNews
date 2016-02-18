//
//  MDNavigationController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/20.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDNavigationController.h"

#import "UIImage+Category.h"

@interface MDNavigationController ()

@end

@implementation MDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //  导航栏 的默认 设置
    UIImage *image = [UIImage imageWithColor:RGBA_MD(43., 138., 39.,0.90)];
    
    // 导航栏 背景色
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
