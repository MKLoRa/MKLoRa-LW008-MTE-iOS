//
//  MKMUTimeSegmentedModel.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKMUTimeSegmentedModel.h"

#import "MKMacroDefines.h"

#import "MKMUInterface.h"
#import "MKMUInterface+MKMUConfig.h"

@implementation MKMUTimeSegmentedTimePeriodModel
- (void)updateWithModel:(MKTimeSegmentedTimePeriodModel *)model {
    self.startHour = model.startHour;
    self.startMinuteGear = model.startMinuteGear;
    self.endHour = model.endHour;
    self.endMinuteGear = model.endMinuteGear;
    self.interval = model.interval;
}
@end

@interface MKMUTimeSegmentedModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKMUTimeSegmentedModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readStrategy]) {
            [self operationFailedBlockWithMsg:@"Read Positioning Strategy Error" block:failedBlock];
            return;
        }
        if (![self readReportingTimePoint]) {
            [self operationFailedBlockWithMsg:@"Read Reporting Time Point Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configData:(NSArray <MKTimeSegmentedTimePeriodModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self configStrategy]) {
            [self operationFailedBlockWithMsg:@"Config Positioning Strategy Error" block:failedBlock];
            return;
        }
        if (![self configReportingTimePoint:pointList]) {
            [self operationFailedBlockWithMsg:@"Config Reporting Time Point Error" block:failedBlock];
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
- (BOOL)readStrategy {
    __block BOOL success = NO;
    [MKMUInterface mu_readTimeSegmentedModeStrategyWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.strategy = [returnData[@"result"][@"strategy"] integerValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configStrategy {
    __block BOOL success = NO;
    [MKMUInterface mu_configTimeSegmentedModeStrategy:self.strategy sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readReportingTimePoint {
    __block BOOL success = NO;
    [MKMUInterface mu_readTimeSegmentedModeTimePeriodSettingWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSArray *pointList = returnData[@"result"][@"timeList"];
        NSMutableArray *tempList= [NSMutableArray array];
        for (NSInteger i = 0; i < pointList.count; i ++) {
            NSDictionary *params = pointList[i];
            MKMUTimeSegmentedTimePeriodModel *pointModel = [[MKMUTimeSegmentedTimePeriodModel alloc] init];
            pointModel.startHour = [params[@"startHour"] integerValue];
            pointModel.startMinuteGear = [params[@"startMinuteGear"] integerValue];
            pointModel.endHour = [params[@"endHour"] integerValue];
            pointModel.endMinuteGear = [params[@"endMinuteGear"] integerValue];
            pointModel.interval = [params[@"reportInterval"] integerValue];
            [tempList addObject:pointModel];
        }
        self.pointList = [NSArray arrayWithArray:tempList];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configReportingTimePoint:(NSArray <MKTimeSegmentedTimePeriodModel *>*)pointList {
    __block BOOL success = NO;
    NSMutableArray *tempList = [NSMutableArray array];
    for (MKTimeSegmentedTimePeriodModel *model in pointList) {
        MKMUTimeSegmentedTimePeriodModel *tempModel = [[MKMUTimeSegmentedTimePeriodModel alloc] init];
        [tempModel updateWithModel:model];
        [tempList addObject:tempModel];
    }
    [MKMUInterface mu_configTimeSegmentedModeTimePeriodSetting:tempList sucBlock:^{
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
        NSError *error = [[NSError alloc] initWithDomain:@"timingModeParams"
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
        _readQueue = dispatch_queue_create("TimeSegmentedModeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
