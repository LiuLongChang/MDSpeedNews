//
//  MDSNTopCell.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/17.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDListModel.h"

@interface MDSNTopCell : UITableViewCell
/**
 * 铺满 Cell 的大图
 */
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
/**
 * 描述 Label
 */
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

/**
 * 绑定 数据Model
 */
-(void)bindDataModel:(MDListModel *)modle;

@end
