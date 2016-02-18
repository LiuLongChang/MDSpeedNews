//
//  MDThreeImagesCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/18.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDThreeImagesCell.h"

#import "UIImageView+WebCache.h"

@implementation MDThreeImagesCell

- (void)awakeFromNib {
    // Initialization code
    
    self.describeLabel.font = [UIFont systemFontOfSize:15.f];
    self.describeLabel.textColor = [UIColor colorWithRed:51.f/255. green:51.0f/255. blue:51.0f/255. alpha:1.0f];
}

-(void)bindDataModel:(MDListModel *)model
{
    if (!model)
    {
        return;
    }
    
    [self.firstImageView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"threeDefault.png"]];
    
    NSString *secondUrlString = [[model.imgextra objectAtIndex:0] objectForKey:@"imgsrc"];
    
    [self.secondImageView sd_setImageWithURL:[NSURL URLWithString:secondUrlString] placeholderImage:[UIImage imageNamed:@"threeDefault.png"]];
    
    NSString *thirdUrlString = [model.imgextra[1] objectForKey:@"imgsrc"];
    
    [self.thirdImageView sd_setImageWithURL:[NSURL URLWithString:thirdUrlString] placeholderImage:[UIImage imageNamed:@"threeDefault.png"]];
    
    self.describeLabel.text = model.title;
    
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
    self.describeLabel.textColor = [UIColor colorWithRed:51.f/255. green:51.0f/255. blue:51.0f/255. alpha:1.0f];
}
// 已读状态
-(void)setCellReadedState
{
    // 已读状态 标题颜色 和 详情Label的颜色一样
    self.describeLabel.textColor =[UIColor colorWithRed:153.0f / 255.f green:153.0f / 255.f blue:153.0f / 255.f alpha:1.0f];
}

@end
