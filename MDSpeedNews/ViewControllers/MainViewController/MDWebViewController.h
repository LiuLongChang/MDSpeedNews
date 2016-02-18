//
//  MDWebViewController.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/25.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDWebViewController : UIViewController
/**
 *  webView 的网址
 */
@property(nonatomic,copy)NSString *urlSring;
/**
 * 消息 Id
 */
@property(nonatomic,copy)NSString *docid;

@end
