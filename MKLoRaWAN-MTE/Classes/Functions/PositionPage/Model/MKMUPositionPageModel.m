//
//  MKMUPositionPageModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUPositionPageModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@interface MKMUPositionPageModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUPositionPageModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readOfflineFix]) {
            [self operationFailedBlockWithMsg:@"Read Offline Fix Error" block:failedBlock];
            return;
        }
        if (![self readGpsLimitUploadStatus]) {
            [self operationFailedBlockWithMsg:@"Read Gps Limit Upload Status Error" block:failedBlock];
            return;
        }
        if (![self readBluetoothFix]) {
            [self operationFailedBlockWithMsg:@"Read Beacon Voltage Report in Bluetooth Fix Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configOffline:(BOOL)offline
             sucBlock:(void (^)(void))sucBlock
          failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configOfflineFix:offline]) {
            [self operationFailedBlockWithMsg:@"Config Offline Fix Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configGpsLimitUploadStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configGpsLimitUploadStatus:isOn]) {
            [self operationFailedBlockWithMsg:@"Config Gps Limit Upload Status Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configBeaconVoltageStatus:(BOOL)isOn
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configBluetoothFix:isOn]) {
            [self operationFailedBlockWithMsg:@"Config Beacon Voltage Report in Bluetooth Fix Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readOfflineFix {
    __block BOOL success = NO;
    [MKMUInterface mu_readOfflineFixStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.offline = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configOfflineFix:(BOOL)offline {
    __block BOOL success = NO;
    [MKMUInterface mu_configOfflineFix:offline sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readGpsLimitUploadStatus {
    __block BOOL success = NO;
    [MKMUInterface mu_readGpsLimitUploadStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.gpsExtremeMode = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGpsLimitUploadStatus:(BOOL)isOn {
    __block BOOL success = NO;
    [MKMUInterface mu_configGpsLimitUploadStatus:isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readBluetoothFix {
    __block BOOL success = NO;
    [MKMUInterface mu_readBeaconVoltageReportInBleFixWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.bleFix = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBluetoothFix:(BOOL)isOn {
    __block BOOL success = NO;
    [MKMUInterface mu_configBeaconVoltageReportInBleFixStatus:isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}



#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"PositioningStrategy"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("PositioningStrategyQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
