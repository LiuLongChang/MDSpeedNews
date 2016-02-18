//
//  MDShowDownView.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/20.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface MDShowDownView : UIView


/**
 *  是否 正在执行动画
 */
@property(nonatomic,assign)BOOL isAnimating;

/**
 *  出现动画时  ，新的Frame
 */
@property(nonatomic,assign)CGRect showFrame;

/**
 *  点击 跳转 到相应 的 栏目，Block, index 从 1 开始
 */
@property(nonatomic,copy)void(^clickedButtonIndex)(NSUInteger index);

/**
 *  点击 删除相应 的 栏目，Block, index 从 1 开始
 */
@property(nonatomic,copy)void(^clickedDeleteButtonIndex)(NSUInteger index);

/**
 *  点击  添加 相应 的 栏目，Block, index 从 1 开始
 */
@property(nonatomic,copy)void(^clickedAddButtonIndex)(NSUInteger index);

/**
 * 隐藏
 */
-(void)hide;
/**
 *  出现
 */
-(void)show;
/**
 * 添加正在显示 的分类button
 */
-(void)addShowingCategoryWithTitle:(NSString *)title;
/**
 *  添加 点击添加分类的 标签 和 下面Button的父View（UIScrollView）
 */
-(void)addCategoryLabelAndScrollView;

/**
 *  添加  可以 添加的 分类Button
 */
-(void)addCanAddCategoryWithTitle:(NSString *)title;

/**
 *  展示 删除的 状态
 */
-(void)showDeletStatus:(UIButton *)button;



//// 测试 数据
//@property(nonatomic,assign)NSInteger testNum;

@end
