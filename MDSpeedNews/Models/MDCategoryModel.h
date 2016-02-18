//
//  MDCategoryModel.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/18.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDCategoryModel : NSObject

/**
 *  该 模型 的字典数据
 */
@property(nonatomic,strong)NSDictionary *dic;

/**
 *  分类 id
 */
@property(nonatomic,copy)NSString *tid;
/**
 * 分类 标题
 */
@property(nonatomic,copy)NSString *tname;

/**
 * 初始化 赋值  方法
 */
-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
