//
//  MDThreeImagesCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/18.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDListModel.h"

@interface MDThreeImagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

/**
 * 绑定数据 Model
 */
-(void)bindDataModel:(MDListModel *)model;
@end
