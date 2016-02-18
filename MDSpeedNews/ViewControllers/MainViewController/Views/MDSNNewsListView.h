//
//  MDSNNewsListView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSNNewsListView : UIView

/**
 * 分类 Id
 */
@property(nonatomic,copy)NSString *tid;

/**
 *  代码 启动 下拉刷新的 方法
 */
-(void)pullingDownToRefresh;
/**
 *  跳转 Block传值
 */
@property(nonatomic,copy)void(^pushVCBlock)(UIViewController *);


@end
