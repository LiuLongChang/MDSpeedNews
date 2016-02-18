//
//  MDCategoryView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/19.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCategoryView : UIView
/**
 * 点击展开 编辑栏目 View的 button
 */
@property(nonatomic,strong)UIButton *openButton;

/**
 *  向 外部 传出去 点击的 信息（点击了第几个button），index 从 1 开始
 */
@property(nonatomic,copy)void(^clickIndex)(NSUInteger index);

//-(void)loadButton:(UIButton *)button;

/**
 * 根据 Title 去加载Button
 */
-(void)loadButtonWithTitle:(NSString *)title;

/**
 * 初始化 加载完Button 之后，去做 相应的设置
 */
-(void)loadButtonEnd;

/**
 *  尽可能 使  相应的分类 标签 显示 到最中间，index 从1 开始
 */
-(void)scrollToCategoryWithIndex:(NSUInteger)index;
/**
 *  列表 scrollVIew 滑动时  调用
 */
-(void)mainScrollViewDidSroll:(UIScrollView *)scrollView;

/**
 *index 从 1 开始，通过 代码 让 该 button 执行 点击方法
 */
-(void)clickButtonOfIndex:(NSUInteger)index;

/**
 *  根据 index（从1 开始）删除对应的Button
 */
-(void)deleteButtonOfIndex:(NSUInteger)index;


@end
