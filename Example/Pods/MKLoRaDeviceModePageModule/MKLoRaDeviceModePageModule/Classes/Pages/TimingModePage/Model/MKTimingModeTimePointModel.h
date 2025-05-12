//
//  MKTimingModeTimePointModel.h
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2025/5/12.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTimingModeTimePointModel : NSObject

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0-59
@property (nonatomic, assign)NSInteger minuteGear;

@end

NS_ASSUME_NONNULL_END
