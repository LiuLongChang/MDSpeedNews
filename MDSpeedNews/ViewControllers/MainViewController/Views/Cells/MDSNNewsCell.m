//
//  MDSNNewsCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNNewsCell.h"

#import "UIImageView+WebCache.h"

@implementation MDSNNewsCell

- (void)awakeFromNib {
    // Initialization code
    // 标题 属性设置
    self.titleLabel.font = [UIFont systemFontOfSize:15.f];
    self.titleLabel.textColor = [UIColor colorWithRed:51.f/255. green:51.0f/255. blue:51.0f/255. alpha:1.0f];
    
    // 详情 属性 设置
    self.describLabel.textColor = [UIColor colorWithRed:153.0f / 255.f green:153.0f / 255.f blue:153.0f / 255.f alpha:1.0f];
    
    self.describLabel.font = [UIFont systemFontOfSize:12.0f];
    
    // 最多 显示两行
    self.describLabel.numberOfLines = 2;
}

-(void)bindDataModel:(MDListModel *)model
{
    if (!model)
    {
        return;
    }
    // 标题
    self.titleLabel.text = model.title;
    // 描述
    self.describLabel.text = model.digest;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"newsDefault.png"]];
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
