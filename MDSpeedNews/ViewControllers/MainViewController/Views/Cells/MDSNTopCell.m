//
//  MDSNTopCell.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDSNTopCell.h"

#import "UIImageView+WebCache.h"

@implementation MDSNTopCell

- (void)awakeFromNib
{
    // Initialization code
    self.describeLabel.font = [UIFont systemFontOfSize:17.0f];
    self.describeLabel.textColor = [UIColor whiteColor];
}


-(void)bindDataModel:(MDListModel *)modle
{
    // 判断 Model 的类型
//    if ([modle isKindOfClass:[MDListModel class]])
//    {
//        
//    }
    
    if (modle)
    {
        self.describeLabel.text = [NSString stringWithFormat:@"   %@",modle.title];
        
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:modle.imgsrc] placeholderImage:[UIImage imageNamed:@"topDefault.png"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
