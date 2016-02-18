//
//  MDSNNewsListView.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNNewsListView.h"

#import "PullingRefreshTableView.h"

#import "MDSNTopCell.h"

#import "MDSNNewsCell.h"

#import "MDSNBigRectangleCell.h"

#import "MDThreeImagesCell.h"

#import "AFNetworking.h"

#import "MDListModel.h"

/**
 * 网页 详情页
 */
#import "MDWebViewController.h"
/**
 *   图片 详情页
 */
#import "MDImagesViewController.h"
//AFNetworking 二次封装
#import "MDAFHelp.h"

#import "AppDelegate.h"

#import "MDNewsIdModel.h"

// 缓存类
#import "MDListCache.h"

@interface MDSNNewsListView ()<PullingRefreshTableViewDelegate,UITableViewDelegate,UITableViewDataSource>
/**
 * 列表 TableView
 */
@property(nonatomic,strong)PullingRefreshTableView *listTabelView;
/**
 *  列表 数据 数组
 */
@property(nonatomic,strong)NSMutableArray *dataArray;
/**
 * 上拉  下拉  的 页数， 从 1 开始的
 */
@property(nonatomic,assign)NSUInteger page;

/**
 * 记录 上一次 刷新 成功 时的时间，以秒为单位
 */
@property(nonatomic,assign) CFAbsoluteTime lastRefreshTime;

@end

