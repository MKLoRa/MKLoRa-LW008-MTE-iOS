//
//  MKMUInterface.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKMUCentralManager.h"
#import "MKMUOperationID.h"
#import "MKMUOperation.h"
#import "CBPeripheral+MKMUAdd.h"
#import "MKMUSDKDataAdopter.h"

#define centralManager [MKMUCentralManager shared]
#define peripheral ([MKMUCentralManager shared].peripheral)

@implementation MKMUInterface

#pragma mark ****************************************Device Service Information************************************************

+ (void)mu_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_mu_taskReadDeviceModelOperation
                           characteristic:peripheral.mu_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)mu_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_mu_taskReadFirmwareOperation
                           characteristic:peripheral.mu_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)mu_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_mu_taskReadHardwareOperation
                           characteristic:peripheral.mu_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)mu_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_mu_taskReadSoftwareOperation
                           characteristic:peripheral.mu_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)mu_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_mu_taskReadManufacturerOperation
                           characteristic:peripheral.mu_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ****************************************System************************************************

+ (void)mu_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMacAddressOperation
                     cmdFlag:@"0015"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimeZoneOperation
                     cmdFlag:@"0021"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readHeartbeatIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadHeartbeatIntervalOperation
                     cmdFlag:@"0022"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readIndicatorSettingsWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadIndicatorSettingsOperation
                     cmdFlag:@"0023"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMagnetTurnOnMethodWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMagnetTurnOnMethodOperation
                     cmdFlag:@"0024"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readHallPowerOffStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadHallPowerOffStatusOperation
                     cmdFlag:@"0025"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShutdownPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShutdownPayloadStatusOperation
                     cmdFlag:@"0026"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readThreeAxisWakeupConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadThreeAxisWakeupConditionsOperation
                     cmdFlag:@"0028"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readThreeAxisMotionParametersWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadThreeAxisMotionParametersOperation
                     cmdFlag:@"0029"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBatteryVoltageOperation
                     cmdFlag:@"0040"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPCBAStatusWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPCBAStatusOperation
                     cmdFlag:@"0041"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readSelftestStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadSelftestStatusOperation
                     cmdFlag:@"0042"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** Battery ************************************************

+ (void)mu_readBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBatteryInformationOperation
                     cmdFlag:@"0101"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLastCycleBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLastCycleBatteryInformationOperation
                     cmdFlag:@"0102"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readAllCycleBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadAllCycleBatteryInformationOperation
                     cmdFlag:@"0103"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPromptOperation
                     cmdFlag:@"0104"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPayloadStatusOperation
                     cmdFlag:@"0106"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPayloadIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPayloadIntervalOperation
                     cmdFlag:@"0107"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readAutoPowerOnAfterChargingWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadAutoPowerOnAfterChargingOperation
                     cmdFlag:@"0108"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙相关参数************************************************

+ (void)mu_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadConnectationNeedPasswordOperation
                     cmdFlag:@"0200"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPasswordOperation
                     cmdFlag:@"0201"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBroadcastTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBroadcastTimeoutOperation
                     cmdFlag:@"0202"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBeaconStatusOperation
                     cmdFlag:@"0203"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadAdvIntervalOperation
                     cmdFlag:@"0204"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTxPowerOperation
                     cmdFlag:@"0205"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadDeviceNameOperation
                     cmdFlag:@"0206"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************模式相关参数************************************************
