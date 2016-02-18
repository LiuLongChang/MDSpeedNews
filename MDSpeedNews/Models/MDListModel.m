//
//  MDListModel.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/18.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDListModel.h"

@implementation MDListModel

// 对 个别 属性 单独赋值
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"template"])
    {
        self.templatee = value;
    }
    else
    {
        [super setValue:value forKey:key];
    }
}



@end
