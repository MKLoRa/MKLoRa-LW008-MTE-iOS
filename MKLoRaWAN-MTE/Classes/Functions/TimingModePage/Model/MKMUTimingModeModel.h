//
//  MKMUTimingModeModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKMUSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMUTimingModeTimePointModel : NSObject<mk_mu_timingModeReportingTimePointProtocol>

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0-59
@property (nonatomic, assign)NSInteger minuteGear;

@end

@interface MKMUTimingModeModel : NSObject

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKMUTimingModeTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKMUTimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
