//
//  MDImagesViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/25.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDImagesViewController.h"

#import "UIImageView+WebCache.h"

#import "UIImage+Category.h"


@interface MDImagesViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIPageControl *pageContol;

@end

@implementation MDImagesViewController

#pragma mark ViewCycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
// 状态栏 的样式（白字）
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    //  导航栏 的默认 设置
    UIImage *image = [UIImage imageWithColor:[UIColor clearColor]];
    
    // 导航栏 背景色
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //去掉 导航栏 最下面的灰线
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNaviWithColor:[UIColor clearColor]]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 状态栏 样式（默认 黑色）
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //  导航栏 的默认 设置
    UIImage *image = [UIImage imageWithColor:RGBA_MD(43., 138., 39.,0.90)];
    
    // 导航栏 背景色
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    // 导航栏 最下面的线  改为 深灰色
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNaviWithColor:[UIColor darkGrayColor]]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self initData];
    // 左 滑 返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}
#pragma mark View 相关
-(void)initView
{
    // 取消 scrollView自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = RGB_MD(32., 32., 32.);
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = RGB_MD(32., 32., 32.);
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];
    
    self.pageContol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40.0, self.view.frame.size.width, 40.)];
    self.pageContol.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.pageContol];
    
    [self addBackButton];
}
-(void)addBackButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 20, 44, 44);
    button.frame = CGRectMake(0, 20, 20, 44);

    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
       self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return;
    [self.view addSubview:button];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(44, 20, self.view.frame.size.width - 88, 44)];
    
    label.text = self.titleString;
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont boldSystemFontOfSize:17.0f];
    
    [self.view addSubview:label];
    

    
}
-(void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 数据相关
-(void)initData
{
    self.title = self.titleString;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.imagesUrlStringArray.count, self.scrollView.frame.size.height);
    
    for (NSInteger i = 0; i < self.imagesUrlStringArray.count;  i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 200, self.scrollView.frame.size.width, self.scrollView.frame.size.width)];
        
        imageView.center =CGPointMake(imageView.center.x, self.view.center.y);
        // 图片等比例 铺满 imageView
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 超出 imageView 的图片 截掉
        imageView.clipsToBounds = YES;
        
        NSURL *url = [NSURL URLWithString:self.imagesUrlStringArray[i]];
        
        [imageView sd_setImageWithURL:url placeholderImage:nil];
        
        [self.scrollView addSubview:imageView];
    }
    
    self.pageContol.numberOfPages =self.imagesUrlStringArray.count;
}

#pragma mark UIScorllViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate == NO)
    {
        [self endScroll];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self endScroll];
}
-(void)endScroll
{
    self.pageContol.currentPage = (NSUInteger)self.scrollView.contentOffset.x / (NSUInteger)self.scrollView.frame.size.width;
}




@end
