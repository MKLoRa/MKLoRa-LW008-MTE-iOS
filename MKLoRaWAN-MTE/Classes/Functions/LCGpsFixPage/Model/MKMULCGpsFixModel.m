//
//  MKMULCGpsFixModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMULCGpsFixModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@interface MKMULCGpsFixModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMULCGpsFixModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readPositioningTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Positioning Timeout Error" block:failedBlock];
            return;
        }
        if (![self readPDOP]) {
            [self operationFailedBlockWithMsg:@"Read PDOP Error" block:failedBlock];
            return;
        }
        if (![self readExtrmeMode]) {
            [self operationFailedBlockWithMsg:@"Read Extrme Mode Error" block:failedBlock];
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
        if (![self configPositioningTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Positioning Timeout Error" block:failedBlock];
            return;
        }
        if (![self configPDOP]) {
            [self operationFailedBlockWithMsg:@"Config PDOP Error" block:failedBlock];
            return;
        }
        if (![self configExtrmeMode]) {
            [self operationFailedBlockWithMsg:@"Config Extrme Mode Error" block:failedBlock];
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
- (BOOL)readPositioningTimeout {
    __block BOOL success = NO;
    [MKMUInterface mu_readGPSFixPositioningTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.timeout = returnData[@"result"][@"timeout"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPositioningTimeout {
    __block BOOL success = NO;
    [MKMUInterface mu_configGPSFixPositioningTimeout:[self.timeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPDOP {
    __block BOOL success = NO;
    [MKMUInterface mu_readGPSFixPDOPWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.pdop = returnData[@"result"][@"pdop"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPDOP {
    __block BOOL success = NO;
    [MKMUInterface mu_configGPSFixPDOP:[self.pdop integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readExtrmeMode {
    __block BOOL success = NO;
    [MKMUInterface mu_readGpsLimitUploadStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.extrmeMode = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configExtrmeMode {
    __block BOOL success = NO;
    [MKMUInterface mu_configGpsLimitUploadStatus:self.extrmeMode sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"LCGpsFixParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
//    if (self.advName.length > 16) {
//        return NO;
//    }
//    if (!ValidStr(self.timeout) || [self.timeout integerValue] < 1 || [self.timeout integerValue] > 60) {
//        return NO;
//    }
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
        _readQueue = dispatch_queue_create("LCGpsFixQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
