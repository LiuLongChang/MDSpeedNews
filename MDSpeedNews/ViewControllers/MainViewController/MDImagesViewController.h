//
//  MDImagesViewController.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/25.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDImagesViewController : UIViewController
/**
 *  标题
 */
@property(nonatomic,copy)NSString *titleString;
/**
 * 图片 网址信息
 */
@property(nonatomic,strong)NSMutableArray *imagesUrlStringArray;

@end
