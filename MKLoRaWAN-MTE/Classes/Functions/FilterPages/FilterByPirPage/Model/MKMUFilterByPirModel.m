//
//  MKMUFilterByPirModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUFilterByPirModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@interface MKMUFilterByPirModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUFilterByPirModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Status Error" block:failedBlock];
            return;
        }
        if (![self readDelayStatus]) {
            [self operationFailedBlockWithMsg:@"Read Delay Status Error" block:failedBlock];
            return;
        }
        if (![self readSensorSensitivity]) {
            [self operationFailedBlockWithMsg:@"Read Sensor Sensitivity Error" block:failedBlock];
            return;
        }
        if (![self readDetection]) {
            [self operationFailedBlockWithMsg:@"Read Detection Status Error" block:failedBlock];
            return;
        }
        if (![self readFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Read Filter By Major Error" block:failedBlock];
            return;
        }
        if (![self readFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Read Filter By Minor Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config Filter Status Error" block:failedBlock];
            return;
        }
        if (![self configDelayStatus]) {
            [self operationFailedBlockWithMsg:@"Config Delay Status Error" block:failedBlock];
            return;
        }
        if (![self configSensorSensitivity]) {
            [self operationFailedBlockWithMsg:@"Config Sensor Sensitivity Error" block:failedBlock];
            return;
        }
        if (![self configDetection]) {
            [self operationFailedBlockWithMsg:@"Config Detection Status Error" block:failedBlock];
            return;
        }
        if (![self configFilterMajor]) {
            [self operationFailedBlockWithMsg:@"Config Filter By Major Error" block:failedBlock];
            return;
        }
        if (![self configFilterMinor]) {
            [self operationFailedBlockWithMsg:@"Config Filter By Minor Error" block:failedBlock];
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

- (BOOL)readFilterStatus {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByPirStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterStatus {
    __block BOOL success = NO;
    [MKMUInterface mu_configFilterByPirStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDelayStatus {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByPirDelayResponseStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.delayStatus = [returnData[@"result"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDelayStatus {
    __block BOOL success = NO;
    [MKMUInterface mu_configFilterByPirDelayResponseStatus:self.delayStatus sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSensorSensitivity {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByPirSensorSensitivityWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.sensitivity = [returnData[@"result"][@"sensitivity"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSensorSensitivity {
    __block BOOL success = NO;
    [MKMUInterface mu_configFilterByPirSensorSensitivity:self.sensitivity sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readDetection {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByPirDetectionStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.detection = [returnData[@"result"][@"status"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configDetection {
    __block BOOL success = NO;
    [MKMUInterface mu_configFilterByPirDetectionStatus:self.detection sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}


- (BOOL)readFilterMajor {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByPirMajorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger min = [returnData[@"result"][@"minValue"] integerValue];
        NSInteger max = [returnData[@"result"][@"maxValue"] integerValue];
        
        if (min == 0 && max == 65535) {
            self.minMajor = @"";
            self.maxMajor = @"";
        }else {
            self.minMajor = returnData[@"result"][@"minValue"];
            self.maxMajor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterMajor {
    __block BOOL success = NO;
    NSInteger min = 0;
    NSInteger max = 0;
    if (ValidStr(self.minMajor) && ValidStr(self.maxMajor)) {
        min = [self.minMajor integerValue];
        max = [self.maxMajor integerValue];
    }else {
        max = 65535;
    }
    
    [MKMUInterface mu_configFilterByPirMajorMinValue:min maxValue:max sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFilterMinor {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByPirMinorRangeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSInteger min = [returnData[@"result"][@"minValue"] integerValue];
        NSInteger max = [returnData[@"result"][@"maxValue"] integerValue];
        
        if (min == 0 && max == 65535) {
            self.minMinor = @"";
            self.maxMinor = @"";
        }else {
            self.minMinor = returnData[@"result"][@"minValue"];
            self.maxMinor = returnData[@"result"][@"maxValue"];
        }
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFilterMinor {
    __block BOOL success = NO;
    NSInteger min = 0;
    NSInteger max = 0;
    if (ValidStr(self.minMinor) && ValidStr(self.maxMinor)) {
        min = [self.minMinor integerValue];
        max = [self.maxMinor integerValue];
    }else {
        max = 65535;
    }
    
    [MKMUInterface mu_configFilterByPirMinorMinValue:min maxValue:max sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"filterPirParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (ValidStr(self.minMinor) && !ValidStr(self.maxMinor)) {
        return NO;
    }
    if (!ValidStr(self.minMinor) && ValidStr(self.maxMinor)) {
        return NO;
    }
    if (ValidStr(self.minMinor) && ValidStr(self.maxMinor)) {
        if ([self.minMinor integerValue] < 0 || [self.minMinor integerValue] > 65535) {
            return NO;
        }
        if ([self.maxMinor integerValue] < [self.minMinor integerValue] || [self.maxMinor integerValue] > 65535) {
            return NO;
        }
    }
    
    if (ValidStr(self.minMajor) && !ValidStr(self.maxMajor)) {
        return NO;
    }
    if (!ValidStr(self.minMajor) && ValidStr(self.maxMajor)) {
        return NO;
    }
    if (ValidStr(self.minMajor) && ValidStr(self.maxMajor)) {
        if ([self.minMajor integerValue] < 0 || [self.minMajor integerValue] > 65535) {
            return NO;
        }
        if ([self.maxMajor integerValue] < [self.minMajor integerValue] || [self.maxMajor integerValue] > 65535) {
            return NO;
        }
    }
    
    return YES;
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
        _readQueue = dispatch_queue_create("filterPirQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
