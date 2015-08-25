//
//  NSString+BaseURL.m
//  ShiPanOnline
//
//  Created by Mr.Yang on 14-2-25.
//  Copyright (c) 2014年 Mr.Yang. All rights reserved.
//

#import "NSString+BaseURL.h"
#import "NSString+URLEncoding.h"
#import "NSString+BFExtension.h"
#include <sys/sysctl.h>
#import <sys/utsname.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>

typedef enum {
    NETWORK_TYPE_NONE= 0,
    NETWORK_TYPE_WIFI= 1,
    NETWORK_TYPE_3G= 2,
    NETWORK_TYPE_2G= 3,
    
}NETWORK_TYPE;

@implementation NSString (BaseURL)

//  平台 ios硬件版本号
+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine",NULL, &size, NULL,0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size,NULL, 0);
    NSString*platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    return platform;
}

+ (NSString*)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)wideIpAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

//  判断网络环境
+ (int)dataNetworkTypeFromStatusBar
{
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }

    int netType = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    if (num == nil) {
        netType = NETWORK_TYPE_NONE;
        
    }else{

        int n = [num intValue];
        if (n == 0) {
            netType = NETWORK_TYPE_NONE;
            
        }else if (n == 1){
            netType = NETWORK_TYPE_2G;
            
        }else if (n == 2){
            netType = NETWORK_TYPE_3G;
            
        }else{
            netType = NETWORK_TYPE_WIFI;
        }
    }

    return netType;
}

+ (NSString *)functionName:(NSString *)function paramDic:(NSDictionary *)dic
{
    NSArray *keys = [dic allKeys];
    
    NSString *param = @"";
    for (NSString *key in keys){
        
        NSString *value = HTSTR(@"%@", [dic objectForKey:key]);
        param = [param stringByAppendingString:HTSTR(@"%@=%@", key, value)];
        
        NSInteger index = [keys indexOfObject:key];
        if (index != (keys.count -1)) {
            param = [param stringByAppendingString:@"&"];
        }
    }
    
    return HTSTR(@"%@?%@", function, param);
}

//php 后缀参数拼接
+ (NSString *)functionName:(NSString *)function, ...
{
    va_list args;
    va_start(args, function);
    id tmp;
    id values;
    
    while (TRUE) {
        values = va_arg(args, id);
        if (!values) break;
        
        if ([values isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = [values allKeys];
            for (NSString *key in keys) {
                id value = [values valueForKey:key];
                tmp = HTSTR(@"%@/%@/%@",tmp, key, value);
            }
        }else{
            tmp = HTSTR(@"%@/%@", tmp, values);
        }
    }
    
    va_end(args);
    return tmp;
}

//  拼参数的函数
+ (NSString *)appendFunctionName:(NSString *)function, ...
{
    va_list args;
    va_start(args, function);
    id tmp = function;
    id values;
    
    while (TRUE) {
        values = va_arg(args, id);
        if (!values) break;
        
        if ([values isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = [values allKeys];
            for (NSString *key in keys) {
                id value = [values valueForKey:key];
                tmp = HTSTR(@"%@/%@/%@",tmp, key, value);
            }
        }else{
            tmp = HTSTR(@"%@/%@", tmp, values);
        }
    }
    
    va_end(args);
    return tmp;
}

#pragma mark - 
+ (NSString *)user
{
    return nil;
}


@end
