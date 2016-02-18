//
//  MDSetViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSetViewController.h"

#import "UIImage+Category.h"

// 图片 三方库 缓存类
#import "SDImageCache.h"
// 加载框
#import "MBProgressHUD.h"
// 左右侧栏的三方库
#import "MDYSliderViewController.h"
// 缓存文件 类
#import "MDListCache.h"

@interface MDSetViewController ()
/**
 *  加载 框
 */
@property(nonatomic,strong)MBProgressHUD *progressHUD;

@end

@implementation MDSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    // 点击 事件
    [self.view addGestureRecognizer:tapGes];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self initView];
    [self.view addSubview:self.progressHUD];
}
#pragma mark
-(void)initView
{
    UIView *alphaBlackView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, 0.0, self.view.frame.size.width / 2.0, self.view.frame.size.height)];
    
    alphaBlackView.backgroundColor = RGBA_MD(0., 0., 0., 0.7);
    
    [self.view addSubview:alphaBlackView];
    
    CGFloat topSpace = MDXFrom6(86);
    
    CGFloat leading     = MDXFrom6(55);
    
    CGFloat width         = MDXFrom6(78);
    
    UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(leading, topSpace, width, width)];
    
    [logoIV setImage:[UIImage imageNamed:@"setLogo.png"]];
    
    logoIV.layer.cornerRadius = 20.0f;
    
    logoIV.layer.masksToBounds = YES;
    
    [alphaBlackView addSubview:logoIV];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(logoIV.frame.origin.x, logoIV.frame.origin.y + width + 5, width, 30)];
    
    //NSLog(@"-----**&&&-&-&---*&-----:%@", [[NSBundle mainBundle] infoDictionary]);
    NSDictionary *infoDic =[[NSBundle mainBundle] infoDictionary];
    // 取得 版本号
    NSString *versionNum = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    label.text =  [NSString stringWithFormat:@"新闻 %@",versionNum];
    
    label.textColor = RGB_MD(102., 255., 102.);
    
    label.font = [UIFont systemFontOfSize:MDXFrom6(17.0f)];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = [UIColor clearColor];
    
    [alphaBlackView addSubview:label];
    
    
    CGFloat commentBtY = label.frame.origin.y + label.frame.size.height + MDXFrom6(75);
    
    CGFloat buHeight = MDXFrom6(44.0);
    
    CGFloat buWidht = alphaBlackView.frame.size.width;
    
    for (NSInteger i = 0;  i < 2;  i ++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setFrame:CGRectMake(0, commentBtY, buWidht, buHeight)];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        // 点击时  背景 显示 该 颜色
        [button setBackgroundImage: [UIImage imageWithColor:RGB_MD(0., 102., 253.)] forState:UIControlStateHighlighted];
        
        if (i == 0)
        {
              [button setTitle:@"    应用评分" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"score"] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:@"    清除缓存" forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"cache"] forState:UIControlStateNormal];
        }
      
        button.tag = i + 1;
        
        [alphaBlackView addSubview:button];
        
        commentBtY += buHeight + 10;
    }
}

-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 1)
    {
        NSLog(@"应用评分");
        // 打开 应用评分 界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/su-wen/id1042869875?l=zh&ls=1&mt=8"]];
    }
    else
    {
        // 缓存的单例类
        SDImageCache *sharedCache = [SDImageCache sharedImageCache];
        // 得到 存储的 图片的个数
        NSUInteger numOfImageFiles = [sharedCache getDiskCount];
        // 得到 存储的图片的 总大小
        NSUInteger imageSize = [sharedCache getSize];

        
        
        
        
        
        NSLog(@"%@",NSHomeDirectory());
        
        NSLog(@"已经缓存的图片个数：%ld，总大小：%f",(unsigned long)numOfImageFiles,imageSize / 1024./1024.);
        self.progressHUD.labelText = @"清除中....";
        [self.progressHUD show:YES];
        //清除缓存
        __weak typeof(self)weakS = self;
        
        __block BOOL imagesCleared = NO;
        
        __block BOOL listDataCleared = NO;
        
        //  图片 缓存
        [sharedCache clearDiskOnCompletion:^{
            
            imagesCleared = YES;
            
            if (imagesCleared == YES && listDataCleared ==YES) {
                weakS.progressHUD.labelText = @"清除成功";
                // 0.5 秒后 隐藏
                [weakS.progressHUD hide:YES afterDelay:.5];
            }
        }];
        //  列表 数据的缓存
        [MDListCache clearCacheListData:^{
            
            listDataCleared = YES;
            if (listDataCleared == YES && imagesCleared == YES)
            {
                weakS.progressHUD.labelText = @"清除成功";
                // 0.5 秒后 隐藏
                [weakS.progressHUD hide:YES afterDelay:.5];
            }
        }];
        NSLog(@"清除缓存");
    }
}

-(void)tapGes:(UITapGestureRecognizer *)ges
{
    // 关闭侧边栏
    [[MDYSliderViewController sharedSliderController] closeSideBar];
}

#pragma mark Getter
-(MBProgressHUD *)progressHUD
{
    if (_progressHUD == nil) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        // 添 加 了一个 黑色透明 的渐变的背景
        _progressHUD.dimBackground = YES;
    }
    //保证 加载框 在 最上面
    [self.view bringSubviewToFront:_progressHUD];
    return _progressHUD;
}

@end
