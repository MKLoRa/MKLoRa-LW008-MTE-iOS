//
//  MKMUSDKDataAdopter.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKMUSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMUSDKDataAdopter : NSObject

+ (NSString *)lorawanRegionString:(mk_mu_loraWanRegion)region;

+ (NSString *)fetchTxPower:(mk_mu_txPower)txPower;

/// 实际值转换为0dBm、4dBm等
/// @param content content
+ (NSString *)fetchTxPowerValueString:(NSString *)content;

+ (NSString *)fetchDataFormatString:(mk_mu_dataFormat)dataType;

/// 过滤的mac列表
/// @param content content
+ (NSArray <NSString *>*)parseFilterMacList:(NSString *)content;

/// 过滤的Adv Name列表
/// @param contentList contentList
+ (NSArray <NSString *>*)parseFilterAdvNameList:(NSArray <NSData *>*)contentList;

/// 过滤的url
/// @param contentList contentList
+ (NSString *)parseFilterUrlContent:(NSArray <NSData *>*)contentList;

/// 将协议中的数值对应到原型中去
/// @param other 协议中的数值
+ (NSString *)parseOtherRelationship:(NSString *)other;

/// 解析Other当前过滤条件列表
/// @param content content
+ (NSArray *)parseOtherFilterConditionList:(NSString *)content;

+ (NSString *)parseOtherRelationshipToCmd:(mk_mu_filterByOther)relationship;

+ (BOOL)isConfirmRawFilterProtocol:(id <mk_mu_BLEFilterRawDataProtocol>)protocol;

+ (NSString *)fetchDeviceModeValue:(mk_mu_deviceMode)deviceMode;

+ (NSArray <NSDictionary *>*)parseTimingModeReportingTimePoint:(NSString *)content;

+ (NSString *)fetchPositioningStrategyCommand:(mk_mu_positioningStrategy)strategy;

+ (NSString *)fetchTimingModeReportingTimePoint:(NSArray <mk_mu_timingModeReportingTimePointProtocol>*)dataList;

+ (NSDictionary *)fetchIndicatorSettings:(NSString *)content;

+ (NSString *)parseIndicatorSettingsCommand:(id <mk_mu_indicatorSettingsProtocol>)protocol;

+ (NSString *)fetchLRPositioningSystemString:(mk_mu_positioningSystem)system;

+ (NSString *)fetchBluetoothFixMechanismString:(mk_mu_bluetoothFixMechanism)priority;

@end

NS_ASSUME_NONNULL_END
