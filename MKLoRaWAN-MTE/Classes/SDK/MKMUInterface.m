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

+ (void)mu_readTimeZoneWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimeZoneOperation
                     cmdFlag:@"14"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readWorkModeWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadWorkModeOperation
                     cmdFlag:@"15"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readIndicatorSettingsWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadIndicatorSettingsOperation
                     cmdFlag:@"16"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readHeartbeatIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadHeartbeatIntervalOperation
                     cmdFlag:@"17"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShutdownPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShutdownPayloadStatusOperation
                     cmdFlag:@"19"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readOfflineFixStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadOfflineFixStatusOperation
                     cmdFlag:@"1a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPayloadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPayloadStatusOperation
                     cmdFlag:@"1b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPromptWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPromptOperation
                     cmdFlag:@"1c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readHallPowerOffStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadHallPowerOffStatusOperation
                     cmdFlag:@"1e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBatteryVoltageOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMacAddressOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPCBAStatusWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPCBAStatusOperation
                     cmdFlag:@"22"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readSelftestStatusWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadSelftestStatusOperation
                     cmdFlag:@"23"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readAutoPowerOnAfterChargingWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadAutoPowerOnAfterChargingOperation
                     cmdFlag:@"24"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBatteryInformationOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLastCycleBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLastCycleBatteryInformationOperation
                     cmdFlag:@"27"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readAllCycleBatteryInformationWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadAllCycleBatteryInformationOperation
                     cmdFlag:@"28"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPayloadIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPayloadIntervalOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readGpsLimitUploadStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGpsLimitUploadStatusOperation
                     cmdFlag:@"2a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙相关参数************************************************

+ (void)mu_readConnectationNeedPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadConnectationNeedPasswordOperation
                     cmdFlag:@"30"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPasswordWithSucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPasswordOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBroadcastTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBroadcastTimeoutOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTxPowerWithSucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTxPowerOperation
                     cmdFlag:@"33"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readDeviceNameWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadDeviceNameOperation
                     cmdFlag:@"34"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readAdvIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadAdvIntervalOperation
                     cmdFlag:@"35"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBeaconStatusOperation
                     cmdFlag:@"37"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************模式相关参数************************************************
+ (void)mu_readStandbyModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadStandbyModePositioningStrategyOperation
                     cmdFlag:@"39"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPeriodicModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPeriodicModePositioningStrategyOperation
                     cmdFlag:@"40"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPeriodicModeReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPeriodicModeReportIntervalOperation
                     cmdFlag:@"41"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimingModePositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimingModePositioningStrategyOperation
                     cmdFlag:@"42"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readTimingModeReportingTimePointWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadTimingModeReportingTimePointOperation
                     cmdFlag:@"43"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeEventsWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeEventsOperation
                     cmdFlag:@"44"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeNumberOfFixOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeNumberOfFixOnStartOperation
                     cmdFlag:@"45"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModePosStrategyOnStartWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModePosStrategyOnStartOperation
                     cmdFlag:@"46"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeReportIntervalInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeReportIntervalInTripOperation
                     cmdFlag:@"47"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModePosStrategyInTripWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModePosStrategyInTripOperation
                     cmdFlag:@"48"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeTripEndTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeTripEndTimeoutOperation
                     cmdFlag:@"49"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeNumberOfFixOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeNumberOfFixOnEndOperation
                     cmdFlag:@"4a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModeReportIntervalOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                             failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModeReportIntervalOnEndOperation
                     cmdFlag:@"4b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readMotionModePosStrategyOnEndWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadMotionModePosStrategyOnEndOperation
                     cmdFlag:@"4c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPosStrategyOnStationaryWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPosStrategyOnStationaryOperation
                     cmdFlag:@"4d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readReportIntervalOnStationaryWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadReportIntervalOnStationaryOperation
                     cmdFlag:@"4e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************定位参数************************************************

+ (void)mu_readRssiFilterValueWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadRssiFilterValueOperation
                     cmdFlag:@"51"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterRelationshipOperation
                     cmdFlag:@"52"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByMacPreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByMacPreciseMatchOperation
                     cmdFlag:@"53"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByMacReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByMacReverseFilterOperation
                     cmdFlag:@"54"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterMACAddressListWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterMACAddressListOperation
                     cmdFlag:@"55"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByAdvNamePreciseMatchWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByAdvNamePreciseMatchOperation
                     cmdFlag:@"56"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByAdvNameReverseFilterWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByAdvNameReverseFilterOperation
                     cmdFlag:@"57"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterAdvNameListWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ee005800";
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

