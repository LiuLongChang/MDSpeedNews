//
//  MDSNMainViewController.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNMainViewController.h"
// 左右侧栏 三方库 头文件
#import "MDYSliderViewController.h"

#import "MDSNNewsListView.h"

#import "MDSNScrollVIew.h"

//分类 View
#import "MDCategoryView.h"

// 分类Model
#import "MDCategoryModel.h"

// 编辑栏目 View
#import "MDShowDownView.h"

#import "UIImage+Category.h"
// 缓存
#import "MDListCache.h"

@interface MDSNMainViewController ()

@property(nonatomic,strong)MDSNScrollVIew *mainScrollView;
/**
 * 分类 数组
 */
@property(nonatomic,strong)NSMutableArray *categoryArray;

/**
 *  正在 显示的栏目的Model 数组
 */
@property(nonatomic,strong)NSMutableArray *showingCategoryArray;
/**
 *  可以添加 的栏目的Model 数组
 */
@property(nonatomic,strong)NSMutableArray *canAddCategoryArray;

/**
 * 分类 View
 */
@property(nonatomic,strong)MDCategoryView *categoryView;
/**
 *  编辑栏目View
 */
@property(nonatomic,strong)MDShowDownView *showDownView;

@property(nonatomic,strong)UIView *subViewOfCategoryView;

@end

@implementation MDSNMainViewController
{
    //  初始化 可以显示的分类 总数
    NSUInteger _canShowCategoryNum;
    // 栏目顺序 数量 有没有改变
    BOOL  _isChanged;
}

#pragma mark  ViewController  Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    MDSNNewsListView *currentListView = (MDSNNewsListView *)[self.mainScrollView currentView];
    //  刷新 当前 列表View
    [currentListView pullingDownToRefresh];
    
    
    UIWindow * statusWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [statusWindow setWindowLevel:UIWindowLevelStatusBar + 1];
    [statusWindow setBackgroundColor:[UIColor clearColor]];
    
    UILabel * statusLabel = [[UILabel alloc] initWithFrame:statusWindow.bounds];
    statusLabel.text = @"RSSI:00000000000000000000000";
    statusLabel.textColor = [UIColor blackColor];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.backgroundColor = [UIColor blackColor];
    
    [statusWindow addSubview:statusLabel];
    
    [statusWindow makeKeyAndVisible];
}


