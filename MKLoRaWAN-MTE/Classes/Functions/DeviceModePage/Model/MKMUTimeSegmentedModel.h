//
//  MKMUTimeSegmentedModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKTimeSegmentedPageProtocol.h"

#import "MKMUSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMUTimeSegmentedTimePeriodModel : MKTimeSegmentedTimePeriodModel<mk_mu_timeSegmentedModeTimePeriodSettingProtocol>
- (void)updateWithModel:(MKTimeSegmentedTimePeriodModel *)model;
@end

@interface MKMUTimeSegmentedModel : NSObject<MKTimeSegmentedPageProtocol>

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 4:BLE&GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKMUTimeSegmentedTimePeriodModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKTimeSegmentedTimePeriodModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
