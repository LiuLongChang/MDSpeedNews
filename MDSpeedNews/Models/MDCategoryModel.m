//
//  MDCategoryModel.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/18.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDCategoryModel.h"

@implementation MDCategoryModel

-(instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self)
    {
        self.dic = dic;
        self.tid = [dic objectForKey:@"tid"];
        self.tname = [dic objectForKey:@"tname"];
    }
    return self;
}

@end
