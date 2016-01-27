//
//  MOCNetworkReachabilityManager.h
//  
//
//  Created by 吴仕海 on 4/2/15.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

typedef void(^MOCNetworkReachabilityManagerBlock)();

extern NSString * const moc_network_status_change_notification;

@interface MOCNetworkReachabilityManager : NSObject

+ (void)startMonitor:(NSString *)checkURLString;//网络状态变化均会moc_network_status_change_notification通知
+ (void)startMonitor:(NSString *)checkURLString viaWWAN:(MOCNetworkReachabilityManagerBlock)viaWWANBlock viaWiFi:(MOCNetworkReachabilityManagerBlock)viaWiFiBlock notReachable:(MOCNetworkReachabilityManagerBlock)notReachableBlock;

+ (AFNetworkReachabilityStatus)status;
+ (BOOL)isReachable;

@end
