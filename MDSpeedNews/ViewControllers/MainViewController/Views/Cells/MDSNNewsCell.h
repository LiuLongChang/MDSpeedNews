//
//  MDSNNewsCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDListModel.h"

@interface MDSNNewsCell : UITableViewCell

/**
 * 图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

/**
 *  标题 Label
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 * 详情 Label
 */
@property (weak, nonatomic) IBOutlet UILabel *describLabel;
/**
 * 绑定数据Model
 */
-(void)bindDataModel:(MDListModel *)model;

@end
