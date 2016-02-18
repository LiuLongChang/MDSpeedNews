//
//  MDSNBigRectangleCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNBigRectangleCell.h"

#import "UIImageView+WebCache.h"

@implementation MDSNBigRectangleCell

- (void)awakeFromNib {
    // Initialization code
    
    // 标题
    self.titleLabel.textColor = [UIColor colorWithRed:51./255. green:51./255. blue:51./255. alpha:1.0];
    
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    
    // 详情
    self.describeLabel.textColor = [UIColor colorWithRed:153./255. green:153./255.  blue:153./255.  alpha:1.0f];
    self.describeLabel.font = [UIFont systemFontOfSize:12.0f];
    
}

-(void)bindDataModel:(MDListModel *)model
{
    if (!model)
    {
        return;
    }
    //图片
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"rectDefault.png"]];
    // 标题
    self.titleLabel.text = model.title;
    //描述
    self.describeLabel.text = model.digest;

    if (model.isReaded)
    {
        [self setCellReadedState];
    }
    else
    {// 不写else  复用 Cell 会出错
        [self setCellNomalState];
    }
}

//未读正常状态
-(void)setCellNomalState
{
    self.titleLabel.textColor = [UIColor colorWithRed:51.f/255. green:51.0f/255. blue:51.0f/255. alpha:1.0f];
}
// 已读状态
-(void)setCellReadedState
{
    // 已读状态 标题颜色 和 详情Label的颜色一样
    self.titleLabel.textColor =[UIColor colorWithRed:153.0f / 255.f green:153.0f / 255.f blue:153.0f / 255.f alpha:1.0f];
}

@end
