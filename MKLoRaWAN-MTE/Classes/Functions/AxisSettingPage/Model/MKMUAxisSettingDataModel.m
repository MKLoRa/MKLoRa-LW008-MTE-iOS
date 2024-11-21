//
//  MKMUAxisSettingDataModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/27.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMUAxisSettingDataModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@interface MKMUAxisSettingDataModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUAxisSettingDataModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readWakeupConditions]) {
            [self operationFailedBlockWithMsg:@"Read Wakeup Conditions Error" block:failedBlock];
            return;
        }
        if (![self readMotionConditions]) {
            [self operationFailedBlockWithMsg:@"Read Motion Conditions Error" block:failedBlock];
            return;
        }
        
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self checkParams]) {
            [self operationFailedBlockWithMsg:@"Opps！Save failed. Please check the input characters and try again." block:failedBlock];
            return;
        }
        if (![self configWakeupConditions]) {
            [self operationFailedBlockWithMsg:@"Config Wakeup Conditions Error" block:failedBlock];
            return;
        }
        if (![self configMotionConditions]) {
            [self operationFailedBlockWithMsg:@"Config Motion Conditions Error" block:failedBlock];
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
- (BOOL)readWakeupConditions {
    __block BOOL success = NO;
    [MKMUInterface mu_readThreeAxisWakeupConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.wakeupThreshold = returnData[@"result"][@"threshold"];
        self.wakeupDuration = returnData[@"result"][@"duration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configWakeupConditions {
    __block BOOL success = NO;
    [MKMUInterface mu_configThreeAxisWakeupConditions:[self.wakeupThreshold integerValue] duration:[self.wakeupDuration integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}
- (BOOL)readMotionConditions {
    __block BOOL success = NO;
    [MKMUInterface mu_readThreeAxisMotionParametersWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.motionThreshold = returnData[@"result"][@"threshold"];
        self.motionDuration = returnData[@"result"][@"duration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMotionConditions {
    __block BOOL success = NO;
    [MKMUInterface mu_configThreeAxisMotionParameters:[self.motionThreshold integerValue] duration:[self.motionDuration integerValue] sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"axisSettingParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)checkParams {
    if (!ValidStr(self.wakeupThreshold) || [self.wakeupThreshold integerValue] < 1 || [self.wakeupThreshold integerValue] > 20) {
        return NO;
    }
    if (!ValidStr(self.wakeupDuration) || [self.wakeupDuration integerValue] < 1 || [self.wakeupDuration integerValue] > 10) {
        return NO;
    }
    if (!ValidStr(self.motionThreshold) || [self.motionThreshold integerValue] < 10 || [self.motionThreshold integerValue] > 250) {
        return NO;
    }
    if (!ValidStr(self.motionDuration) || [self.motionDuration integerValue] < 1 || [self.motionDuration integerValue] > 50) {
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
        _readQueue = dispatch_queue_create("axisSettingQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
