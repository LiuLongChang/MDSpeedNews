//
//  MDRefreshHeadView.h
//  MDYNewsSon
//
//  Created by Medalands on 15/3/2.
//  Copyright (c) 2015年 MM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDRefreshHeader.h"

@interface MDRefreshHeadView : UIView
{
    BOOL _loading;
}

@property (nonatomic,getter = isLoading) BOOL loading;
@property (nonatomic,assign) PRState state;
@property(nonatomic,strong)UILabel *stateLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIImageView *arrowView;
@property(nonatomic,strong)UIImageView  *activityView;

@property(nonatomic,copy)NSString * emptyDataText;

@property(nonatomic,copy)NSString * dateStoreKey;

- (id)initWithFrame:(CGRect)frame atTop:(BOOL)top;

- (void)updateRefreshDate:(NSDate *)date;

- (void)setState:(PRState)state animated:(BOOL)animated;


@end
