//
//  MKMUVibrationDataModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUVibrationDataModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *vibrationThresholds;

@property (nonatomic, copy)NSString *reportInterval;

@property (nonatomic, copy)NSString *vibrationTimeout;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
