//
//  MKMUIndicatorSettingsModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKMUSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMUIndicatorSettingsModel : NSObject<mk_mu_indicatorSettingsProtocol>

@property (nonatomic, assign)BOOL LowPower;
@property (nonatomic, assign)BOOL NetworkCheck;
@property (nonatomic, assign)BOOL Broadcast;
@property (nonatomic, assign)BOOL InFix;
@property (nonatomic, assign)BOOL FixSuccessful;
@property (nonatomic, assign)BOOL FailToFix;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
