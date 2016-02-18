//
//  MDDeleteButton.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/21.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDDeleteButton.h"

@implementation MDDeleteButton


//+(id)buttonWithType:(UIButtonType)buttonType
//{
//    UIButton *button = [super buttonWithType:buttonType];
//    
//    // 去添加 smallDeleteButton
//    
//    return button;
//}


-(UIButton *)smallDeleteButton
{
    if (_smallDeleteButton == nil)
    {
        _smallDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _smallDeleteButton.frame = CGRectMake(self.frame.size.width - 13, -6, 19., 19.);
        
        [_smallDeleteButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        
        [self addSubview:_smallDeleteButton];
    }
    return _smallDeleteButton;
}

-(void)setDeleteStatus:(MDDeleteButtonStatus)deleteStatus
{
    if (_deleteStatus == MDDeleteButtonStatusNeverDelete) {
        return;
    }
    
    switch (deleteStatus) {
        case MDDeleteButtonStatusNomal:
        {// 隐藏 删除 Button
            self.smallDeleteButton.hidden = YES;
        }
            break;
            case MDDeleteButtonStatusNeverDelete:
        {// 隐藏 删除Button
            self.smallDeleteButton.hidden = YES;
        }
            break;
            case MDDeleteButtonStatusCanDelete:
        {// 显示删除Button，进入可以删除状态
            self.smallDeleteButton.hidden = NO;
        }
            break;
        default:
            break;
    }
    // 赋值
    _deleteStatus = deleteStatus;
}



@end