#pragma mark View  相关
-(void)initView
{
    
    self.title = @"新闻";
    // 导航 右侧 Button
    [self setRightNavigationButton];
    
    // 取消 滑动View 自动偏移
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    //添加 分类View
    [self.view addSubview:self.categoryView];

    // 添加到 Self.view
    [self.view addSubview:self.mainScrollView];
    
//    [self.view bringSubviewToFront:self.categoryView];
    
    // 栏目 编辑View
    [self.mainScrollView addSubview:self.showDownView];
    
    // 把 超出 自己(categoryView) 显示范围的 截取掉
//    self.categoryView.clipsToBounds = YES;
    
    [self.categoryView addSubview:self.subViewOfCategoryView];
}
//  设置 导航栏 右侧 Button
-(void)setRightNavigationButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setFrame:CGRectMake(0, 0, 25.0, 44.0f)];
    
    [button setImage:[UIImage imageNamed:@"set.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(setAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}
/**
 * 列表View 的公共设置 和 根据model 的设置 ---驼峰命名法
 */
-(MDSNNewsListView *)newsListViewWithFrame:(CGRect)frame   model:(MDCategoryModel *)model
{
    MDSNNewsListView *newsLiseView = [[MDSNNewsListView alloc] initWithFrame:frame];
    
    newsLiseView.tid = model.tid;

    //  跳转代理方法
    __weak typeof(self)weakS = self;
    
    [newsLiseView setPushVCBlock:^(UIViewController * pushVC) {
    
        [weakS.navigationController  pushViewController:pushVC animated:YES];
        
    }];
    
    return newsLiseView;
}

#pragma mark Data 相关
-(void)initData
{
    // 初始化 ，可以显示 十个分类的数据
    _canShowCategoryNum = 15;
    
    // 分类 数组 实例化
    self.categoryArray = [[NSMutableArray alloc] init];
    self.showingCategoryArray = [[NSMutableArray alloc] init];
    self.canAddCategoryArray = [[NSMutableArray alloc] init];
    // 读取 缓存数据
    [self readCategoryCache];
    
    BOOL isReadedCache = NO;
    
    if (_showingCategoryArray.count > 0)
    {
        isReadedCache = YES;
        return;
    }
    
    NSString *pathData = [[NSBundle mainBundle] pathForResource:@"allCategory" ofType:@"txt"];
    
    NSData *data = [NSData dataWithContentsOfFile:pathData];
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
        for (NSDictionary *dic in array)
        {
            NSArray *subArray = [dic objectForKey:@"tList"];
            
            for (NSInteger i = 0; i < subArray.count; i ++)
            {
                NSDictionary *subDic = subArray[i];
                MDCategoryModel *model = [[MDCategoryModel alloc] initWithDictionary:subDic];
                
                if ( _showingCategoryArray.count < _canShowCategoryNum)
                {// 可以显示的栏目分类
                    [_showingCategoryArray addObject:model];
                }
                else
                {//  可以添加的栏目 分类
                    [_canAddCategoryArray addObject:model];
                }
                [self.categoryArray addObject:model];
            }
        }
    
  //    T1348647853363
    
//    NSLog(@"取得%ld个数据",self.categoryArray.count);
}

#pragma mark  点击 跳转 到相应的 栏目
-(void)scrollToCategoryOfIndex:(NSUInteger)index
{
    //  让categoryView 对应 的Button 执行 点击方法
    [self.categoryView clickButtonOfIndex:index];
    // 调用openButton点击 方法，  让 showDownView 隐藏
    [self.categoryView.openButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}
#pragma mark  点击 添加 栏目
-(void)addCategoryOfIndex:(NSUInteger)index
{
    //  记录 改变 状态
    _isChanged = YES;
    
    //添加的栏目的数组 下标
    NSUInteger arrayIndex =  index - 1;
    // 取出 对应 的 栏目 Model
    MDCategoryModel *model = self.canAddCategoryArray[arrayIndex];
    // categoryView 里 最后 添加一个栏目
    [self.categoryView loadButtonWithTitle:model.tname];
    [self.categoryView loadButtonEnd];
    // MDSNScrollView 里 最后 添加 一个列表
    MDSNNewsListView *newsLiseView = [self newsListViewWithFrame:CGRectMake(self.mainScrollView.frame.size.width * arrayIndex, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) model:model];

    //  添到 scrollview上
    // 面向对象语言 的 三大特性，多态，封装，继承
    [_mainScrollView loadView:newsLiseView];
    
    //同步 数据，从canAddCategoryArray 移除，添加到showingCategoryArray
    [self.canAddCategoryArray removeObject:model];
    [self.showingCategoryArray addObject:model];
    
}
#pragma mark   点击 删除 相应 的栏目
-(void)deleteShowingCategoryOfIndex:(NSUInteger)index
{
    //  记录 改变 状态
    _isChanged = YES;
    
    NSLog(@"------删除第%ld个",(unsigned long)index);
    // 先删除 categoryView 里面 对应的 栏目Button
    [self.categoryView deleteButtonOfIndex:index];
    //  然后 删除 MDSNScrollView 里面对应的 栏目 列表
    [self.mainScrollView deleteViewOfIndex:index];
    
    // 同步数据
    MDCategoryModel *model = self.showingCategoryArray[index - 1];
    [self.showingCategoryArray removeObjectAtIndex:index - 1];
    [self.canAddCategoryArray addObject:model];
}

#pragma mark Getter
-(MDCategoryView *)categoryView
{
    if (_categoryView == nil)
    {
        _categoryView = [[MDCategoryView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 43)];
        
        for (MDCategoryModel *model in _showingCategoryArray)
        {
//            //  记录 正在显示的 栏目 Model
//            [self.showingCategoryArray addObject:model];
            
            // 加载 分类的Button
            [_categoryView loadButtonWithTitle:model.tname];
        }
        
            // 加载完Button
        [_categoryView loadButtonEnd];
        __weak typeof(self)weakS = self;
        
        [_categoryView setClickIndex:^(NSUInteger index)
         {
//             NSLog(@"点击了第%ld个分类",index);
             
             [weakS.mainScrollView scrollToViewWithIndex:index];
        }];
        // button 的点击 方法，target 是谁，调用的方法 就是哪个类的，不管 实例化 在哪里
        [_categoryView.openButton addTarget:self action:@selector(openDownView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _categoryView;
}

-(MDSNScrollVIew *)mainScrollView
{
    if (_mainScrollView == nil)
    {
       _mainScrollView = [[MDSNScrollVIew alloc] initWithFrame:CGRectMake(0, 64 + self.categoryView.frame.size.height,self.view.frame.size.width, self.view.frame.size.height - 64.0 - self.categoryView.frame.size.height)];
        // 超出_mainScrollView 显示范围的 截取掉
        _mainScrollView.clipsToBounds = YES;
        
        // 实现 Block
        [_mainScrollView setEndScrollToView:^(UIView * currentView) {
            
            MDSNNewsListView *listView = (MDSNNewsListView *)currentView;
            //  刷新 当前页
            [listView pullingDownToRefresh];
        }];
        
        __weak typeof(self)weakS = self;
        
        [_mainScrollView setScrollToIndex:^(NSUInteger index) {
//            NSLog(@"列表滑到了第%ld个",index);
            // 分类 View 和 列表 显示的 信息 同步
            [weakS.categoryView scrollToCategoryWithIndex:index];
        }];
        // 正在显示 的分类
        for (NSInteger i = 0;  i < _showingCategoryArray.count; i ++)
        {
            // 分类 Model
            MDCategoryModel *model = [_showingCategoryArray objectAtIndex:i];
            MDSNNewsListView *newsLiseView = [self newsListViewWithFrame:CGRectMake(self.mainScrollView.frame.size.width * i, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height) model:model];
            //  添到 scrollview上
            // 面向对象语言 的 三大特性，多态，封装，继承
            [_mainScrollView loadView:newsLiseView];
        }

        [_mainScrollView setScrollViewDidScroll:^(UIScrollView * scrollView) {
            // 分类View 接收 _mainScrollView 的滑动情况
            [weakS.categoryView mainScrollViewDidSroll:scrollView];
            
        }];
        
        
    }
    return _mainScrollView;
}

-(MDShowDownView *)showDownView
{
    if (_showDownView == nil)
    {
        _showDownView  = [[MDShowDownView alloc] initWithFrame:CGRectMake(0, - self.mainScrollView.frame.size.height, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height)];
        
        _showDownView.backgroundColor = RGBA_MD(236, 236, 236, 0.96);
        
        _showDownView.showFrame = CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
        _showDownView.alpha = 0.0f;
        
//        [self.categoryArray objectAtIndex:0];
        //  推荐用的
//        self.categoryArray[0];
        
        // 添加 正在显示 的分类button
        for (MDCategoryModel * model in _showingCategoryArray)
        {
            //  添加 分类 Button
            [_showDownView addShowingCategoryWithTitle:model.tname];
        }
        
        // 添加 点击添加分类 标签 和 scrollView
        [_showDownView addCategoryLabelAndScrollView];
        // 添加 可以点击添加的 分类button
        for (MDCategoryModel *model in _canAddCategoryArray)
        {
              [_showDownView addCanAddCategoryWithTitle:model.tname];
        }
        
        __weak typeof(self)weakS = self;
        // 点击 跳转 到相应 的栏目
        [_showDownView setClickedButtonIndex:^(NSUInteger index) {
            [weakS scrollToCategoryOfIndex:index];
        }];
        // 点击 添加 相应 的栏目
        [_showDownView setClickedAddButtonIndex:^(NSUInteger index) {
            [weakS addCategoryOfIndex:index];
        }];
        // 点击 删除
        [_showDownView setClickedDeleteButtonIndex:^(NSUInteger index) {
            [weakS deleteShowingCategoryOfIndex:index];
        }];
    }
    return _showDownView;
}

-(UIView *)subViewOfCategoryView
{
    if (_subViewOfCategoryView == nil)
    {
        _subViewOfCategoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.categoryView.frame.size.width - 51, self.categoryView.frame.size.height)];
        _subViewOfCategoryView.backgroundColor =[UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, _subViewOfCategoryView.frame.size.height)];
    
        label.font = [UIFont systemFontOfSize:17.0f];
        
        label.textColor = RGB_MD(153.0, 153.0, 153.0);
        
        label.text = @"切换栏目";
        
        [_subViewOfCategoryView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        // 19 * 22
        [button setFrame:CGRectMake(_subViewOfCategoryView.frame.size.width - 40, _subViewOfCategoryView.frame.size.height / 2. - 14.0, 25, 28)];
        
        [button addTarget:self action:@selector(deleteCategoryAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
        [_subViewOfCategoryView addSubview:button];
        
        _subViewOfCategoryView.alpha = 0.0;

        }
    return _subViewOfCategoryView;
}


#pragma mark Button Actions
-(void)openDownView:(UIButton *)button
{
    NSLog(@"展开View");
    
    if (self.showDownView.isAnimating == YES)
    {
        // 正在执行动画，不做处理
        return;
    }
    
    if (button.selected == YES)
    {
        [button setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
        
        button.selected = NO;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _subViewOfCategoryView.alpha = 0.0;
        }];
        
        //  隐藏
        [self.showDownView hide];
        
        if (_isChanged == YES)
        {
            //  去 存储 缓存数据
            [self saveCategoryCache];
        }
    }
    else
    {
        [button setImage:[UIImage imageNamed:@"pull"] forState:UIControlStateNormal];
        
        button.selected = YES;
        //  出现
        [UIView animateWithDuration:.3 animations:^{
            
            _subViewOfCategoryView.alpha = 1.0;

        }];

        //   展 开
        [self.showDownView show];
    }
}

-(void)deleteCategoryAction:(UIButton *)button
{
    [self.showDownView showDeletStatus:button];
    NSLog(@"删除");
}

-(void)setAction:(UIButton *)button
{
    NSLog(@"设置");
    //  显示 设置 界面
    [[MDYSliderViewController sharedSliderController] showRightViewController];
}

-(void)saveCategoryCache
{
    //正在显示 的栏目 数据
    NSMutableArray *showingArray = [NSMutableArray array];
   
    for (MDCategoryModel *model in _showingCategoryArray)
    {
        [showingArray addObject:model.dic];
    }
    //存储数据
    
    //  可以添加的栏目数据
    NSMutableArray *canAddArray = [NSMutableArray array];
    for (MDCategoryModel *model  in _canAddCategoryArray)
    {
        [canAddArray addObject:model.dic];
    }
    //存储数据
    NSDictionary *dic = @{@"show":showingArray,@"canAdd":canAddArray};
    
    [MDListCache setObjectOfDic:dic key:@"MDMedalandsCategory"];
}

-(void)readCategoryCache
{
    NSDictionary *dic = [MDListCache cacheDicForKey:@"MDMedalandsCategory"];
    if (dic == nil)
    {
        // 没有缓存数据
        return;
    }
    
    NSArray *showArray = [dic objectForKey:@"show"];
    for (NSDictionary *dic in showArray)
    {
        MDCategoryModel *model = [[MDCategoryModel alloc] initWithDictionary:dic];
        //记录缓存数据
        [_showingCategoryArray addObject:model];
    }
    NSArray *canAddArray = [dic objectForKey:@"canAdd"];
    for (NSDictionary * dic in canAddArray)
    {
        MDCategoryModel *model = [[MDCategoryModel alloc] initWithDictionary:dic];
        //记录缓存数据
        [_canAddCategoryArray addObject:model];
    }
}

@end