@implementation MDSNNewsListView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initData];
        
        [self initView];
    }
    return self;
}
#pragma mark 数据相关
// 初始化 数据
-(void)initData
{
    self.dataArray = [[NSMutableArray alloc] init];
    //  初始值 为 1
    self.page = 1;
}
//  刷新 数据
-(void)refreshData
{
    // 设置 请求得到的 内容 格式
    //    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html", nil];
    
    __weak typeof(self)weakS = self;
    
    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/headline/%@/0-20.html",self.tid];
    
    
    [MDAFHelp GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 缓存  每一次 刷新 成功的 数据
        [MDListCache setObjectOfDic:responseObject key:weakS.tid];
        
//        [weakS sdfasfsf];
        
        // 记录 当前时间
        weakS.lastRefreshTime = CFAbsoluteTimeGetCurrent();
        
        //  刷新 请求 成功之后，page 改为第一页 的值
        weakS.page = 1;
        
        //  请求数据成功，清空 原来的数据
        [weakS.dataArray removeAllObjects];
        
        NSArray *array = [responseObject objectForKey:weakS.tid];
        
        for (NSDictionary *dic in  array)
        {
            MDListModel *model = [[MDListModel alloc] initWithDictionay:dic];
            // 判断 已读 未读
            model.isReaded = [weakS isExistDocid:model.docid];
            
            [weakS.dataArray addObject:model];
        }
        //  刷新tableView
        [weakS.listTabelView reloadData];
        // 告诉三方库 数据请求完毕
        [weakS.listTabelView tableViewDidFinishedLoading];
        
        if (weakS.dataArray.count > 0)
        {
            // 可以 进行加载
            [weakS.listTabelView canShowFootView];
        }
        
        // 设置 该属性，表示数据没有到最后可以 加载更多
        weakS.listTabelView.reachedTheEnd = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 动画 加载或者 刷新完毕
        [weakS.listTabelView tableViewDidFinishedLoading];
        // 错误 提示语
        NSString *errorString = nil;
        NSLog(@"请求失败error:%@",[error description]);
        if (error.code == -1009)
        {
            NSLog(@"网络断开连接");
            errorString = @"网络断开连接";
        }
        else if (error.code == -1003 || error.code == -1004)
        {
            NSLog(@"服务器异常");
            errorString =@"服务器异常";
        }
        else if (error.code == -1001)
        {
            NSLog(@"请求超时");
            errorString = @"请求超时,请检查网络后重试";
        }
        else if (error.code == 3848)
        {
            NSLog(@"转换 Json 格式 错误");
            //            errorString = @"网络不给力";
            errorString = @"服务器异常";
        }
        else if(error.code == -1016)
        {
            //  调试 接口 应该解决掉 这个错误
            NSLog(@"请求的内容格式 和 解析是用的方法 步匹配");
            errorString = @"服务器异常";
        }
        else
        {
            //            kCFURLErrorCannotFindHost
            NSLog(@"网络不给力");
            errorString = @"网络不给力";
        }
        //  网络错误 提示框
        [weakS showAlertViewWithMessage:errorString];
    }];
}
// 加载 数据
-(void)loadMoreData
{
    // 页数 加1
    self.page ++;
    // 拼接 接口
    NSString *urlString = [NSString stringWithFormat:@"http://c.3g.163.com/nc/article/headline/%@/%lu-20.html",self.tid,(unsigned long)((self.page - 1) * 20)];
    
    __weak typeof(self)weakS = self;
    
    [MDAFHelp GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //  加载请求成功方法
        [weakS loadMoreDataSuccess:operation responseObject:responseObject];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 该 页 没有请求成功，减去1，下次加载，还请求这一页
        weakS.page --;
        // 动画 加载或者 刷新完毕
        [weakS.listTabelView tableViewDidFinishedLoading];
        
        NSLog(@"请求失败error:%@",[error description]);
        
        // 错误 提示语
        NSString *errorString = nil;
        NSLog(@"请求失败error:%@",[error description]);
        if (error.code == -1009)
        {
            NSLog(@"网络断开连接");
            errorString = @"网络断开连接";
        }
        else if (error.code == -1003 || error.code == -1004)
        {
            NSLog(@"服务器异常");
            errorString =@"服务器异常";
        }
        else if (error.code == -1001)
        {
            NSLog(@"请求超时");
            errorString = @"请求超时,请检查网络后重试";
        }
        else if (error.code == 3848)
        {
            NSLog(@"转换 Json 格式 错误");
            //            errorString = @"网络不给力";
            errorString = @"服务器异常";
        }
        else if(error.code == -1016)
        {
            //  调试 接口 应该解决掉 这个错误
            NSLog(@"请求的内容格式 和 解析是用的方法 步匹配");
            errorString = @"服务器异常";
        }
        else
        {
            //            kCFURLErrorCannotFindHost
            NSLog(@"网络不给力");
            errorString = @"网络不给力";
        }
        //  网络错误 提示框
        [weakS showAlertViewWithMessage:errorString];
        
    }];

    
    
    
    
}
// 加载 更多数据 成功
-(void)loadMoreDataSuccess:(AFHTTPRequestOperation *)operation  responseObject: (id)responseObject
{
    NSArray *array = [responseObject objectForKey:self.tid];
    
    for (NSDictionary *dic in  array)
    {
        MDListModel *model = [[MDListModel alloc] initWithDictionay:dic];
        
        // 判断 已读 未读
        model.isReaded = [self isExistDocid:model.docid];
        
        [self.dataArray addObject:model];
    }
    
    // 刷新 UI
    [self.listTabelView reloadData];
    
    // 告诉三方库 数据请求完毕
    [self.listTabelView tableViewDidFinishedLoading];
    
    // 新 加载的 数据 少于 20条，则表示 没有更多数据
    if (array.count < 10)
    {
        // 设置 三方库 属性
        self.listTabelView.reachedTheEnd = YES;
        
        // 可以直接 禁止 上拉 加载，需要在刷新成功后，解禁上拉加载
        //            [self.listTabelView clearFoorView];
    }

}
-(void)pullingDownToRefresh
{
    // 刷新时间 相差 20分钟以上，才可以自动刷新
    if (CFAbsoluteTimeGetCurrent() - self.lastRefreshTime > 60 * 20)
    {
        // 执行 下拉 刷新
        [self.listTabelView launchRefreshing];
    }
}
//  请求 数据
-(void)requestData
{
//    http://c.3g.163.com/nc/article/headline/T1348647853363/0-20.html
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // 设置 请求得到的 内容 格式
//    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"text/html", nil];
    
    [manager GET:@"http://c.3g.163.com/nc/article/headline/T1348647853363/0-20.html" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *array = [responseObject objectForKey:@"T1348647853363"];
        
        for (NSDictionary *dic in  array)
        {
            MDListModel *model = [[MDListModel alloc] initWithDictionay:dic];
            if (model.templatee.length)
            {
                NSLog(@"**********%@",model.templatee);
            }
            

            [self.dataArray addObject:model];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                NSLog(@"请求失败error:%@",[error description]);
        
    }];
}


