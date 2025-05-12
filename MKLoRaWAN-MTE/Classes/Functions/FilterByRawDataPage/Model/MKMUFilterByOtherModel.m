//
//  MKMUFilterByOtherModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/12/1.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMUFilterByOtherModel.h"

#import "MKMacroDefines.h"
#import "NSObject+MKAdd.h"

#import "MKBLEBaseSDKAdopter.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@implementation MKMUFilterRawAdvDataModel

- (void)updateWithModel:(MKFilterRawAdvDataModel *)model {
    self.dataType = model.dataType;
    self.minIndex = model.minIndex;
    self.maxIndex = model.maxIndex;
    self.rawData = model.rawData;
}

@end


@interface MKMUFilterByOtherModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUFilterByOtherModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Read Filter Status Error" block:failedBlock];
            return;
        }
        if (![self readRelationship]) {
            [self operationFailedBlockWithMsg:@"Read Relationship Error" block:failedBlock];
            return;
        }
        if (![self readConditions]) {
            [self operationFailedBlockWithMsg:@"Read Conditions Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithRawDataList:(NSArray <MKFilterRawAdvDataModel *>*)list
                 relationship:(mk_filterByOther)relationship
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configConditions:list]) {
            [self operationFailedBlockWithMsg:@"Config Conditions Error" block:failedBlock];
            return;
        }
        if (![self configFilterStatus]) {
            [self operationFailedBlockWithMsg:@"Config Filter Status Error" block:failedBlock];
            return;
        }
        if (![self configRelationship:relationship]) {
            [self operationFailedBlockWithMsg:@"Config Relationship Error" block:failedBlock];
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
    [MKMUInterface mu_readFilterByOtherStatusWithSucBlock:^(id  _Nonnull returnData) {
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
    [MKMUInterface mu_configFilterByOtherStatus:self.isOn sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readRelationship {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByOtherRelationshipWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.relationship = [returnData[@"result"][@"relationship"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configRelationship:(NSInteger)relationship {
    __block BOOL success = NO;
    [MKMUInterface mu_configFilterByOtherRelationship:relationship sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readConditions {
    __block BOOL success = NO;
    [MKMUInterface mu_readFilterByOtherConditionsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.rawDataList = returnData[@"result"][@"conditionList"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configConditions:(NSArray <MKFilterRawAdvDataModel *>*)list {
    __block BOOL success = NO;
    NSMutableArray *tempList = [NSMutableArray array];
    for (MKFilterRawAdvDataModel *model in list) {
        MKMUFilterRawAdvDataModel *tempModel = [[MKMUFilterRawAdvDataModel alloc] init];
        [tempModel updateWithModel:model];
        [tempList addObject:tempModel];
    }
    [MKMUInterface mu_configFilterByOtherConditions:tempList sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"filterOtherParams"
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
        _readQueue = dispatch_queue_create("filterOtherQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
