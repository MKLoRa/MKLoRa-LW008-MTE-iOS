//
//  MKTimeSegmentedTimePeriodModel.h
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2025/5/12.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTimeSegmentedTimePeriodModel : NSObject

/// 0~23
@property (nonatomic, assign)NSInteger startHour;

/// 0-59
@property (nonatomic, assign)NSInteger startMinuteGear;

/// 0~23
@property (nonatomic, assign)NSInteger endHour;

/// 0-59
@property (nonatomic, assign)NSInteger endMinuteGear;

/// Report Interval   30s - 86400s
@property (nonatomic, assign)NSInteger interval;

@end

NS_ASSUME_NONNULL_END
