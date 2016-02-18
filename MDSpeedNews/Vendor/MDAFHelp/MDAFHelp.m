//
//  MDAFHelp.m
//  MDSpeedNews
//
//  Created by Medalands on 15/8/26.
//  Copyright (c) 2015年 Medalands. All rights reserved.
//

#import "MDAFHelp.h"


@implementation MDAFHelp

+(AFHTTPRequestOperation *)GET:(NSString *)URLString
parameters:(id)parameters
success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic =parameters;
    
    if (dic == nil)
    {
        dic = [NSMutableDictionary dictionary];
    }
    // 添加 默认 参数，每个接口 都需要添加
    [dic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"versionKey"];
    
    AFHTTPRequestOperation *requestOperation = [manager GET:URLString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (success)
        {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
        {
            failure(operation,error);
        }
    }];
    
    return requestOperation;
}

+(AFHTTPRequestOperation *)POST:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *dic = parameters;
    if (dic == nil)
    {
        dic = [NSMutableDictionary dictionary];
    }
    // 添加 默认 设置，版本号
    [dic setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"versionKey"];
    
    AFHTTPRequestOperation *requestOperation = [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success)
        {
            success(operation,responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure)
        {
            failure(operation,error);
        }
    }];
    
    return requestOperation;
}

@end