+ (void)mu_readFilterTypeStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterTypeStatusOperation
                     cmdFlag:@"59"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconStatusOperation
                     cmdFlag:@"5a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconMajorRangeOperation
                     cmdFlag:@"5b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconMinorRangeOperation
                     cmdFlag:@"5c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBeaconUUIDOperation
                     cmdFlag:@"5d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByUIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByUIDStatusOperation
                     cmdFlag:@"5e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByUIDNamespaceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByUIDNamespaceIDOperation
                     cmdFlag:@"5f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByUIDInstanceIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByUIDInstanceIDOperation
                     cmdFlag:@"60"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByURLStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByURLStatusOperation
                     cmdFlag:@"61"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByURLContentWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByURLContentOperation
                     cmdFlag:@"62"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByTLMStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByTLMStatusOperation
                     cmdFlag:@"63"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByTLMVersionWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByTLMVersionOperation
                     cmdFlag:@"64"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconStatusOperation
                     cmdFlag:@"65"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconMajorRangeOperation
                     cmdFlag:@"66"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconMinorRangeOperation
                     cmdFlag:@"67"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPBeaconUUIDWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPBeaconUUIDOperation
                     cmdFlag:@"68"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPDeviceInfoStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPDeviceInfoFilterStatusOperation
                     cmdFlag:@"69"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPAccFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPAccFilterStatusOperation
                     cmdFlag:@"6a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPTHFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPTHFilterStatusOperation
                     cmdFlag:@"6b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPButtonFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPButtonFilterStatusOperation
                     cmdFlag:@"6c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPButtonAlarmFilterStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPButtonAlarmFilterStatusOperation
                     cmdFlag:@"6d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByBXPTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByBXPTagIDStatusOperation
                     cmdFlag:@"6e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPreciseMatchTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPreciseMatchTagIDStatusOperation
                     cmdFlag:@"6f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readReverseFilterTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadReverseFilterTagIDStatusOperation
                     cmdFlag:@"70"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterBXPTagIDListWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterBXPTagIDListOperation
                     cmdFlag:@"71"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirStatusOperation
                     cmdFlag:@"72"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirDetectionStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirDetectionStatusOperation
                     cmdFlag:@"73"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirSensorSensitivityWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirSensorSensitivityOperation
                     cmdFlag:@"74"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirDoorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirDoorStatusOperation
                     cmdFlag:@"75"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirDelayResponseStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirDelayResponseStatusOperation
                     cmdFlag:@"76"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirMajorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirMajorRangeOperation
                     cmdFlag:@"77"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByPirMinorRangeWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByPirMinorRangeOperation
                     cmdFlag:@"78"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterBXPTofStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterBXPTofStatusOperation
                     cmdFlag:@"79"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterBXPTofMfgCodeListWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterBXPTofMfgCodeListOperation
                     cmdFlag:@"7a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPSensorInfoFilterByTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPSensorInfoFilterByTagIDStatusOperation
                     cmdFlag:@"7b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPSensorInfoPreciseMatchTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPSensorInfoPreciseMatchTagIDStatusOperation
                     cmdFlag:@"7c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPSensorInfoReverseFilterTagIDStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPSensorInfoReverseFilterTagIDStatusOperation
                     cmdFlag:@"7d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBXPSensorInfoFilterBXPTagIDListWithSucBlock:(void (^)(id returnData))sucBlock
                                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBXPSensorInfoFilterBXPTagIDListOperation
                     cmdFlag:@"7e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByOtherStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByOtherStatusOperation
                     cmdFlag:@"8b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByOtherRelationshipWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByOtherRelationshipOperation
                     cmdFlag:@"8c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readFilterByOtherConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadFilterByOtherConditionsOperation
                     cmdFlag:@"8d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark **************************************** LoRaWAN ************************************************

