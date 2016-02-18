//
//  MDSNBigRectangleCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDListModel.h"

@interface MDSNBigRectangleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

/**
 * 绑定数据Model
 */
-(void)bindDataModel:(MDListModel *)model;

@end
