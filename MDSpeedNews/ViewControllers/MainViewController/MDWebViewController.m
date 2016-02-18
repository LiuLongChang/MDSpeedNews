//
//  MDWebViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/25.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDWebViewController.h"

//  加载框
#import "MBProgressHUD.h"

#import "AFNetworking.h"

#import "MDHTMLService.h"

#import "MDAFHelp.h"

@interface MDWebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;
/**
 *  加载 框
 */
@property(nonatomic,strong)MBProgressHUD *progressHUD;

@end

@implementation MDWebViewController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"%@",self.urlSring);
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];

    // 左 滑 返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/%@/full.html",self.docid];
    
    __weak typeof(self)weakS = self;
    // 出现 加载框
    [self.progressHUD show:YES];
    
    [MDAFHelp GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //取出来内容字典
        NSDictionary *dic = [responseObject objectForKey:self.docid];
        
        NSString *htmlStirng = [MDHTMLService htmlStringFromDic:dic];
        
        htmlStirng = [htmlStirng stringByReplacingOccurrencesOfString:@"网易" withString:@""];
        
        //  加载 自定义的内容
        [weakS.webView loadHTMLString:htmlStirng baseURL:nil];
        [weakS.progressHUD hide:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // 错误提示
        weakS.progressHUD.labelText = @"加载失败";
        // 0.5秒后 消失
        [weakS.progressHUD hide:YES afterDelay:.5];
    }];
    
//    [self loadRequestWithUrlString:self.urlSring];
}


//去掉特定字符
-(void)replaceString:(NSString*)search searchInMutableStr:(NSMutableString *)str wihtString:(NSString *)repalceStr
{
    NSRange  substr;
    
    substr = [str rangeOfString:search];
    while (substr.location != NSNotFound) {
        [str replaceCharactersInRange:substr withString:repalceStr];
        substr = [str rangeOfString:search];
    }
    
}




#pragma mark  View  相关
-(void)initView
{
    /*
     UIWebView
     这就是 一个 网页，网页 需要一个网址
     
     */
    //实例化 webView
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    // 代理
    self.webView.delegate  = self;
    
    // 是否 根据网页的大小 调整 宽度
    self.webView.scalesPageToFit = YES;
    
    [self.view addSubview:self.webView];
    
    //  加载框
    [self.view addSubview:self.progressHUD];
    

    [self addBackButton];
}

-(void)loadRequestWithUrlString:(NSString *)urlString
{
    if (urlString ==nil)
    {
        return;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    // url转换 成为 请求NSURLRequest
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    // 加载 网址里的数据
    [self.webView loadRequest:request];
}
-(void)addBackButton
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(0, 20, 44, 44);
    button.frame = CGRectMake(0, 20, 20, 44);
    
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
 }
-(void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UIWebView Delegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
//  开始加载 数据
    // 加载框 出现
    self.progressHUD.labelText = @"加载中";
//    self.progressHUD.labelColor 字体颜色
//       self.progressHUD.labelFont 字体大小
    
    [self.progressHUD show:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //加载完毕
    // 加载框 消失
    [self.progressHUD hide:YES];
}


#pragma mark Getter
-(MBProgressHUD *)progressHUD
{
    if (_progressHUD == nil)
    {// 加载框  覆盖 在self.view 上,Frame 是self.view.bounds
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    return _progressHUD;
}


@end