+ (void)mu_readLorawanNetworkStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanNetworkStatusOperation
                     cmdFlag:@"90"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanRegionWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanRegionOperation
                     cmdFlag:@"91"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanModemWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanModemOperation
                     cmdFlag:@"92"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDEVEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDEVEUIOperation
                     cmdFlag:@"93"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanAPPEUIWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanAPPEUIOperation
                     cmdFlag:@"94"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanAPPKEYWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanAPPKEYOperation
                     cmdFlag:@"95"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDEVADDRWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDEVADDROperation
                     cmdFlag:@"96"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanAPPSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanAPPSKEYOperation
                     cmdFlag:@"97"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanNWKSKEYWithSucBlock:(void (^)(id returnData))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanNWKSKEYOperation
                     cmdFlag:@"98"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanCHWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanCHOperation
                     cmdFlag:@"9a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDRWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDROperation
                     cmdFlag:@"9b"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanUplinkStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanUplinkStrategyOperation
                     cmdFlag:@"9c"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanDutyCycleStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDutyCycleStatusOperation
                     cmdFlag:@"9d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanTimeSyncIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanDevTimeSyncIntervalOperation
                     cmdFlag:@"9e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanNetworkCheckIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanNetworkCheckIntervalOperation
                     cmdFlag:@"9f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanADRACKLimitWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanADRACKLimitOperation
                     cmdFlag:@"a0"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLorawanADRACKDelayWithSucBlock:(void (^)(id returnData))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLorawanADRACKDelayOperation
                     cmdFlag:@"a1"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readHeartbeatPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadHeartbeatPayloadDataOperation
                     cmdFlag:@"a2"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readPositioningPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadPositioningPayloadDataOperation
                     cmdFlag:@"a3"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readLowPowerPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadLowPowerPayloadDataOperation
                     cmdFlag:@"a4"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockPayloadDataOperation
                     cmdFlag:@"a5"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readManDownDetectionPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadManDownDetectionPayloadDataOperation
                     cmdFlag:@"a6"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readEventPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadEventPayloadDataOperation
                     cmdFlag:@"a7"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readGPSLimitPayloadDataWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGPSLimitPayloadDataOperation
                     cmdFlag:@"ab"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************辅助功能************************************************

+ (void)mu_readDownlinkPositioningStrategyWithSucBlock:(void (^)(id returnData))sucBlock
                                           failedBlock:(void (^)(NSError * error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadDownlinkPositioningStrategyOperation
                     cmdFlag:@"b0"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readThreeAxisWakeupConditionsWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadThreeAxisWakeupConditionsOperation
                     cmdFlag:@"b1"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readThreeAxisMotionParametersWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadThreeAxisMotionParametersOperation
                     cmdFlag:@"b2"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockDetectionStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockDetectionStatusOperation
                     cmdFlag:@"b3"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockThresholdsWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockThresholdsOperation
                     cmdFlag:@"b4"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockDetectionReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockDetectionReportIntervalOperation
                     cmdFlag:@"b5"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readShockTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadShockTimeoutOperation
                     cmdFlag:@"b6"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readManDownDetectionWithSucBlock:(void (^)(id returnData))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadManDownDetectionOperation
                     cmdFlag:@"b7"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readIdleDetectionTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadIdleDetectionTimeoutOperation
                     cmdFlag:@"b8"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙定位参数************************************************
+ (void)mu_readBluetoothFixMechanismWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBluetoothFixMechanismOperation
                     cmdFlag:@"d8"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBlePositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBlePositioningTimeoutOperation
                     cmdFlag:@"d9"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readBlePositioningNumberOfMacWithSucBlock:(void (^)(id returnData))sucBlock
                                         failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadBlePositioningNumberOfMacOperation
                     cmdFlag:@"da"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark ****************************************GPS定位参数************************************************
+ (void)mu_readGPSFixPositioningTimeoutWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGPSFixPositioningTimeoutOperation
                     cmdFlag:@"e0"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readGPSFixPDOPWithSucBlock:(void (^)(id returnData))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadGPSFixPDOPOperation
                     cmdFlag:@"e1"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readOutdoorBLEReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadOutdoorBLEReportIntervalOperation
                     cmdFlag:@"ee"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)mu_readOutdoorGPSReportIntervalWithSucBlock:(void (^)(id returnData))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_mu_taskReadOutdoorGPSReportIntervalOperation
                     cmdFlag:@"ef"
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
