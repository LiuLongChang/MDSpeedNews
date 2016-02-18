//
//  PullingRefreshTableView.h
//  PullingTableView
//
//  Created by danal on 3/6/12.If you want use it,please leave my name here
//  Copyright (c) 2012 danal Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDRefreshHeadView.h"

#import "MDRefreshFootView.h"

#import "MDRefreshHeadFootView.h"





@interface LoadingView : UIView {
// @public   UILabel *_stateLabel;
//  @public   UILabel *_dateLabel;
// @public   UIImageView *_arrowView;
//    UIActivityIndicatorView *_activityView;
//    CALayer *_arrow;
    BOOL _loading;
}
@property (nonatomic,getter = isLoading) BOOL loading;    
@property (nonatomic,getter = isAtTop) BOOL atTop;
@property (nonatomic) PRState state;
@property(nonatomic,retain)UILabel *stateLabel;
@property(nonatomic,retain)UILabel *dateLabel;
@property(nonatomic,retain)UIImageView *arrowView;
@property(nonatomic,retain)CALayer *arrow;
@property(nonatomic,retain)UIActivityIndicatorView *activityView;

@property(nonatomic,copy)NSString * emptyDataText;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date;

@end

@protocol PullingRefreshTableViewDelegate;

@interface PullingRefreshTableView : UITableView <UIScrollViewDelegate>{
// @public   MDRefreshHeadView *_headerView;
// @public   MDRefreshFootView *_footerView;
    UILabel *_msgLabel;
    BOOL _loading;
    BOOL _isFooterInAction;
    NSInteger _bottomRow;
}

@property(nonatomic,strong)MDRefreshHeadView *headerView;

@property(nonatomic,strong)MDRefreshFootView *footerView;

@property (assign,nonatomic) id <PullingRefreshTableViewDelegate> pullingDelegate;

@property (nonatomic) BOOL autoScrollToNextPage;
/**
 * 加载完毕 没有更多数据
 */
@property (nonatomic) BOOL reachedTheEnd;
/**
 *
 */
@property (nonatomic,getter = isHeaderOnly) BOOL headerOnly;
/**
 * 网络超时
 */
@property(nonatomic,assign)BOOL netTimeOut;
/**
 * 网络没有链接
 */
@property(nonatomic,assign)BOOL netNotConnect;
/**
 * 是否可以刷新
 */
@property(nonatomic,assign)BOOL canRefresh;
/**
 * 是否可以加载
 */
@property(nonatomic,assign)BOOL canGetMore;

/**
 * 没有头视图
 */
@property(nonatomic,assign)BOOL isClearHead;

/**
 * 没有加载视图
 */
@property(nonatomic,assign)BOOL isClearFoot;

@property(nonatomic,assign)BOOL fitNavigationTransparent;

- (id)initWithFrame:(CGRect)frame pullingDelegate:(id<PullingRefreshTableViewDelegate>)aPullingDelegate style:(UITableViewStyle)style;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;

- (void)tableViewDidFinishedLoading;

- (void)tableViewDidFinishedLoadingWithMessage:(NSString *)msg;

- (void)launchRefreshing;

/**
 *去掉头刷新View
 */
-(void)clearheaderView;

/**
 *去掉底部加载View
 */
-(void)clearFoorView;

/**
 * 手动 设置偏移量
 */
-(void)setContentInsetManual;

/**
 * 设置tableview的便宜量 如果ios7 没有自动设置
 */
-(void)setContentBottomEdgeOffset;

/**
 * 可以进行下拉加载
 */
-(void)canShowFootView;


@end



@protocol PullingRefreshTableViewDelegate <NSObject>

@required
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView;

@optional
//Implement this method if headerOnly is false
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView;
//Implement the follows to set date you want,Or Ignore them to use current date 
- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;




@end



//Usage example
/*
_tableView = [[PullingRefreshTableView alloc] initWithFrame:frame pullingDelegate:aPullingDelegate];
[self.view addSubview:_tableView];
_tableView.autoScrollToNextPage = NO;
_tableView.delegate = self;
_tableView.dataSource = self;
*/