+ (void)mu_readWorkModeWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadWorkModeOperation
                     cmdFlag:@"0300"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readStandbyModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadStandbyModePositioningStrategyOperation
                     cmdFlag:@"0310"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPeriodicModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPeriodicModePositioningStrategyOperation
                     cmdFlag:@"0320"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPeriodicModeReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPeriodicModeReportIntervalOperation
                     cmdFlag:@"0321"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimingModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimingModePositioningStrategyOperation
                     cmdFlag:@"0330"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimingModeReportingTimePointWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimingModeReportingTimePointOperation
                     cmdFlag:@"0331"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsNotifyEventOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                                  failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsNotifyEventOnStartOperation
                     cmdFlag:@"0340"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsFixOnStartOperation
                     cmdFlag:@"0341"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModePosStrategyOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModePosStrategyOnStartOperation
                     cmdFlag:@"0342"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeNumberOfFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeNumberOfFixOnStartOperation
                     cmdFlag:@"0343"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsNotifyEventInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                                 failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsNotifyEventInTripOperation
                     cmdFlag:@"0350"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsFixInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsFixInTripOperation
                     cmdFlag:@"0351"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModePosStrategyInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModePosStrategyInTripOperation
                     cmdFlag:@"0352"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeReportIntervalInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeReportIntervalInTripOperation
                     cmdFlag:@"0353"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsNotifyEventOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsNotifyEventOnEndOperation
                     cmdFlag:@"0360"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsFixOnEndOperation
                     cmdFlag:@"0361"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModePosStrategyOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModePosStrategyOnEndOperation
                     cmdFlag:@"0362"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeReportIntervalOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeReportIntervalOnEndOperation
                     cmdFlag:@"0363"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeNumberOfFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeNumberOfFixOnEndOperation
                     cmdFlag:@"0364"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeTripEndTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeTripEndTimeoutOperation
                     cmdFlag:@"0365"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsFixOnStationaryStateWithSucBlock:(void (^)(id returnData))sucBlock
                                                    failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsFixOnStationaryStateOperation
                     cmdFlag:@"0370"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPosStrategyOnStationaryWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPosStrategyOnStationaryOperation
                     cmdFlag:@"0371"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readReportIntervalOnStationaryWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadReportIntervalOnStationaryOperation
                     cmdFlag:@"0372"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimeSegmentedModeStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimeSegmentedModeStrategyOperation
                     cmdFlag:@"0380"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimeSegmentedModeTimePeriodSettingWithSucBlock:(void (^)(id returnData))sucBlock
                                                  failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimeSegmentedModeTimePeriodSettingOperation
                     cmdFlag:@"0381"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************定位参数************************************************

+ (void)mu_readRssiFilterValueWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadRssiFilterValueOperation
                     cmdFlag:@"0401"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterRelationshipOperation
                     cmdFlag:@"0402"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterTypeStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterTypeStatusOperation
                     cmdFlag:@"0403"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByMacPreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByMacPreciseMatchOperation
                     cmdFlag:@"0410"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByMacReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByMacReverseFilterOperation
                     cmdFlag:@"0411"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterMACAddressListWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterMACAddressListOperation
                     cmdFlag:@"0412"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByAdvNamePreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByAdvNamePreciseMatchOperation
                     cmdFlag:@"0418"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByAdvNameReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByAdvNameReverseFilterOperation
                     cmdFlag:@"0419"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterAdvNameListWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee00041a00";
    [centralManager addTaskWithTaskID:mk_mu_taskReadFilterAdvNameListOperation
                       characteristic:peripheral.mu_custom
                          commandData:commandString
                         successBlock:^(id  _Nonnull returnData) {
        NSArray *advList = [MKMUSDKDataAdopter parseFilterAdvNameList:returnData[@"result"]];
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":@{
                                        @"nameList":advList,
                                    },
                                    };
        MKBLEBase_main_safe(^{
            if (sucBlock) {
                sucBlock(resultDic);
            }
        });
        
    } failureBlock:failedBlock];
}



+ (void)mu_readFilterByBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconStatusOperation
                     cmdFlag:@"0420"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconMajorRangeOperation
                     cmdFlag:@"0421"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconMinorRangeOperation
                     cmdFlag:@"0422"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconUUIDOperation
                     cmdFlag:@"0423"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByUIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByUIDStatusOperation
                     cmdFlag:@"0428"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByUIDNamespaceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByUIDNamespaceIDOperation
                     cmdFlag:@"0429"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByUIDInstanceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByUIDInstanceIDOperation
                     cmdFlag:@"042a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByURLStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByURLStatusOperation
                     cmdFlag:@"0430"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByURLContentWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByURLContentOperation
                     cmdFlag:@"0431"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByTLMStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByTLMStatusOperation
                     cmdFlag:@"0438"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByTLMVersionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByTLMVersionOperation
                     cmdFlag:@"0439"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconStatusOperation
                     cmdFlag:@"0440"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconMajorRangeOperation
                     cmdFlag:@"0441"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconMinorRangeOperation
                     cmdFlag:@"0442"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconUUIDOperation
                     cmdFlag:@"0443"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPAccFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPAccFilterStatusOperation
                     cmdFlag:@"0450"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPTHFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPTHFilterStatusOperation
                     cmdFlag:@"0458"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPDeviceInfoStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPDeviceInfoFilterStatusOperation
                     cmdFlag:@"0460"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPButtonFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPButtonFilterStatusOperation
                     cmdFlag:@"0468"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPButtonAlarmFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPButtonAlarmFilterStatusOperation
                     cmdFlag:@"0469"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPTagIDStatusOperation
                     cmdFlag:@"0470"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPreciseMatchTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPreciseMatchTagIDStatusOperation
                     cmdFlag:@"0471"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readReverseFilterTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadReverseFilterTagIDStatusOperation
                     cmdFlag:@"0472"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterBXPTagIDListWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterBXPTagIDListOperation
                     cmdFlag:@"0473"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterBXPTofStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterBXPTofStatusOperation
                     cmdFlag:@"0478"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterBXPTofMfgCodeListWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterBXPTofMfgCodeListOperation
                     cmdFlag:@"0479"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirStatusOperation
                     cmdFlag:@"0480"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirDetectionStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirDetectionStatusOperation
                     cmdFlag:@"0481"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirSensorSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirSensorSensitivityOperation
                     cmdFlag:@"0482"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirDoorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirDoorStatusOperation
                     cmdFlag:@"0483"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirDelayResponseStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirDelayResponseStatusOperation
                     cmdFlag:@"0484"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirMajorRangeOperation
                     cmdFlag:@"0485"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirMinorRangeOperation
                     cmdFlag:@"0486"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByOtherStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByOtherStatusOperation
                     cmdFlag:@"04f8"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByOtherRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByOtherRelationshipOperation
                     cmdFlag:@"04f9"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByOtherConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByOtherConditionsOperation
                     cmdFlag:@"04fa"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** LoRaWAN ************************************************

