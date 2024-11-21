//
//  MKMUInterface+MKMUConfig.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUInterface+MKMUConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseCentralManager.h"

#import "MKMUCentralManager.h"
#import "MKMUOperationID.h"
#import "MKMUOperation.h"
#import "CBPeripheral+MKMUAdd.h"
#import "MKMUSDKDataAdopter.h"

#define centralManager [MKMUCentralManager shared]

static NSInteger const maxDataLen = 100;

@implementation MKMUInterface (MKMUConfig)

+ (void)mu_powerOffWithSucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01000000";
    [self configDataWithTaskID:mk_mu_taskPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_restartDeviceWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01000100";
    [self configDataWithTaskID:mk_mu_taskRestartDeviceOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_factoryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01000200";
    [self configDataWithTaskID:mk_mu_taskFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configDeviceTime:(unsigned long)timestamp
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [NSString stringWithFormat:@"%1lx",timestamp];
    NSString *commandString = [@"ed01002004" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigDeviceTimeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTimeZone:(NSInteger)timeZone
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeZone < -24 || timeZone > 28) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *zoneString = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:timeZone];
    NSString *commandString = [@"ed01002101" stringByAppendingString:zoneString];
    [self configDataWithTaskID:mk_mu_taskConfigTimeZoneOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configHeartbeatInterval:(NSInteger)interval
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 300 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed01002204" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigHeartbeatIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configIndicatorSettings:(id <mk_mu_indicatorSettingsProtocol>)protocol
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKMUSDKDataAdopter parseIndicatorSettingsCommand:protocol];
    if (!MKValidStr(value)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lowPower = (protocol.LowPower ? @"01" : @"00");
    NSString *broadcast = (protocol.Broadcast ? @"01" : @"00");
    NSString *networkCheck = (protocol.NetworkCheck ? @"01" : @"00");
    NSString *inFix = (protocol.InFix ? @"01" : @"00");
    NSString *fixSuccessful = (protocol.FixSuccessful ? @"01" : @"00");
    NSString *failToFix = (protocol.FailToFix ? @"01" : @"00");
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ed01002306",lowPower,broadcast,networkCheck,inFix,fixSuccessful,failToFix];
    [self configDataWithTaskID:mk_mu_taskConfigIndicatorSettingsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMagnetTurnOnMethod:(mk_mu_magnetTurnOnMethod)method
                          sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:method byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01002401",value];
    [self configDataWithTaskID:mk_mu_taskConfigMagnetTurnOnMethodOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configHallPowerOffStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0100250101" : @"ed0100250100");
    [self configDataWithTaskID:mk_mu_taskConfigHallPowerOffStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configShutdownPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0100260101" : @"ed0100260100");
    [self configDataWithTaskID:mk_mu_taskConfigShutdownPayloadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configThreeAxisWakeupConditions:(NSInteger)threshold
                                  duration:(NSInteger)duration
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 1 || threshold > 20 || duration < 1 || duration > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *durationString = [MKBLEBaseSDKAdopter fetchHexValue:duration byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01002802",thresholdString,durationString];
    [self configDataWithTaskID:mk_mu_taskConfigThreeAxisWakeupConditionsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configThreeAxisMotionParameters:(NSInteger)threshold
                                  duration:(NSInteger)duration
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 10 || threshold > 250 || duration < 1 || duration > 50) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *durationString = [MKBLEBaseSDKAdopter fetchHexValue:duration byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01002902",thresholdString,durationString];
    [self configDataWithTaskID:mk_mu_taskConfigThreeAxisMotionParametersOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark **************************************** Battery ************************************************

+ (void)mu_batteryResetWithSucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01010000";
    [self configDataWithTaskID:mk_mu_taskBatteryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLowPowerPrompt:(mk_mu_lowPowerPrompt)prompt
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ed01010401" stringByAppendingString:[MKBLEBaseSDKAdopter fetchHexValue:prompt byteLen:1]];
    [self configDataWithTaskID:mk_mu_taskConfigLowPowerPromptOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLowPowerPayloadStatus:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0101060101" : @"ed0101060100");
    [self configDataWithTaskID:mk_mu_taskConfigLowPowerPayloadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLowPowerPayloadInterval:(NSInteger)interval
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01010701" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigLowPowerPayloadIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configAutoPowerOnAfterCharging:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0101080101" : @"ed0101080100");
    [self configDataWithTaskID:mk_mu_taskConfigAutoPowerOnAfterChargingOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙相关参数************************************************

+ (void)mu_configNeedPassword:(BOOL)need
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (need ? @"ed0102000101" : @"ed0102000100");
    [self configDataWithTaskID:mk_mu_taskConfigNeedPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configPassword:(NSString *)password
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length != 8) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *commandString = [@"ed01020108" stringByAppendingString:commandData];
    [self configDataWithTaskID:mk_mu_taskConfigPasswordOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBroadcastTimeout:(NSInteger)timeout
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 60) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [@"ed01020201" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigBroadcastTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBeaconStatus:(BOOL)isOn
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0102030101" : @"ed0102030100");
    [self configDataWithTaskID:mk_mu_taskConfigBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configAdvInterval:(NSInteger)interval
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01020401" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigAdvIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTxPower:(mk_mu_txPower)txPower
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [@"ed01020501" stringByAppendingString:[MKMUSDKDataAdopter fetchTxPower:txPower]];
    [self configDataWithTaskID:mk_mu_taskConfigTxPowerOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configDeviceName:(NSString *)deviceName
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (![deviceName isKindOfClass:NSString.class] || deviceName.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)deviceName.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"ed010206%@%@",lenString,tempString];
    [self configDataWithTaskID:mk_mu_taskConfigDeviceNameOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}





+ (void)mu_startBleAdvWithSucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed013600";
    [self configDataWithTaskID:mk_mu_taskConfigStartBleAdvOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************模式相关参数************************************************
+ (void)mu_configWorkMode:(mk_mu_deviceMode)deviceMode
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKMUSDKDataAdopter fetchDeviceModeValue:deviceMode];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01030001",value];
    [self configDataWithTaskID:mk_mu_taskConfigWorkModeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configStandbyModePositioningStrategy:(mk_mu_positioningStrategy)strategy
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01031001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigStandbyModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configPeriodicModePositioningStrategy:(mk_mu_positioningStrategy)strategy
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01032001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigPeriodicModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configPeriodicModeReportInterval:(long long)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 30 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed01032104" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigPeriodicModeReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTimingModePositioningStrategy:(mk_mu_positioningStrategy)strategy
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01033001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigTimingModePositioningStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTimingModeReportingTimePoint:(NSArray <mk_mu_timingModeReportingTimePointProtocol>*)dataList
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dataString = [MKMUSDKDataAdopter fetchTimingModeReportingTimePoint:dataList];
    if (!MKValidStr(dataString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed010331" stringByAppendingString:dataString];
    [self configDataWithTaskID:mk_mu_taskConfigTimingModeReportingTimePointOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsNotifyEventOnStart:(BOOL)isOn
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103400101" : @"ed0103400100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsNotifyEventOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsFixOnStart:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103410101" : @"ed0103410100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsFixOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModePosStrategyOnStart:(mk_mu_positioningStrategy)strategy
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01034201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModePosStrategyOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeNumberOfFixOnStart:(NSInteger)number
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [@"ed01034301" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeNumberOfFixOnStartOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsNotifyEventInTrip:(BOOL)isOn
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103500101" : @"ed0103500100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsNotifyEventInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsFixInTrip:(BOOL)isOn
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103510101" : @"ed0103510100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsFixInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModePosStrategyInTrip:(mk_mu_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01035201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModePosStrategyInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeReportIntervalInTrip:(long long)interval
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 86400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:4];
    NSString *commandString = [@"ed01035304" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeReportIntervalInTripOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsNotifyEventOnEnd:(BOOL)isOn
                                         sucBlock:(void (^)(void))sucBlock
                                      failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103600101" : @"ed0103600100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsNotifyEventOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsFixOnEnd:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103610101" : @"ed0103610100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsFixOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModePosStrategyOnEnd:(mk_mu_positioningStrategy)strategy
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01036201" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModePosStrategyOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeReportIntervalOnEnd:(NSInteger)interval
                                      sucBlock:(void (^)(void))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 10 || interval > 300) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01036302" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeReportIntervalOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeNumberOfFixOnEnd:(NSInteger)number
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [@"ed01036401" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeNumberOfFixOnEndOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeTripEndTimeout:(NSInteger)time
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (time < 3 || time > 180) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:time byteLen:1];
    NSString *commandString = [@"ed01036501" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeTripEndTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configMotionModeEventsFixOnStationaryState:(BOOL)isOn
                                             sucBlock:(void (^)(void))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0103700101" : @"ed0103700100");
    [self configDataWithTaskID:mk_mu_taskConfigMotionModeEventsFixOnStationaryStateOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configPosStrategyOnStationary:(mk_mu_positioningStrategy)strategy
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01037101" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigPosStrategyOnStationaryOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configReportIntervalOnStationary:(NSInteger)interval
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01037202" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigReportIntervalOnStationaryOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTimeSegmentedModeStrategy:(mk_mu_positioningStrategy)strategy
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01038001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigTimeSegmentedModeStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTimeSegmentedModeTimePeriodSetting:(NSArray <mk_mu_timeSegmentedModeTimePeriodSettingProtocol>*)dataList
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *dataString = [MKMUSDKDataAdopter fetchimeSegmentedModeTimePeriodSetting:dataList];
    if (!MKValidStr(dataString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed010381" stringByAppendingString:dataString];
    [self configDataWithTaskID:mk_mu_taskConfigTimeSegmentedModeTimePeriodSettingOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙扫描过滤参数************************************************

+ (void)mu_configRssiFilterValue:(NSInteger)rssi
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (rssi < -127 || rssi > 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01040101",rssiValue];
    [self configDataWithTaskID:mk_mu_taskConfigRssiFilterValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterRelationship:(mk_mu_filterRelationship)relationship
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:relationship byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01040201",value];
    [self configDataWithTaskID:mk_mu_taskConfigFilterRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByMacPreciseMatch:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104100101" : @"ed0104100100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByMacPreciseMatchOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByMacReverseFilter:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104110101" : @"ed0104110100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByMacReverseFilterOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterMACAddressList:(NSArray <NSString *>*)macList
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (macList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *macString = @"";
    if (MKValidArray(macList)) {
        for (NSString *mac in macList) {
            if ((mac.length % 2 != 0) || !MKValidStr(mac) || mac.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:mac]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(mac.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:mac];
            macString = [macString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(macString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed010412%@%@",dataLen,macString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterMACAddressListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByAdvNamePreciseMatch:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104180101" : @"ed0104180100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByAdvNamePreciseMatchOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByAdvNameReverseFilter:(BOOL)isOn
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104190101" : @"ed0104190100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByAdvNameReverseFilterOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterAdvNameList:(NSArray <NSString *>*)nameList
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (nameList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidArray(nameList)) {
        //无列表
        NSString *commandString = @"ee01041a010000";
        [self configDataWithTaskID:mk_mu_taskConfigFilterAdvNameListOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSString *nameString = @"";
    if (MKValidArray(nameList)) {
        for (NSString *name in nameList) {
            if (!MKValidStr(name) || name.length > 20 || ![MKBLEBaseSDKAdopter asciiString:name]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *nameAscii = @"";
            for (NSInteger i = 0; i < name.length; i ++) {
                int asciiCode = [name characterAtIndex:i];
                nameAscii = [nameAscii stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(nameAscii.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:nameAscii];
            nameString = [nameString stringByAppendingString:string];
        }
    }
    NSInteger totalLen = nameString.length / 2;
    NSInteger totalNum = (totalLen / maxDataLen);
    if (totalLen % maxDataLen != 0) {
        totalNum ++;
    }
    NSMutableArray *commandList = [NSMutableArray array];
    for (NSInteger i = 0; i < totalNum; i ++) {
        NSString *tempString = @"";
        if (i == totalNum - 1) {
            //最后一帧
            tempString = [nameString substringFromIndex:(i * 2 * maxDataLen)];
        }else {
            tempString = [nameString substringWithRange:NSMakeRange(i * 2 * maxDataLen, 2 * maxDataLen)];
        }
        [commandList addObject:tempString];
    }
    NSString *totalNumberHex = [MKBLEBaseSDKAdopter fetchHexValue:totalNum byteLen:1];
    
    __block NSInteger commandIndex = 0;
    dispatch_queue_t dataQueue = dispatch_queue_create("filterNameListQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dataQueue);
    //当2s内没有接收到新的数据的时候，也认为是接受超时
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 0.05 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (commandIndex >= commandList.count) {
            //停止
            dispatch_cancel(timer);
            MKMUOperation *operation = [[MKMUOperation alloc] initOperationWithID:mk_mu_taskConfigFilterAdvNameListOperation commandBlock:^{
                
            } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
                BOOL success = [returnData[@"success"] boolValue];
                if (!success) {
                    [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
                    return ;
                }
                if (sucBlock) {
                    sucBlock();
                }
            }];
            [[MKMUCentralManager shared] addOperation:operation];
            return;
        }
        NSString *tempCommandString = commandList[commandIndex];
        NSString *indexHex = [MKBLEBaseSDKAdopter fetchHexValue:commandIndex byteLen:1];
        NSString *totalLenHex = [MKBLEBaseSDKAdopter fetchHexValue:(tempCommandString.length / 2) byteLen:1];
        NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ee01041a",totalNumberHex,indexHex,totalLenHex,tempCommandString];
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandString characteristic:[MKBLEBaseCentralManager shared].peripheral.mu_custom type:CBCharacteristicWriteWithResponse];
        commandIndex ++;
    });
    dispatch_resume(timer);
}

+ (void)mu_configFilterByBeaconStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104200101" : @"ed0104200100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBeaconMajorWithMinValue:(NSInteger)minValue
                                        maxValue:(NSInteger)maxValue
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01042104",minString,maxString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBeaconMinorWithMinValue:(NSInteger)minValue
                                        maxValue:(NSInteger)maxValue
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01042204",minString,maxString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBeaconUUID:(NSString *)uuid
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010423",lenString,uuid];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBeaconUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByUIDStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104280101" : @"ed0104280100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByUIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByUIDNamespaceID:(NSString *)namespaceID
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (namespaceID.length > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!namespaceID) {
        namespaceID = @"";
    }
    if (MKValidStr(namespaceID)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID] || namespaceID.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(namespaceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010429",lenString,namespaceID];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByUIDNamespaceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByUIDInstanceID:(NSString *)instanceID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (instanceID.length > 12) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!instanceID) {
        instanceID = @"";
    }
    if (MKValidStr(instanceID)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:instanceID] || instanceID.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(instanceID.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01042a",lenString,instanceID];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByUIDInstanceIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByURLStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104300101" : @"ed0104300100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByURLStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByURLContent:(NSString *)content
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (content.length > 100 || ![MKBLEBaseSDKAdopter asciiString:content]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (content.length == 0) {
        NSString *commandString = @"ed01043100";
        [self configDataWithTaskID:mk_mu_taskConfigFilterByURLContentOperation
                              data:commandString
                          sucBlock:sucBlock
                       failedBlock:failedBlock];
        return;
    }
    NSString *tempString = @"";
    for (NSInteger i = 0; i < content.length; i ++) {
        int asciiCode = [content characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:content.length byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010431",lenString,tempString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByURLContentOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByTLMStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104380101" : @"ed0104380100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByTLMStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByTLMVersion:(mk_mu_filterByTLMVersion)version
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *versionString = @"00";
    if (version == mk_mu_filterByTLMVersion_0) {
        versionString = @"01";
    }else if (version == mk_mu_filterByTLMVersion_1) {
        versionString = @"02";
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01043901",versionString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByTLMVersionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPBeaconStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104400101" : @"ed0104400100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPBeaconStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPBeaconMajorWithMinValue:(NSInteger)minValue
                                           maxValue:(NSInteger)maxValue
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01044104",minString,maxString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPBeaconMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPBeaconMinorWithMinValue:(NSInteger)minValue
                                           maxValue:(NSInteger)maxValue
                                           sucBlock:(void (^)(void))sucBlock
                                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01044204",minString,maxString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPBeaconMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPBeaconUUID:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (uuid.length > 32) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!uuid) {
        uuid = @"";
    }
    if (MKValidStr(uuid)) {
        if (![MKBLEBaseSDKAdopter checkHexCharacter:uuid] || uuid.length % 2 != 0) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(uuid.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed010443",lenString,uuid];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPBeaconUUIDOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBXPAccFilterStatus:(BOOL)isOn
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104500101" : @"ed0104500100");
    [self configDataWithTaskID:mk_mu_taskConfigBXPAccFilterStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBXPTHFilterStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104580101" : @"ed0104580100");
    [self configDataWithTaskID:mk_mu_taskConfigBXPTHFilterStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPDeviceInfoStatus:(BOOL)isOn
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104600101" : @"ed0104600100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPDeviceInfoStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPButtonStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104680101" : @"ed0104680100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPButtonStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPButtonAlarmStatus:(BOOL)singlePress
                                  doublePress:(BOOL)doublePress
                                    longPress:(BOOL)longPress
                           abnormalInactivity:(BOOL)abnormalInactivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01046904",(singlePress ? @"01" : @"00"),(doublePress ? @"01" : @"00"),(longPress ? @"01" : @"00"),(abnormalInactivity ? @"01" : @"00")];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPButtonAlarmStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByBXPTagIDStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104700101" : @"ed0104700100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByBXPTagIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configPreciseMatchTagIDStatus:(BOOL)isOn
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104710101" : @"ed0104710100");
    [self configDataWithTaskID:mk_mu_taskConfigPreciseMatchTagIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configReverseFilterTagIDStatus:(BOOL)isOn
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104720101" : @"ed0104720100");
    [self configDataWithTaskID:mk_mu_taskConfigReverseFilterTagIDStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterBXPTagIDList:(NSArray <NSString *>*)tagIDList
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (tagIDList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *tagIDString = @"";
    if (MKValidArray(tagIDList)) {
        for (NSString *tagID in tagIDList) {
            if ((tagID.length % 2 != 0) || !MKValidStr(tagID) || tagID.length > 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:tagID]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagID.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:tagID];
            tagIDString = [tagIDString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagIDString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed010473%@%@",dataLen,tagIDString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterBXPTagIDListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByTofStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104780101" : @"ed0104780100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByTofStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterBXPTofList:(NSArray <NSString *>*)codeList
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (codeList.count > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *codeString = @"";
    if (MKValidArray(codeList)) {
        for (NSString *code in codeList) {
            if ((code.length % 2 != 0) || !MKValidStr(code) || code.length > 4 || ![MKBLEBaseSDKAdopter checkHexCharacter:code]) {
                [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
                return;
            }
            NSString *tempLen = [MKBLEBaseSDKAdopter fetchHexValue:(code.length / 2) byteLen:1];
            NSString *string = [tempLen stringByAppendingString:code];
            codeString = [codeString stringByAppendingString:string];
        }
    }
    NSString *dataLen = [MKBLEBaseSDKAdopter fetchHexValue:(codeString.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"ed010479%@%@",dataLen,codeString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterBXPTofListOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirStatus:(BOOL)isOn
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104800101" : @"ed0104800100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirDetectionStatus:(mk_mu_detectionStatus)status
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:status byteLen:1];
    NSString *commandString = [@"ed01048101" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirDetectionStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirSensorSensitivity:(mk_mu_sensorSensitivity)sensitivity
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:sensitivity byteLen:1];
    NSString *commandString = [@"ed01048201" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirSensorSensitivityOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirDoorStatus:(mk_mu_doorStatus)status
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:status byteLen:1];
    NSString *commandString = [@"ed01048301" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirDoorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirDelayResponseStatus:(mk_mu_delayResponseStatus)status
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:status byteLen:1];
    NSString *commandString = [@"ed01048401" stringByAppendingString:valueString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirDelayResponseStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirMajorMinValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01048504",minString,maxString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirMajorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByPirMinorMinValue:(NSInteger)minValue
                                 maxValue:(NSInteger)maxValue
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (minValue < 0 || minValue > 65535 || maxValue < minValue || maxValue > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *minString = [MKBLEBaseSDKAdopter fetchHexValue:minValue byteLen:2];
    NSString *maxString = [MKBLEBaseSDKAdopter fetchHexValue:maxValue byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01048604",minString,maxString];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByPirMinorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByOtherStatus:(BOOL)isOn
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0104f80101" : @"ed0104f80100");
    [self configDataWithTaskID:mk_mu_taskConfigFilterByOtherStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByOtherRelationship:(mk_mu_filterByOther)relationship
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKMUSDKDataAdopter parseOtherRelationshipToCmd:relationship];
    NSString *commandString = [@"ed0104f901" stringByAppendingString:type];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByOtherRelationshipOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configFilterByOtherConditions:(NSArray <mk_mu_BLEFilterRawDataProtocol>*)conditions
                                sucBlock:(void (^)(void))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!conditions || ![conditions isKindOfClass:NSArray.class] || conditions.count > 3) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *dataContent = @"";
    for (id <mk_mu_BLEFilterRawDataProtocol>protocol in conditions) {
        if (![MKMUSDKDataAdopter isConfirmRawFilterProtocol:protocol]) {
            [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
            return;
        }
        NSString *start = [MKBLEBaseSDKAdopter fetchHexValue:protocol.minIndex byteLen:1];
        NSString *end = [MKBLEBaseSDKAdopter fetchHexValue:protocol.maxIndex byteLen:1];
        NSString *content = [NSString stringWithFormat:@"%@%@%@%@",protocol.dataType,start,end,protocol.rawData];
        NSString *tempLenString = [MKBLEBaseSDKAdopter fetchHexValue:(content.length / 2) byteLen:1];
        dataContent = [dataContent stringByAppendingString:[tempLenString stringByAppendingString:content]];
    }
    NSString *lenString = [MKBLEBaseSDKAdopter fetchHexValue:(dataContent.length / 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed0104fa",lenString,dataContent];
    [self configDataWithTaskID:mk_mu_taskConfigFilterByOtherConditionsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************设备lorawan信息设置************************************************

+ (void)mu_configRegion:(mk_mu_loraWanRegion)region
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01050101",[MKMUSDKDataAdopter lorawanRegionString:region]];
    [self configDataWithTaskID:mk_mu_taskConfigRegionOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configModem:(mk_mu_loraWanModem)modem
              sucBlock:(void (^)(void))sucBlock
           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (modem == mk_mu_loraWanModemABP) ? @"ed0105020101" : @"ed0105020102";
    [self configDataWithTaskID:mk_mu_taskConfigModemOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configDEVEUI:(NSString *)devEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devEUI) || devEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:devEUI]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050308" stringByAppendingString:devEUI];
    [self configDataWithTaskID:mk_mu_taskConfigDEVEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configAPPEUI:(NSString *)appEUI
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appEUI) || appEUI.length != 16 || ![MKBLEBaseSDKAdopter checkHexCharacter:appEUI]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050408" stringByAppendingString:appEUI];
    [self configDataWithTaskID:mk_mu_taskConfigAPPEUIOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configAPPKEY:(NSString *)appKey
               sucBlock:(void (^)(void))sucBlock
            failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appKey) || appKey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appKey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050510" stringByAppendingString:appKey];
    [self configDataWithTaskID:mk_mu_taskConfigAPPKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configDEVADDR:(NSString *)devAddr
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(devAddr) || devAddr.length != 8 || ![MKBLEBaseSDKAdopter checkHexCharacter:devAddr]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050604" stringByAppendingString:devAddr];
    [self configDataWithTaskID:mk_mu_taskConfigDEVADDROperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configAPPSKEY:(NSString *)appSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(appSkey) || appSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:appSkey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050710" stringByAppendingString:appSkey];
    [self configDataWithTaskID:mk_mu_taskConfigAPPSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configNWKSKEY:(NSString *)nwkSkey
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(nwkSkey) || nwkSkey.length != 32 || ![MKBLEBaseSDKAdopter checkHexCharacter:nwkSkey]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandString = [@"ed01050810" stringByAppendingString:nwkSkey];
    [self configDataWithTaskID:mk_mu_taskConfigNWKSKEYOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLorawanADRACKLimit:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 1 || value > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01050a01",valueString];
    [self configDataWithTaskID:mk_mu_taskConfigLorawanADRACKLimitOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLorawanADRACKDelay:(NSInteger)value
                           sucBlock:(void (^)(void))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (value < 1 || value > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *valueString = [MKBLEBaseSDKAdopter fetchHexValue:value byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01050b01",valueString];
    [self configDataWithTaskID:mk_mu_taskConfigLorawanADRACKDelayOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configCHL:(NSInteger)chlValue
                 CHH:(NSInteger)chhValue
            sucBlock:(void (^)(void))sucBlock
         failedBlock:(void (^)(NSError *error))failedBlock {
    if (chlValue < 0 || chlValue > 95 || chhValue < chlValue || chhValue > 95) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *lowValue = [MKBLEBaseSDKAdopter fetchHexValue:chlValue byteLen:1];
    NSString *highValue = [MKBLEBaseSDKAdopter fetchHexValue:chhValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01052002",lowValue,highValue];
    [self configDataWithTaskID:mk_mu_taskConfigCHValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configDR:(NSInteger)drValue
           sucBlock:(void (^)(void))sucBlock
        failedBlock:(void (^)(NSError *error))failedBlock {
    if (drValue < 0 || drValue > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:drValue byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01052101",value];
    [self configDataWithTaskID:mk_mu_taskConfigDRValueOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configUplinkStrategy:(BOOL)isOn
                  transmissions:(NSInteger)transmissions
                            DRL:(NSInteger)DRL
                            DRH:(NSInteger)DRH
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (!isOn && (DRL < 0 || DRL > 6 || DRH < DRL || DRH > 6 || transmissions < 1 || transmissions > 2)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    
    NSString *lowValue = [MKBLEBaseSDKAdopter fetchHexValue:DRL byteLen:1];
    NSString *highValue = [MKBLEBaseSDKAdopter fetchHexValue:DRH byteLen:1];
    NSString *transmissionsValue = [MKBLEBaseSDKAdopter fetchHexValue:transmissions byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ed01052204",(isOn ? @"01" : @"00"),transmissionsValue,lowValue,highValue];
    [self configDataWithTaskID:mk_mu_taskConfigUplinkStrategyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configDutyCycleStatus:(BOOL)isOn
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0105230101" : @"ed0105230100");
    [self configDataWithTaskID:mk_mu_taskConfigDutyCycleStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configTimeSyncInterval:(NSInteger)interval
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01054001" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigTimeSyncIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLorawanNetworkCheckInterval:(NSInteger)interval
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 0 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01054101" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskConfigNetworkCheckIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configHeartbeatPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                             retransmissionTimes:(NSInteger)times
                                        sucBlock:(void (^)(void))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055102",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigHeartbeatPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configLowPowerPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                            retransmissionTimes:(NSInteger)times
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055202",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigLowPowerPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configEventPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                         retransmissionTimes:(NSInteger)times
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055402",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigEventPayloadWithMessageTypeOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configPositioningPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                               retransmissionTimes:(NSInteger)times
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055502",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigPositioningPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configShockPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                         retransmissionTimes:(NSInteger)times
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055702",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigShockPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configManDownDetectionPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                                    retransmissionTimes:(NSInteger)times
                                               sucBlock:(void (^)(void))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055802",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigManDownDetectionPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configGPSLimitPayloadWithMessageType:(mk_mu_loraWanMessageType)type
                            retransmissionTimes:(NSInteger)times
                                       sucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    if (times < 1 || times > 4) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *typeValue = [MKBLEBaseSDKAdopter fetchHexValue:type byteLen:1];
    NSString *timeValue = [MKBLEBaseSDKAdopter fetchHexValue:times byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ed01055b02",typeValue,timeValue];
    [self configDataWithTaskID:mk_mu_taskConfigGPSLimitPayloadOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************辅助功能************************************************

+ (void)mu_configDownlinkPositioningStrategy:(mk_mu_positioningStrategy)strategy
                                    sucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *strategyString = [MKMUSDKDataAdopter fetchPositioningStrategyCommand:strategy];
    NSString *commandString = [@"ed01060001" stringByAppendingString:strategyString];
    [self configDataWithTaskID:mk_mu_taskConfigDownlinkPositioningStrategyyOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configShockDetectionStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0106100101" : @"ed0106100100");
    [self configDataWithTaskID:mk_mu_taskConfigShockDetectionStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configShockThresholds:(NSInteger)threshold
                        sucBlock:(void (^)(void))sucBlock
                     failedBlock:(void (^)(NSError *error))failedBlock {
    if (threshold < 10 || threshold > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *thresholdString = [MKBLEBaseSDKAdopter fetchHexValue:threshold byteLen:1];
    NSString *commandString = [@"ed01061101" stringByAppendingString:thresholdString];
    [self configDataWithTaskID:mk_mu_taskConfigShockThresholdsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configShockDetectionReportInterval:(NSInteger)interval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 3 || interval > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01061201" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_mu_taskConfigShockDetectionReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configShockTimeout:(NSInteger)interval
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [@"ed01061301" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_mu_taskConfigShockTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configManDownDetectionStatus:(BOOL)isOn
                               sucBlock:(void (^)(void))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0106200101" : @"ed0106200100");
    [self configDataWithTaskID:mk_mu_taskConfigManDownDetectionStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configIdleDetectionTimeout:(NSInteger)interval
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 8760) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *intervalString = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [@"ed01062102" stringByAppendingString:intervalString];
    [self configDataWithTaskID:mk_mu_taskConfigIdleDetectionTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configIdleStutasResetWithSucBlock:(void (^)(void))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01062200";
    [self configDataWithTaskID:mk_mu_taskConfigIdleStutasResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************蓝牙定位参数************************************************
+ (void)mu_configOfflineFix:(BOOL)isOn
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0108000101" : @"ed0108000100");
    [self configDataWithTaskID:mk_mu_taskConfigOfflineFixOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configGpsLimitUploadStatus:(BOOL)isOn
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0108010101" : @"ed0108010100");
    [self configDataWithTaskID:mk_mu_taskConfigGpsLimitUploadStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configOutdoorBLEReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01080801",value];
    [self configDataWithTaskID:mk_mu_taskConfigOutdoorBLEReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configOutdoorGPSReportInterval:(NSInteger)interval
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (interval < 1 || interval > 14400) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:interval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01080902",value];
    [self configDataWithTaskID:mk_mu_taskConfigOutdoorGPSReportIntervalOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBluetoothFixMechanism:(mk_mu_bluetoothFixMechanism)priority
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *type = [MKMUSDKDataAdopter fetchBluetoothFixMechanismString:priority];
    NSString *commandString = [@"ed01082001" stringByAppendingString:type];
    [self configDataWithTaskID:mk_mu_taskConfigBluetoothFixMechanismOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBlePositioningTimeout:(NSInteger)timeout
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 1 || timeout > 10) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01082101",value];
    [self configDataWithTaskID:mk_mu_taskConfigBlePositioningTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBlePositioningNumberOfMac:(NSInteger)number
                                  sucBlock:(void (^)(void))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (number < 1 || number > 15) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:number byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01082201",value];
    [self configDataWithTaskID:mk_mu_taskConfigBlePositioningNumberOfMacOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configBeaconVoltageReportInBleFixStatus:(BOOL)isOn
                                          sucBlock:(void (^)(void))sucBlock
                                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ed0108230101" : @"ed0108230100");
    [self configDataWithTaskID:mk_mu_taskConfigBeaconVoltageReportInBleFixStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configGPSFixPositioningTimeout:(NSInteger)timeout
                                 sucBlock:(void (^)(void))sucBlock
                              failedBlock:(void (^)(NSError *error))failedBlock {
    if (timeout < 30 || timeout > 600) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:timeout byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01083002",value];
    [self configDataWithTaskID:mk_mu_taskConfigGPSFixPositioningTimeoutOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_configGPSFixPDOP:(NSInteger)pdop
                   sucBlock:(void (^)(void))sucBlock
                failedBlock:(void (^)(NSError *error))failedBlock {
    if (pdop < 25 || pdop > 100) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:pdop byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ed01083101",value];
    [self configDataWithTaskID:mk_mu_taskConfigGPSFixPDOPOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark ****************************************存储数据协议************************************************

+ (void)mu_readNumberOfDaysStoredData:(NSInteger)days
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (days < 1 || days > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *value = [MKBLEBaseSDKAdopter fetchHexValue:days byteLen:2];
    NSString *commandString = [@"ed01090002" stringByAppendingString:value];
    [self configDataWithTaskID:mk_mu_taskReadNumberOfDaysStoredDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_clearAllDatasWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ed01090100";
    [self configDataWithTaskID:mk_mu_taskClearAllDatasOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)mu_pauseSendLocalData:(BOOL)pause
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (pause ? @"ed0109020100" : @"ed0109020100");
    [self configDataWithTaskID:mk_mu_taskPauseSendLocalDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_mu_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:centralManager.peripheral.mu_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
