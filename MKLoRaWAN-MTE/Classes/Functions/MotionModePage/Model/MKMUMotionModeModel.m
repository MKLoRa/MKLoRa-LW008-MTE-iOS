//
//  MKMUMotionModeModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMUMotionModeModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"


@interface MKMUMotionModeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUMotionModeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readNotifyEventOnStart]) {
            [self operationFailedBlockWithMsg:@"Read Notify Event On Start Error" block:failedBlock];
            return;
        }
        if (![self readFixOnStart]) {
            [self operationFailedBlockWithMsg:@"Read Fix On Start Error" block:failedBlock];
            return;
        }
        if (![self readNotifyEventInTrip]) {
            [self operationFailedBlockWithMsg:@"Read Notify Event In Trip Error" block:failedBlock];
            return;
        }
        if (![self readFixInTrip]) {
            [self operationFailedBlockWithMsg:@"Read Fix In Trip Error" block:failedBlock];
            return;
        }
        if (![self readNotifyEventOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Notify Event On End Error" block:failedBlock];
            return;
        }
        if (![self readFixOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Fix On End Error" block:failedBlock];
            return;
        }
        if (![self readFixOnStationary]) {
            [self operationFailedBlockWithMsg:@"Read Fix On Stationary Error" block:failedBlock];
            return;
        }
        if (![self readNumberOfFixOnStart]) {
            [self operationFailedBlockWithMsg:@"Read Number Of Fix On Start Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyOnStart]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy On Start Error" block:failedBlock];
            return;
        }
        if (![self readReportIntervalInTrip]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval In Trip Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyInTrip]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy In Trip Error" block:failedBlock];
            return;
        }
        if (![self readTripEndTimeout]) {
            [self operationFailedBlockWithMsg:@"Read Trip End Timeout Error" block:failedBlock];
            return;
        }
        if (![self readReportOnStationary]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval On Stationary Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyOnStationary]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy On Stationary Error" block:failedBlock];
            return;
        }
        if (![self readNumberOfFixOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Number Of Fix On End Error" block:failedBlock];
            return;
        }
        if (![self readReportIntervalOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Report Interval On End Error" block:failedBlock];
            return;
        }
        if (![self readPosStrategyOnEnd]) {
            [self operationFailedBlockWithMsg:@"Read Pos-Strategy On End Error" block:failedBlock];
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
        if (![self configNotifyEventOnStart]) {
            [self operationFailedBlockWithMsg:@"Config Notify Event On Start Error" block:failedBlock];
            return;
        }
        if (![self configFixOnStart]) {
            [self operationFailedBlockWithMsg:@"Config Fix On Start Error" block:failedBlock];
            return;
        }
        if (![self configNotifyEventInTrip]) {
            [self operationFailedBlockWithMsg:@"Config Notify Event In Trip Error" block:failedBlock];
            return;
        }
        if (![self configFixInTrip]) {
            [self operationFailedBlockWithMsg:@"Config Fix In Trip Error" block:failedBlock];
            return;
        }
        if (![self configNotifyEventOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Notify Event On End Error" block:failedBlock];
            return;
        }
        if (![self configFixOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Fix On End Error" block:failedBlock];
            return;
        }
        if (![self configFixOnStationary]) {
            [self operationFailedBlockWithMsg:@"Config Fix On Stationary Error" block:failedBlock];
            return;
        }
        if (![self configNumberOfFixOnStart]) {
            [self operationFailedBlockWithMsg:@"Config Number Of Fix On Start Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyOnStart]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy On Start Error" block:failedBlock];
            return;
        }
        if (![self configReportIntervalInTrip]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval In Trip Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyInTrip]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy In Trip Error" block:failedBlock];
            return;
        }
        if (![self configTripEndTimeout]) {
            [self operationFailedBlockWithMsg:@"Config Trip End Timeout Error" block:failedBlock];
            return;
        }
        if (![self configReportOnStationary]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval On Stationary Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyOnStationary]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy On Stationary Error" block:failedBlock];
            return;
        }
        if (![self configNumberOfFixOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Number Of Fix On End Error" block:failedBlock];
            return;
        }
        if (![self configReportIntervalOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Report Interval On End Error" block:failedBlock];
            return;
        }
        if (![self configPosStrategyOnEnd]) {
            [self operationFailedBlockWithMsg:@"Config Pos-Strategy On End Error" block:failedBlock];
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
- (BOOL)readNotifyEventOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsNotifyEventOnStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.notifyEventOnStart = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNotifyEventOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsNotifyEventOnStart:self.notifyEventOnStart sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFixOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsFixOnStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.fixOnStart = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFixOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsFixOnStart:self.fixOnStart sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNotifyEventInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsNotifyEventInTripWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.notifyEventInTrip = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNotifyEventInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsNotifyEventInTrip:self.notifyEventInTrip sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFixInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsFixInTripWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.fixInTrip = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFixInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsFixInTrip:self.fixInTrip sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNotifyEventOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsNotifyEventOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.notifyEventOnEnd = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNotifyEventOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsNotifyEventOnEnd:self.notifyEventOnEnd sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFixOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsFixOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.fixOnEnd = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFixOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsFixOnEnd:self.fixOnEnd sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readFixOnStationary {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeEventsFixOnStationaryStateWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.fixOnStationary = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configFixOnStationary {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeEventsFixOnStationaryState:self.fixOnStationary sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNumberOfFixOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeNumberOfFixOnStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.numberOfFixOnStart = returnData[@"result"][@"number"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNumberOfFixOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeNumberOfFixOnStart:[self.numberOfFixOnStart integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModePosStrategyOnStartWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyOnStart = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyOnStart {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModePosStrategyOnStart:self.posStrategyOnStart sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportIntervalInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeReportIntervalInTripWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.reportIntervalInTrip = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportIntervalInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeReportIntervalInTrip:[self.reportIntervalInTrip longLongValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModePosStrategyInTripWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyInTrip = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyInTrip {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModePosStrategyInTrip:self.posStrategyInTrip sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTripEndTimeout {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeTripEndTimeoutWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.tripEndTimeout = returnData[@"result"][@"time"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTripEndTimeout {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeTripEndTimeout:[self.tripEndTimeout integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readNumberOfFixOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeNumberOfFixOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.numberOfFixOnEnd = returnData[@"result"][@"number"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configNumberOfFixOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeNumberOfFixOnEnd:[self.numberOfFixOnEnd integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportIntervalOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModeReportIntervalOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.reportIntervalOnEnd = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportIntervalOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModeReportIntervalOnEnd:[self.reportIntervalOnEnd integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_readMotionModePosStrategyOnEndWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyOnEnd = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyOnEnd {
    __block BOOL success = NO;
    [MKMUInterface mu_configMotionModePosStrategyOnEnd:self.posStrategyOnEnd sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportOnStationary {
    __block BOOL success = NO;
    [MKMUInterface mu_readReportIntervalOnStationaryWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.reportIntervalOnStationary = returnData[@"result"][@"interval"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportOnStationary {
    __block BOOL success = NO;
    [MKMUInterface mu_configReportIntervalOnStationary:[self.reportIntervalOnStationary longLongValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPosStrategyOnStationary {
    __block BOOL success = NO;
    [MKMUInterface mu_readPosStrategyOnStationaryWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.posStrategyOnStationary = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPosStrategyOnStationary {
    __block BOOL success = NO;
    [MKMUInterface mu_configPosStrategyOnStationary:self.posStrategyOnStationary sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"motionModeParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.numberOfFixOnStart) || [self.numberOfFixOnStart integerValue] < 1 || [self.numberOfFixOnStart integerValue] > 10) {
        return NO;
    }
    if (!ValidStr(self.reportIntervalInTrip) || [self.reportIntervalInTrip integerValue] < 10 || [self.reportIntervalInTrip integerValue] > 86400) {
        return NO;
    }
    if (!ValidStr(self.tripEndTimeout) || [self.tripEndTimeout integerValue] < 3 || [self.tripEndTimeout integerValue] > 180) {
        return NO;
    }
    if (!ValidStr(self.numberOfFixOnEnd) || [self.numberOfFixOnEnd integerValue] < 1 || [self.numberOfFixOnEnd integerValue] > 10) {
        return NO;
    }
    if (!ValidStr(self.reportIntervalOnStationary) || [self.reportIntervalOnStationary integerValue] < 1 || [self.reportIntervalOnStationary integerValue] > 14400) {
        return NO;
    }
    if (!ValidStr(self.reportIntervalOnEnd) || [self.reportIntervalOnEnd integerValue] < 10 || [self.reportIntervalOnEnd integerValue] > 300) {
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
        _readQueue = dispatch_queue_create("motionModeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
