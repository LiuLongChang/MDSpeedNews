//
//  MDAFHelp.h
//  MDSpeedNews
//
//  Created by Medalands on 15/8/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface MDAFHelp : NSObject
/**
 *  get 请求, 给 每次请求 添加 默认设置
 */
+(AFHTTPRequestOperation *)GET:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 * Post 请求, 给每个 接口 添加 默认设置
 */
+(AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