+ (void)mu_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"0500"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanRegionOperation
                     cmdFlag:@"0501"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanModemOperation
                     cmdFlag:@"0502"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"0503"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"0504"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"0505"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDEVADDROperation
                     cmdFlag:@"0506"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"0507"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"0508"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanADRACKLimitWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanADRACKLimitOperation
                     cmdFlag:@"050a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanADRACKDelayWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanADRACKDelayOperation
                     cmdFlag:@"050b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanCHOperation
                     cmdFlag:@"0520"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDROperation
                     cmdFlag:@"0521"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanUplinkStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanUplinkStrategyOperation
                     cmdFlag:@"0522"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDutyCycleStatusOperation
                     cmdFlag:@"0523"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDevTimeSyncIntervalOperation
                     cmdFlag:@"0540"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanNetworkCheckIntervalOperation
                     cmdFlag:@"0541"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readHeartbeatPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadHeartbeatPayloadDataOperation
                     cmdFlag:@"0551"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPayloadDataOperation
                     cmdFlag:@"0552"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readEventPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadEventPayloadDataOperation
                     cmdFlag:@"0554"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPositioningPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPositioningPayloadDataOperation
                     cmdFlag:@"0555"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockPayloadDataOperation
                     cmdFlag:@"0557"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readManDownDetectionPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadManDownDetectionPayloadDataOperation
                     cmdFlag:@"0558"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}



+ (void)mu_readGPSLimitPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGPSLimitPayloadDataOperation
                     cmdFlag:@"055b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************辅助功能************************************************

+ (void)mu_readDownlinkPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadDownlinkPositioningStrategyOperation
                     cmdFlag:@"0600"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockDetectionStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockDetectionStatusOperation
                     cmdFlag:@"0610"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockThresholdsWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockThresholdsOperation
                     cmdFlag:@"0611"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockDetectionReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockDetectionReportIntervalOperation
                     cmdFlag:@"0612"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockTimeoutOperation
                     cmdFlag:@"0613"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readManDownDetectionWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadManDownDetectionOperation
                     cmdFlag:@"0620"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readIdleDetectionTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadIdleDetectionTimeoutOperation
                     cmdFlag:@"0621"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙定位参数************************************************
+ (void)mu_readOfflineFixStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadOfflineFixStatusOperation
                     cmdFlag:@"0800"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readGpsLimitUploadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGpsLimitUploadStatusOperation
                     cmdFlag:@"0801"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readOutdoorBLEReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadOutdoorBLEReportIntervalOperation
                     cmdFlag:@"0808"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readOutdoorGPSReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadOutdoorGPSReportIntervalOperation
                     cmdFlag:@"0809"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBluetoothFixMechanismWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBluetoothFixMechanismOperation
                     cmdFlag:@"0820"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBlePositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBlePositioningTimeoutOperation
                     cmdFlag:@"0821"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBlePositioningNumberOfMacWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBlePositioningNumberOfMacOperation
                     cmdFlag:@"0822"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBeaconVoltageReportInBleFixWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBeaconVoltageReportInBleFixOperation
                     cmdFlag:@"0823"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readGPSFixPositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGPSFixPositioningTimeoutOperation
                     cmdFlag:@"0830"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readGPSFixPDOPWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGPSFixPDOPOperation
                     cmdFlag:@"0831"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}



#pragma mark - private method

+ (void)readDataWithTaskID:(mk_mu_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.mu_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
