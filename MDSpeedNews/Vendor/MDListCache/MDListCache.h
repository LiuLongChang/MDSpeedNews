//
//  MDListCache.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/27.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDListCache : NSObject
/*
 1.   存    数据
 2.   取    数据
 3. 清除  数据
 
 */

/**
 * 存数据
 dic    字典数据
 key   文件名字
 */
+(void)setObjectOfDic:(NSDictionary *)dic key:(NSString *)key;

/**
 *  取 数据
    key  文件 名字
 */
+(NSDictionary *)cacheDicForKey:(NSString *)key;

/**
 *  清除 数据,清除 成功 回调 block :completion
 */
+(void)clearCacheListData:(void(^)())completion;


@end