#pragma mark View 相关
// 初始化 View
-(void)initView
{
    
    self.listTabelView = [[PullingRefreshTableView alloc] initWithFrame:self.bounds pullingDelegate:self style:UITableViewStylePlain];
    
    // TabelView 设置 代理
    self.listTabelView.delegate = self;
    
    self.listTabelView.dataSource = self;
    
    self.listTabelView.backgroundColor = [UIColor clearColor];
    
    // 去掉 footview 上得 线
    self.listTabelView.tableFooterView = [[UIView alloc] init];
    
    [self addSubview:self.listTabelView];
    
    // 禁止加载
    [self.listTabelView clearFoorView];
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDListModel * model = nil;
    
    if (self.dataArray.count > indexPath.row)
    {
        model = self.dataArray[indexPath.row];
    }

    
    if (indexPath.row == 0)
    {
        // 加载 MDSNTopCell
        static NSString *topIdentifier = @"MDSNTopCell";
        
        MDSNTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topIdentifier];
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MDSNTopCell" owner:self options:nil] lastObject];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell bindDataModel:model];
        
        return cell;
    }
    
    if (model && model.imgType && [model.imgType isEqual:[NSNumber numberWithInt:1]])
    {
        // 加载 MDSNBigRectangleCell
        static NSString *identifier = @"MDSNBigRectangleCell";
        
        MDSNBigRectangleCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MDSNBigRectangleCell" owner:self options:nil] lastObject];
        }
        
        [cell bindDataModel:model];
        
        return cell;
    }
    // 判断 是否 是 三张图片的Cell
    if (model && model.imgextra && model.imgextra.count > 1)
    {
        // 加载MDThreeImagesCell
        static NSString *identifier = @"MDThreeImagesCell";
        
        MDThreeImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MDThreeImagesCell" owner:self options:nil] lastObject];
        }
        
        [cell bindDataModel:model];
        
        return cell;
    }
    
    
    
    static NSString *identifier = @"MDSNNewsCell";
    
    MDSNNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MDSNNewsCell" owner:self options:nil] lastObject];
    }
    [cell bindDataModel:model];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MDListModel *model = nil;
    
    if (self.dataArray.count > indexPath.row)
    {
        model = self.dataArray[indexPath.row];
    }
    
    if (indexPath.row == 0)
    {
        // 利用 不同屏幕 水平方向 的 放大缩小比例 适配 4 5 6 6P，使用竖直方向的比例 需要对 4 做 单独处理
        return MDXFrom6(230);
    }
    
    if (model && model.imgType && [model.imgType isEqual:@(1)])
    {
        //只是 放大 ImageViewe 的高，根据imagView的高 + 其余固定的 高度 ，就是 Cell 的高度
        
        return  55 + MDXFrom6(100);
    }
    
    // 三张图片的cell 的高度,和 加载该cell 的判断条件一样
    if (model && model.imgextra && model.imgextra.count > 1)
    {
        return 34.5 + MDXFrom6(88.5);
    }
    
    
    return 83.f;
}

// 选中 的方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 反选 的方法
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataArray.count > indexPath.row)
    {
        MDListModel *model = self.dataArray[indexPath.row];

        // 判断是否 应该跳往  显示 图片的界面
        if (model && model.imgextra && model.imgextra.count > 1&& model.imgType == nil)
        {
            //跳往显示 图片的 界面
            MDImagesViewController *imagesVC = [[MDImagesViewController alloc] init];
            //标题
            imagesVC.titleString = model.title;
            //图片 数组
            NSMutableArray *imageArray = [NSMutableArray array];
            // 添加 图片 网址字符串
            for (NSDictionary *subDic in model.imgextra)
            {
                [imageArray addObject:[subDic objectForKey:@"imgsrc"]];
            }
            [imageArray addObject:model.imgsrc];
            // 传值
            imagesVC.imagesUrlStringArray = imageArray;
            
            if (self.pushVCBlock)
            {
                self.pushVCBlock(imagesVC);
            }
        }
        else
        {
            if (model.docid)
            {
                MDWebViewController *webVC = [[MDWebViewController alloc] init];
                //            webVC.urlSring = model.url;
                webVC.docid = model.docid;
                webVC.title = model.title;
                //把 webVC 传值 到 视图控制器
                if (self.pushVCBlock)
                {
                    self.pushVCBlock(webVC);
                }
            }
        }
        
        //  存储 消息Id
        [self insertDocid:model.docid];
        // model 设置 为 已读
        model.isReaded = YES;
        // 更新 UI （cell）
        if (indexPath.row != 0)
        {
//            MDThreeImagesCell
//            MDSNNewsCell
            //方法名一样时
//            MDSNBigRectangleCell *cell  = (MDSNBigRectangleCell *)[tableView cellForRowAtIndexPath:indexPath];
//            // 重新 赋值
//            [cell bindDataModel:model];
            //方法名不一样
            UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
//  isMemberOfClass   isKindOfClass 两者 的区别
            if ([cell isKindOfClass:[MDSNBigRectangleCell class]])
            {
                MDSNBigRectangleCell *bigCell = (MDSNBigRectangleCell *)cell;
                [bigCell bindDataModel:model];
            }else if ([cell isKindOfClass:[MDSNNewsCell class]])
            {
                MDSNNewsCell *newsCell = (MDSNNewsCell *)cell;
                [newsCell bindDataModel:model];
            }else if ([cell isKindOfClass:[MDThreeImagesCell class]])
            {
                MDThreeImagesCell *imagesCell = (MDThreeImagesCell *)cell;
                [imagesCell bindDataModel:model];
            }
        }
    }
}

