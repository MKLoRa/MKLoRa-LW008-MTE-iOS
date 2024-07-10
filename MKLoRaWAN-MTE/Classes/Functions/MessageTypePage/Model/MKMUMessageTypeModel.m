//
//  MKMUMessageTypeModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUMessageTypeModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@interface MKMUMessageTypeModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUMessageTypeModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        
        if (![self readHeartbeatPayload]) {
            [self operationFailedBlockWithMsg:@"Read Heartbeat Payload Error" block:failedBlock];
            return;
        }
        
        if (![self readPositioningPayload]) {
            [self operationFailedBlockWithMsg:@"Read Positioning Payload Error" block:failedBlock];
            return;
        }
        
        if (![self readLowPowerPayload]) {
            [self operationFailedBlockWithMsg:@"Read Low-Power Payload Error" block:failedBlock];
            return;
        }
        
        if (![self readShockPayload]) {
            [self operationFailedBlockWithMsg:@"Read Shock Payload Error" block:failedBlock];
            return;
        }
        
        if (![self readManDownPayload]) {
            [self operationFailedBlockWithMsg:@"Read Man Down Payload Error" block:failedBlock];
            return;
        }
        
        if (![self readEventPayload]) {
            [self operationFailedBlockWithMsg:@"Read Event Payload Error" block:failedBlock];
            return;
        }
        
        if (![self readGpsPayload]) {
            [self operationFailedBlockWithMsg:@"Read GPS Payload Error" block:failedBlock];
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
        
        if (![self configHeartbeatPayload]) {
            [self operationFailedBlockWithMsg:@"Config Heartbeat Payload Error" block:failedBlock];
            return;
        }
        
        if (![self configPositioningPayload]) {
            [self operationFailedBlockWithMsg:@"Config Positioning Payload Error" block:failedBlock];
            return;
        }
        
        if (![self configLowPowerPayload]) {
            [self operationFailedBlockWithMsg:@"Config Low-Power Payload Error" block:failedBlock];
            return;
        }
        
        if (![self configShockPayload]) {
            [self operationFailedBlockWithMsg:@"Config Shock Payload Error" block:failedBlock];
            return;
        }
        
        if (![self configManDownPayload]) {
            [self operationFailedBlockWithMsg:@"Config Man Down Payload Error" block:failedBlock];
            return;
        }
        
        if (![self configEventPayload]) {
            [self operationFailedBlockWithMsg:@"Config Event Payload Error" block:failedBlock];
            return;
        }
        
        if (![self configGpsPayload]) {
            [self operationFailedBlockWithMsg:@"Config GPS Payload Error" block:failedBlock];
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
- (BOOL)readHeartbeatPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readHeartbeatPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.heartbeatType = [returnData[@"result"][@"type"] integerValue];
        self.heartbeatMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configHeartbeatPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configHeartbeatPayloadWithMessageType:self.heartbeatType retransmissionTimes:(self.heartbeatMaxTimes + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readPositioningPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readPositioningPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.positionType = [returnData[@"result"][@"type"] integerValue];
        self.positionMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configPositioningPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configPositioningPayloadWithMessageType:self.positionType retransmissionTimes:(self.positionMaxTimes + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readLowPowerPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readLowPowerPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.lowPowerType = [returnData[@"result"][@"type"] integerValue];
        self.lowPowerMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configLowPowerPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configLowPowerPayloadWithMessageType:self.lowPowerType retransmissionTimes:(self.lowPowerMaxTimes + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readShockPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readShockPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.shockType = [returnData[@"result"][@"type"] integerValue];
        self.shockMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configShockPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configShockPayloadWithMessageType:self.shockType retransmissionTimes:(self.shockMaxTimes + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readManDownPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readManDownDetectionPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.manDownType = [returnData[@"result"][@"type"] integerValue];
        self.manDownTMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configManDownPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configManDownDetectionPayloadWithMessageType:self.manDownType retransmissionTimes:(self.manDownTMaxTimes + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readEventPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readEventPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.eventType = [returnData[@"result"][@"type"] integerValue];
        self.eventMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configEventPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configEventPayloadWithMessageType:self.eventType retransmissionTimes:(self.eventMaxTimes + 1) sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readGpsPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_readGPSLimitPayloadDataWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.gpsLimitType = [returnData[@"result"][@"type"] integerValue];
        self.gpsLimitMaxTimes = [returnData[@"result"][@"retransmissionTimes"] integerValue] - 1;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configGpsPayload {
    __block BOOL success = NO;
    [MKMUInterface mu_configGPSLimitPayloadWithMessageType:self.gpsLimitType retransmissionTimes:(self.gpsLimitMaxTimes + 1) sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"MessageTypeParams"
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
        _readQueue = dispatch_queue_create("MessageTypeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
