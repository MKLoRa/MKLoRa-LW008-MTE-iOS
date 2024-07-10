//
//  MKMUOutdoorFixModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/5.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKMUOutdoorFixModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@interface MKMUOutdoorFixModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUOutdoorFixModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readBleInterval]) {
            [self operationFailedBlockWithMsg:@"Read Outdoor BLE Report Interval Error" block:failedBlock];
            return;
        }
        if (![self readGpsInterval]) {
            [self operationFailedBlockWithMsg:@"Read Outdoor GPS Report Interval Error" block:failedBlock];
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
        if (![self configBleInterval]) {
            [self operationFailedBlockWithMsg:@"Config Outdoor BLE Report Interval Error" block:failedBlock];
            return;
        }
        if (![self configGpsInterval]) {
            [self operationFailedBlockWithMsg:@"Config Outdoor GPS Report Interval Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interfae
- (BOOL)readBleInterval {
    __block BOOL success = NO;
    [MKMUInterface mu_readOutdoorBLEReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.bleInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBleInterval {
    __block BOOL success = NO;
    [MKMUInterface mu_configOutdoorBLEReportInterval:[self.bleInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readGpsInterval {
    __block BOOL success = NO;
    [MKMUInterface mu_readOutdoorGPSReportIntervalWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.gpsInterval = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGpsInterval {
    __block BOOL success = NO;
    [MKMUInterface mu_configOutdoorGPSReportInterval:[self.gpsInterval integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"OutdoorFixParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.bleInterval) || [self.bleInterval integerValue] < 1 || [self.bleInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.gpsInterval) || [self.gpsInterval integerValue] < 1 || [self.gpsInterval integerValue] > 14400) {
        return NO;
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
        _readQueue = dispatch_queue_create("OutdoorFixQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