#pragma mark 上拉 下拉 （刷新加载）代理方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 如果 有多个 滑动View 则 需要判断
    if ([scrollView isEqual:self.listTabelView])
    {
        [self.listTabelView tableViewDidScroll:scrollView];
    }
}
// 停止拖拽 的方法
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.listTabelView tableViewDidEndDragging:scrollView];
}

// 刷新 数据的方法
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView
{
    // 允许 刷新
    if (self.listTabelView.canRefresh)
    {
        // 禁止刷新
        self.listTabelView.canRefresh = NO;
        // 禁止 加载
        self.listTabelView.canGetMore = NO;
        // 延迟 0.5 秒 去刷新
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self refreshData];
        });
    }
}

-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView
{
    //允许 加载
    if (self.listTabelView.canGetMore)
    {
        // 禁止加载
        self.listTabelView.canGetMore = NO;
        // 禁止 刷新
        self.listTabelView.canRefresh = NO;
        // 延迟 0.5 秒 去加载
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadMoreData];
        });
    }
}
// 刷新的日期
-(NSDate *)pullingTableViewRefreshingFinishedDate
{
    return [NSDate date];
}

#pragma mark  Setter
-(void)setTid:(NSString *)tid
{// 必须写得 赋值
    _tid = tid;
    
    NSDictionary *dic = [MDListCache cacheDicForKey:tid];
    
    NSArray *array = [dic objectForKey:self.tid];
    
    for (NSDictionary *dic in  array)
    {
        MDListModel *model = [[MDListModel alloc] initWithDictionay:dic];
        // 判断 已读 未读
        model.isReaded = [self isExistDocid:model.docid];
        
        [self.dataArray addObject:model];
    }
}

#pragma mark AlertView
-(void)showAlertViewWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    
    [alertView show];
}
#pragma mark  Core Data
//  查询 消息id 是否存在
-(BOOL)isExistDocid:(NSString *)docid
{
    //  单例对象的单例
    AppDelegate *appDe = [UIApplication sharedApplication].delegate;
    
    NSManagedObjectContext *context = appDe.managedObjectContext;
    //  查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //查询的实例
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"MDNewsIdModel" inManagedObjectContext:context];
    
    
    [request setEntity:entity];
    // 根据 docid 设置 具体 查询条件
    //Cocoa框架中，NSPredicate 用于 查询，原理和方法 都类似于SQL 中得 where，作用 相当于 数据库的过滤器
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"docid  like[cd]  %@",docid];
    //  设置 查询条件
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result.count > 0)
    {
        return YES;
    }
    
    return NO;
}
// 插入新的消息id
-(void)insertDocid:(NSString *)docid
{
    if ([self isExistDocid:docid] == YES)
    {
        return;
    }
    // 插入一条新的数据
    // 取出 单例 对象 的代理
    AppDelegate *appDe = [UIApplication sharedApplication].delegate;
    
    MDNewsIdModel *model = [NSEntityDescription insertNewObjectForEntityForName:@"MDNewsIdModel" inManagedObjectContext:appDe.managedObjectContext];
    
    model.docid = docid;
    //保存
    [appDe saveContext];
}


@end