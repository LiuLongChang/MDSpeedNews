//
//  MDDeleteButton.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/21.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义 一个枚举
typedef NS_ENUM(NSInteger, MDDeleteButtonStatus) {
    MDDeleteButtonStatusNomal = 0,
    MDDeleteButtonStatusNeverDelete,
    MDDeleteButtonStatusCanDelete
};

@interface MDDeleteButton : UIButton
/**
 * 删除状态
 */
@property(nonatomic,assign)MDDeleteButtonStatus deleteStatus;

/**
 *  删除Button
 */
@property(nonatomic,strong)UIButton *smallDeleteButton;

@end
