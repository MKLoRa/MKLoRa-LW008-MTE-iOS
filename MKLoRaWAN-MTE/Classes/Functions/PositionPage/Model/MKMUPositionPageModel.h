//
//  MKMUPositionPageModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUPositionPageModel : NSObject

@property (nonatomic, assign)BOOL offline;

@property (nonatomic, assign)BOOL gpsExtremeMode;

@property (nonatomic, assign)BOOL bleFix;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configOffline:(BOOL)offline
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configGpsLimitUploadStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configBeaconVoltageStatus:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
