//
//  MKMUTaskAdopter.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKMUOperationID.h"
#import "MKMUSDKDataAdopter.h"

NSString *const mk_mu_totalNumKey = @"mk_mu_totalNumKey";
NSString *const mk_mu_totalIndexKey = @"mk_mu_totalIndexKey";
NSString *const mk_mu_contentKey = @"mk_mu_contentKey";

@implementation MKMUTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_mu_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_mu_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_mu_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_mu_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_mu_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //密码相关
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:readData];
        NSString *state = @"";
        if (content.length == 10) {
            state = [content substringWithRange:NSMakeRange(8, 2)];
        }
        return [self dataParserGetDataSuccess:@{@"state":state} operationID:mk_mu_connectPasswordOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        return [self parseCustomData:readData];
    }
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    if ([headerString isEqualToString:@"ee"]) {
        //分包协议
        return [self parsePacketData:readData];
    }
    if (![headerString isEqualToString:@"ed"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parsePacketData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    if ([flag isEqualToString:@"00"]) {
        //读取
        NSString *totalNum = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(6, 2)];
        NSString *index = [MKBLEBaseSDKAdopter getDecimalStringWithHex:readString range:NSMakeRange(8, 2)];
        NSInteger len = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(10, 2)];
        if ([index integerValue] >= [totalNum integerValue]) {
            return @{};
        }
        mk_mu_taskOperationID operationID = mk_mu_defaultTaskOperationID;
        
        NSData *subData = [readData subdataWithRange:NSMakeRange(6, len)];
        NSDictionary *resultDic= @{
            mk_mu_totalNumKey:totalNum,
            mk_mu_totalIndexKey:index,
            mk_mu_contentKey:(subData ? subData : [NSData data]),
        };
        if ([cmd isEqualToString:@"58"]) {
            //读取Adv Name过滤规则
            operationID = mk_mu_taskReadFilterAdvNameListOperation;
        }
        return [self dataParserGetDataSuccess:resultDic operationID:operationID];
    }
    if ([flag isEqualToString:@"01"]) {
        //配置
        mk_mu_taskOperationID operationID = mk_mu_defaultTaskOperationID;
        NSString *content = [readString substringWithRange:NSMakeRange(8, 2)];
        BOOL success = [content isEqualToString:@"01"];
        
        if ([cmd isEqualToString:@"58"]) {
            //配置Adv Name过滤规则
            operationID = mk_mu_taskConfigFilterAdvNameListOperation;
        }
        return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_mu_taskOperationID operationID = mk_mu_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"01"]) {
        
    }else if ([cmd isEqualToString:@"14"]) {
        //读取时区
        resultDic = @{
            @"timeZone":[MKBLEBaseSDKAdopter signedHexTurnString:content],
        };
        operationID = mk_mu_taskReadTimeZoneOperation;
    }else if ([cmd isEqualToString:@"15"]) {
        //读取工作模式
        NSInteger mode = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"mode":[NSString stringWithFormat:@"%ld",(mode - 1)],
        };
        operationID = mk_mu_taskReadWorkModeOperation;
    }else if ([cmd isEqualToString:@"16"]) {
        //读取指示灯功能
        NSDictionary *indicatorSettings = [MKMUSDKDataAdopter fetchIndicatorSettings:content];
        resultDic = @{
            @"indicatorSettings":indicatorSettings,
        };
        operationID = mk_mu_taskReadIndicatorSettingsOperation;
    }else if ([cmd isEqualToString:@"17"]) {
        //读取设备心跳间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadHeartbeatIntervalOperation;
    }else if ([cmd isEqualToString:@"19"]) {
        //读取关机信息上报
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_mu_taskReadShutdownPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"1a"]) {
        //读取离线定位功能开关状态
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_mu_taskReadOfflineFixStatusOperation;
    }else if ([cmd isEqualToString:@"1b"]) {
        //读取低电触发心跳开关状态
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_mu_taskReadLowPowerPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"1c"]) {
        //读取低电百分比
        resultDic = @{
            @"prompt":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLowPowerPromptOperation;
    }else if ([cmd isEqualToString:@"1e"]) {
        //读取霍尔关机功能
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_mu_taskReadHallPowerOffStatusOperation;
    }else if ([cmd isEqualToString:@"20"]) {
        //读取电池电压
        resultDic = @{
            @"voltage":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadBatteryVoltageOperation;
    }else if ([cmd isEqualToString:@"21"]) {
        //读取MAC地址
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
        operationID = mk_mu_taskReadMacAddressOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //读取产测状态
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_mu_taskReadPCBAStatusOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //读取自检故障原因
//        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":content,
        };
        operationID = mk_mu_taskReadSelftestStatusOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //读取充电自动开机功能
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn),
        };
        operationID = mk_mu_taskReadAutoPowerOnAfterChargingOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //读取电池信息
        NSString *workTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 8)];
        NSString *advCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 8)];
        NSString *axisWakeupTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 8)];
        NSString *blePostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(24, 8)];
        NSString *gpsPostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 8)];
        NSString *loraSendCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(40, 8)];
        NSString *loraPowerConsumption = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(48, 8)];
        NSString *batteryPower = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(56, 8)];
        
        resultDic = @{
            @"workTimes":workTimes,
            @"advCount":advCount,
            @"axisWakeupTimes":axisWakeupTimes,
            @"blePostionTimes":blePostionTimes,
            @"gpsPostionTimes":gpsPostionTimes,
            @"loraSendCount":loraSendCount,
            @"loraPowerConsumption":loraPowerConsumption,
            @"batteryPower":batteryPower
        };
        operationID = mk_mu_taskReadBatteryInformationOperation;
    }else if ([cmd isEqualToString:@"27"]) {
        //读取上一周期电池电量消耗
        NSString *workTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 8)];
        NSString *advCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 8)];
        NSString *axisWakeupTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 8)];
        NSString *blePostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(24, 8)];
        NSString *gpsPostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 8)];
        NSString *loraSendCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(40, 8)];
        NSString *loraPowerConsumption = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(48, 8)];
        NSString *batteryPower = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(56, 8)];
        
        resultDic = @{
            @"workTimes":workTimes,
            @"advCount":advCount,
            @"axisWakeupTimes":axisWakeupTimes,
            @"blePostionTimes":blePostionTimes,
            @"gpsPostionTimes":gpsPostionTimes,
            @"loraSendCount":loraSendCount,
            @"loraPowerConsumption":loraPowerConsumption,
            @"batteryPower":batteryPower
        };
        operationID = mk_mu_taskReadLastCycleBatteryInformationOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //读取所有周期电池电量消耗
        NSString *workTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 8)];
        NSString *advCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 8)];
        NSString *axisWakeupTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(16, 8)];
        NSString *blePostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(24, 8)];
        NSString *gpsPostionTimes = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(32, 8)];
        NSString *loraSendCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(40, 8)];
        NSString *loraPowerConsumption = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(48, 8)];
        NSString *batteryPower = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(56, 8)];
        
        resultDic = @{
            @"workTimes":workTimes,
            @"advCount":advCount,
            @"axisWakeupTimes":axisWakeupTimes,
            @"blePostionTimes":blePostionTimes,
            @"gpsPostionTimes":gpsPostionTimes,
            @"loraSendCount":loraSendCount,
            @"loraPowerConsumption":loraPowerConsumption,
            @"batteryPower":batteryPower
        };
        operationID = mk_mu_taskReadAllCycleBatteryInformationOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //读取低电状态下低电信息包上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLowPowerPayloadIntervalOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //读取GPS极限上传开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadGpsLimitUploadStatusOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //读取密码开关
        BOOL need = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"need":@(need)
        };
        operationID = mk_mu_taskReadConnectationNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //读取密码
        NSData *passwordData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"password":(MKValidStr(password) ? password : @""),
        };
        operationID = mk_mu_taskReadPasswordOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //读取广播超时时长
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadBroadcastTimeoutOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //读取设备Tx Power
        NSString *txPower = [MKMUSDKDataAdopter fetchTxPowerValueString:content];
        resultDic = @{@"txPower":txPower};
        operationID = mk_mu_taskReadTxPowerOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //读取设备广播名称
        NSData *nameData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        NSString *deviceName = [[NSString alloc] initWithData:nameData encoding:NSUTF8StringEncoding];
        resultDic = @{
            @"deviceName":(MKValidStr(deviceName) ? deviceName : @""),
        };
        operationID = mk_mu_taskReadDeviceNameOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //读取广播间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //读取Beacon模式开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //读取待机模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadStandbyModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //读取定期模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadPeriodicModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //读取定期模式上报间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":interval,
        };
        operationID = mk_mu_taskReadPeriodicModeReportIntervalOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //读取定时模式定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadTimingModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"43"]) {
        //读取定时模式时间点
        NSArray *list = [MKMUSDKDataAdopter parseTimingModeReportingTimePoint:content];
        
        resultDic = @{
            @"pointList":list,
        };
        operationID = mk_mu_taskReadTimingModeReportingTimePointOperation;
    }else if ([cmd isEqualToString:@"44"]) {
        //读取运动模式事件
        NSString *binaryHex = [MKBLEBaseSDKAdopter binaryByhex:[content substringWithRange:NSMakeRange(0, content.length)]];
        
        BOOL notifyEventOnStart = [[binaryHex substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL fixOnStart = [[binaryHex substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        BOOL notifyEventInTrip = [[binaryHex substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"1"];
        BOOL fixInTrip = [[binaryHex substringWithRange:NSMakeRange(4, 1)] isEqualToString:@"1"];
        BOOL notifyEventOnEnd = [[binaryHex substringWithRange:NSMakeRange(3, 1)] isEqualToString:@"1"];
        BOOL fixOnEnd = [[binaryHex substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"1"];
        BOOL fixOnStationaryState = [[binaryHex substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"notifyEventOnStart":@(notifyEventOnStart),
            @"fixOnStart":@(fixOnStart),
            @"notifyEventInTrip":@(notifyEventInTrip),
            @"fixInTrip":@(fixInTrip),
            @"notifyEventOnEnd":@(notifyEventOnEnd),
            @"fixOnEnd":@(fixOnEnd),
            @"fixOnStationaryState":@(fixOnStationaryState)
        };
        operationID = mk_mu_taskReadMotionModeEventsOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //读取运动开始定位上报次数
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"number":number,
        };
        operationID = mk_mu_taskReadMotionModeNumberOfFixOnStartOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //读取运动开始定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadMotionModePosStrategyOnStartOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //读取运动中定位间隔
        NSString *interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"interval":interval,
        };
        operationID = mk_mu_taskReadMotionModeReportIntervalInTripOperation;
    }else if ([cmd isEqualToString:@"48"]) {
        //读取运动中定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadMotionModePosStrategyInTripOperation;
    }else if ([cmd isEqualToString:@"49"]) {
        //读取运动结束判断时间
        NSString *time = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"time":time,
        };
        operationID = mk_mu_taskReadMotionModeTripEndTimeoutOperation;
    }else if ([cmd isEqualToString:@"4a"]) {
        //读取运动结束判断时间
        NSString *number = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"number":number,
        };
        operationID = mk_mu_taskReadMotionModeNumberOfFixOnEndOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //读取运动结束定位间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadMotionModeReportIntervalOnEndOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //读取运动结束定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadMotionModePosStrategyOnEndOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //读取运动静止状态定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadPosStrategyOnStationaryOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //读取运动禁止状态上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadReportIntervalOnStationaryOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //读取RSSI过滤规则
        resultDic = @{
            @"rssi":[NSString stringWithFormat:@"%ld",(long)[[MKBLEBaseSDKAdopter signedHexTurnString:content] integerValue]],
        };
        operationID = mk_mu_taskReadRssiFilterValueOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //读取广播内容过滤逻辑
        resultDic = @{
            @"relationship":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadFilterRelationshipOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //读取精准过滤MAC开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByMacPreciseMatchOperation;
    }else if ([cmd isEqualToString:@"54"]) {
        //读取反向过滤MAC开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByMacReverseFilterOperation;
    }else if ([cmd isEqualToString:@"55"]) {
        //读取MAC过滤列表
        NSArray *macList = [MKMUSDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"macList":(MKValidArray(macList) ? macList : @[]),
        };
        operationID = mk_mu_taskReadFilterMACAddressListOperation;
    }else if ([cmd isEqualToString:@"56"]) {
        //读取精准过滤Adv Name开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByAdvNamePreciseMatchOperation;
    }else if ([cmd isEqualToString:@"57"]) {
        //读取反向过滤Adv Name开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByAdvNameReverseFilterOperation;
    }else if ([cmd isEqualToString:@"59"]) {
        //读取过滤设备类型开关
        BOOL iBeacon = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL uid = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        BOOL url = ([[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"]);
        BOOL tlm = ([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]);
        BOOL bxp_beacon = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]);
        BOOL bxp_deviceInfo = ([[content substringWithRange:NSMakeRange(10, 2)] isEqualToString:@"01"]);
        BOOL bxp_acc = ([[content substringWithRange:NSMakeRange(12, 2)] isEqualToString:@"01"]);
        BOOL bxp_th = ([[content substringWithRange:NSMakeRange(14, 2)] isEqualToString:@"01"]);
        BOOL bxp_button = ([[content substringWithRange:NSMakeRange(16, 2)] isEqualToString:@"01"]);
        BOOL bxp_tag = ([[content substringWithRange:NSMakeRange(18, 2)] isEqualToString:@"01"]);
        BOOL bxp_pir = ([[content substringWithRange:NSMakeRange(20, 2)] isEqualToString:@"01"]);
        BOOL bxp_tof = ([[content substringWithRange:NSMakeRange(22, 2)] isEqualToString:@"01"]);
        BOOL bxp_sensorInfo = ([[content substringWithRange:NSMakeRange(24, 2)] isEqualToString:@"01"]);
        BOOL other = ([[content substringWithRange:NSMakeRange(26, 2)] isEqualToString:@"01"]);
        resultDic = @{
            @"iBeacon":@(iBeacon),
            @"uid":@(uid),
            @"url":@(url),
            @"tlm":@(tlm),
            @"bxp_beacon":@(bxp_beacon),
            @"bxp_deviceInfo":@(bxp_deviceInfo),
            @"bxp_acc":@(bxp_acc),
            @"bxp_th":@(bxp_th),
            @"bxp_button":@(bxp_button),
            @"bxp_tag":@(bxp_tag),
            @"bxp_pir":@(bxp_pir),
            @"bxp_tof":@(bxp_tof),
            @"bxp_sensorInfo":@(bxp_sensorInfo),
            @"other":@(other)
        };
        operationID = mk_mu_taskReadFilterTypeStatusOperation;
    }else if ([cmd isEqualToString:@"5a"]) {
        //读取iBeacon类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"5b"]) {
        //读取iBeacon类型过滤的Major范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_mu_taskReadFilterByBeaconMajorRangeOperation;
    }else if ([cmd isEqualToString:@"5c"]) {
        //读取iBeacon类型过滤的Minor范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_mu_taskReadFilterByBeaconMinorRangeOperation;
    }else if ([cmd isEqualToString:@"5d"]) {
        //读取iBeacon类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_mu_taskReadFilterByBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //读取UID类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByUIDStatusOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //读取UID类型过滤的Namespace ID
        resultDic = @{
            @"namespaceID":content,
        };
        operationID = mk_mu_taskReadFilterByUIDNamespaceIDOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //读取UID类型过滤的Instance ID
        resultDic = @{
            @"instanceID":content,
        };
        operationID = mk_mu_taskReadFilterByUIDInstanceIDOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //读取URL类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByURLStatusOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //读取URL类型过滤内容
        NSString *url = @"";
        if (content.length > 0) {
            NSData *urlData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
            url = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        }
        resultDic = @{
            @"url":(MKValidStr(url) ? url : @""),
        };
        operationID = mk_mu_taskReadFilterByURLContentOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //读取TLM类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByTLMStatusOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //读取TLM过滤数据类型
        NSString *version = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"version":version
        };
        operationID = mk_mu_taskReadFilterByTLMVersionOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //读取BXP-iBeacon类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByBXPBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //读取BXP-iBeacon类型过滤的Major范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_mu_taskReadFilterByBXPBeaconMajorRangeOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //读取BXP-iBeacon类型过滤的Minor范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_mu_taskReadFilterByBXPBeaconMinorRangeOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //读取BXP-iBeacon类型过滤的UUID
        resultDic = @{
            @"uuid":content,
        };
        operationID = mk_mu_taskReadFilterByBXPBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //读取BXP-DeviceInfo类型过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPDeviceInfoFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //读取BeaconX Pro-ACC设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPAccFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //读取BeaconX Pro-T&H设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPTHFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //读取BXP-Button过滤条件开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPButtonFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //读取BXP-Button报警过滤开关
        BOOL singlePresse = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        BOOL doublePresse = ([[content substringWithRange:NSMakeRange(2, 2)] isEqualToString:@"01"]);
        BOOL longPresse = ([[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"]);
        BOOL abnormal = ([[content substringWithRange:NSMakeRange(6, 2)] isEqualToString:@"01"]);
        resultDic = @{
            @"singlePresse":@(singlePresse),
            @"doublePresse":@(doublePresse),
            @"longPresse":@(longPresse),
            @"abnormal":@(abnormal),
        };
        operationID = mk_mu_taskReadBXPButtonAlarmFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //读取BXP-TagID类型开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByBXPTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //读取BXP-TagID类型精准过滤tagID开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadPreciseMatchTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //读取读取BXP-TagID类型反向过滤tagID开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadReverseFilterTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"71"]) {
        //读取BXP-TagID过滤规则
        NSArray *tagIDList = [MKMUSDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"tagIDList":(MKValidArray(tagIDList) ? tagIDList : @[]),
        };
        operationID = mk_mu_taskReadFilterBXPTagIDListOperation;
    }else if ([cmd isEqualToString:@"72"]) {
        //读取PIR过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByPirStatusOperation;
    }else if ([cmd isEqualToString:@"73"]) {
        //读取PIR设备过滤sensor_detection_status
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_mu_taskReadFilterByPirDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"74"]) {
        //读取PIR设备过滤sensor_sensitivity
        NSString *sensitivity = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"sensitivity":sensitivity,
        };
        operationID = mk_mu_taskReadFilterByPirSensorSensitivityOperation;
    }else if ([cmd isEqualToString:@"75"]) {
        //读取PIR设备过滤door_status
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_mu_taskReadFilterByPirDoorStatusOperation;
    }else if ([cmd isEqualToString:@"76"]) {
        //读取PIR设备过滤delay_response_status
        NSString *status = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"status":status,
        };
        operationID = mk_mu_taskReadFilterByPirDelayResponseStatusOperation;
    }else if ([cmd isEqualToString:@"77"]) {
        //读取PIR设备Major过滤范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_mu_taskReadFilterByPirMajorRangeOperation;
    }else if ([cmd isEqualToString:@"78"]) {
        //读取PIR设备Minor过滤范围
        NSString *minValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 4)];
        NSString *maxValue = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        resultDic = @{
            @"maxValue":maxValue,
            @"minValue":minValue,
        };
        operationID = mk_mu_taskReadFilterByPirMinorRangeOperation;
    }else if ([cmd isEqualToString:@"79"]) {
        //读取BXP-TOF设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterBXPTofStatusOperation;
    }else if ([cmd isEqualToString:@"7a"]) {
        //读取BXP-TOF设备过滤MFG code
        NSArray *codeList = [MKMUSDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"codeList":(MKValidArray(codeList) ? codeList : @[]),
        };
        operationID = mk_mu_taskReadFilterBXPTofMfgCodeListOperation;
    }else if ([cmd isEqualToString:@"7b"]) {
        //读取BXP-SensorInfo设备过滤开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPSensorInfoFilterByTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"7c"]) {
        //读取BXP-SensorInfo类型精准过滤Tag-ID开关

        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPSensorInfoPreciseMatchTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"7d"]) {
        //读取BXP-SensorInfo类型反向过滤Tag-ID开关

        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadBXPSensorInfoReverseFilterTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"7e"]) {
        //读取BXP-SensorInfo类型设备Tag-ID过滤规则

        NSArray *tagIDList = [MKMUSDKDataAdopter parseFilterMacList:content];
        resultDic = @{
            @"tagIDList":(MKValidArray(tagIDList) ? tagIDList : @[]),
        };
        operationID = mk_mu_taskReadBXPSensorInfoFilterBXPTagIDListOperation;
    }else if ([cmd isEqualToString:@"8b"]) {
        //读取Other过滤条件开关
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadFilterByOtherStatusOperation;
    }else if ([cmd isEqualToString:@"8c"]) {
        //读取Other过滤条件的逻辑关系
        NSString *relationship = [MKMUSDKDataAdopter parseOtherRelationship:content];
        resultDic = @{
            @"relationship":relationship,
        };
        operationID = mk_mu_taskReadFilterByOtherRelationshipOperation;
    }else if ([cmd isEqualToString:@"8d"]) {
        //读取Other的过滤条件列表
        NSArray *conditionList = [MKMUSDKDataAdopter parseOtherFilterConditionList:content];
        resultDic = @{
            @"conditionList":conditionList,
        };
        operationID = mk_mu_taskReadFilterByOtherConditionsOperation;
    }else if ([cmd isEqualToString:@"90"]) {
        //读取LoRaWAN网络状态
        resultDic = @{
            @"status":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanNetworkStatusOperation;
    }else if ([cmd isEqualToString:@"91"]) {
        //读取LoRaWAN频段
        resultDic = @{
            @"region":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanRegionOperation;
    }else if ([cmd isEqualToString:@"92"]) {
        //读取LoRaWAN入网类型
        resultDic = @{
            @"modem":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanModemOperation;
    }else if ([cmd isEqualToString:@"93"]) {
        //读取LoRaWAN DEVEUI
        resultDic = @{
            @"devEUI":content,
        };
        operationID = mk_mu_taskReadLorawanDEVEUIOperation;
    }else if ([cmd isEqualToString:@"94"]) {
        //读取LoRaWAN APPEUI
        resultDic = @{
            @"appEUI":content
        };
        operationID = mk_mu_taskReadLorawanAPPEUIOperation;
    }else if ([cmd isEqualToString:@"95"]) {
        //读取LoRaWAN APPKEY
        resultDic = @{
            @"appKey":content
        };
        operationID = mk_mu_taskReadLorawanAPPKEYOperation;
    }else if ([cmd isEqualToString:@"96"]) {
        //读取LoRaWAN DEVADDR
        resultDic = @{
            @"devAddr":content
        };
        operationID = mk_mu_taskReadLorawanDEVADDROperation;
    }else if ([cmd isEqualToString:@"97"]) {
        //读取LoRaWAN APPSKEY
        resultDic = @{
            @"appSkey":content
        };
        operationID = mk_mu_taskReadLorawanAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"98"]) {
        //读取LoRaWAN nwkSkey
        resultDic = @{
            @"nwkSkey":content
        };
        operationID = mk_mu_taskReadLorawanNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"9a"]) {
        //读取LoRaWAN CH
        resultDic = @{
            @"CHL":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"CHH":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)]
        };
        operationID = mk_mu_taskReadLorawanCHOperation;
    }else if ([cmd isEqualToString:@"9b"]) {
        //读取LoRaWAN DR
        resultDic = @{
            @"DR":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanDROperation;
    }else if ([cmd isEqualToString:@"9c"]) {
        //读取LoRaWAN 数据发送策略
        BOOL isOn = ([[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"]);
        NSString *transmissions = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *DRL = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        NSString *DRH = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 2)];
        resultDic = @{
            @"isOn":@(isOn),
            @"transmissions":transmissions,
            @"DRL":DRL,
            @"DRH":DRH,
        };
        operationID = mk_mu_taskReadLorawanUplinkStrategyOperation;
    }else if ([cmd isEqualToString:@"9d"]) {
        //读取LoRaWAN duty cycle
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadLorawanDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"9e"]) {
        //读取LoRaWAN devtime指令同步间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanDevTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"9f"]) {
        //读取LoRaWAN LinkCheckReq指令间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"a0"]) {
        //读取ADR_ACK_LIMIT
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanADRACKLimitOperation;
    }else if ([cmd isEqualToString:@"a1"]) {
        //读取ADR_ACK_DELAY
        resultDic = @{
            @"value":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadLorawanADRACKDelayOperation;
    }else if ([cmd isEqualToString:@"a2"]) {
        //读取心跳数据包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadHeartbeatPayloadDataOperation;
    }else if ([cmd isEqualToString:@"a3"]) {
        //读取定位包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadPositioningPayloadDataOperation;
    }else if ([cmd isEqualToString:@"a4"]) {
        //读取低电包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadLowPowerPayloadDataOperation;
    }else if ([cmd isEqualToString:@"a5"]) {
        //读取震动检测包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadShockPayloadDataOperation;
    }else if ([cmd isEqualToString:@"a6"]) {
        //读取闲置检测包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadManDownDetectionPayloadDataOperation;
    }else if ([cmd isEqualToString:@"a7"]) {
        //读取事件信息包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadEventPayloadDataOperation;
    }else if ([cmd isEqualToString:@"ab"]) {
        //读取GPS极限定位包上行配置
        resultDic = @{
            @"type":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)],
            @"retransmissionTimes":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)],
        };
        operationID = mk_mu_taskReadGPSLimitPayloadDataOperation;
    }else if ([cmd isEqualToString:@"b0"]) {
        //读取下行请求定位策略
        NSString *strategy = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"strategy":strategy,
        };
        operationID = mk_mu_taskReadDownlinkPositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"b1"]) {
        //读取三轴唤醒条件
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *duration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        resultDic = @{
            @"threshold":threshold,
            @"duration":duration,
        };
        operationID = mk_mu_taskReadThreeAxisWakeupConditionsOperation;
    }else if ([cmd isEqualToString:@"b2"]) {
        //读取运动检测判断
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *duration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        resultDic = @{
            @"threshold":threshold,
            @"duration":duration,
        };
        operationID = mk_mu_taskReadThreeAxisMotionParametersOperation;
    }else if ([cmd isEqualToString:@"b3"]) {
        //读取震动检测开关状态
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadShockDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"b4"]) {
        //读取震动检测阈值
        NSString *threshold = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"threshold":threshold,
        };
        operationID = mk_mu_taskReadShockThresholdsOperation;
    }else if ([cmd isEqualToString:@"b5"]) {
        //读取震动上发间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadShockDetectionReportIntervalOperation;
    }else if ([cmd isEqualToString:@"b6"]) {
        //读取震动次数判断间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadShockTimeoutOperation;
    }else if ([cmd isEqualToString:@"b7"]) {
        //读取闲置功能使能
        BOOL isOn = ([content isEqualToString:@"01"]);
        resultDic = @{
            @"isOn":@(isOn)
        };
        operationID = mk_mu_taskReadManDownDetectionOperation;
    }else if ([cmd isEqualToString:@"b8"]) {
        //读取闲置超时时间
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadIdleDetectionTimeoutOperation;
    }else if ([cmd isEqualToString:@"d8"]) {
        //读取蓝牙定位机制
        resultDic = @{
            @"priority":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadBluetoothFixMechanismOperation;
    }else if ([cmd isEqualToString:@"d9"]) {
        //读取蓝牙定位超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadBlePositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"da"]) {
        //读取蓝牙定位MAC数量
        resultDic = @{
            @"number":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadBlePositioningNumberOfMacOperation;
    }else if ([cmd isEqualToString:@"e0"]) {
        //读取GPS定位超时时间
        resultDic = @{
            @"timeout":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadGPSFixPositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"e1"]) {
        //读取GPS定位PDOP
        resultDic = @{
            @"pdop":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadGPSFixPDOPOperation;
    }else if ([cmd isEqualToString:@"ee"]) {
        //读取室外蓝牙定位上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadOutdoorBLEReportIntervalOperation;
    }else if ([cmd isEqualToString:@"ef"]) {
        //读取室外GPS定位上报间隔
        resultDic = @{
            @"interval":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)],
        };
        operationID = mk_mu_taskReadOutdoorGPSReportIntervalOperation;
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_mu_taskOperationID operationID = mk_mu_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"01"];
    
    if ([cmd isEqualToString:@"01"]) {
        //
    }else if ([cmd isEqualToString:@"10"]) {
        //关机
        operationID = mk_mu_taskPowerOffOperation;
    }else if ([cmd isEqualToString:@"11"]) {
        //配置LoRaWAN 入网
        operationID = mk_mu_taskRestartDeviceOperation;
    }else if ([cmd isEqualToString:@"12"]) {
        //恢复出厂设置
        operationID = mk_mu_taskFactoryResetOperation;
    }else if ([cmd isEqualToString:@"13"]) {
        //配置时间戳
        operationID = mk_mu_taskConfigDeviceTimeOperation;
    }else if ([cmd isEqualToString:@"14"]) {
        //配置时区
        operationID = mk_mu_taskConfigTimeZoneOperation;
    }else if ([cmd isEqualToString:@"15"]) {
        //配置工作模式
        operationID = mk_mu_taskConfigWorkModeOperation;
    }else if ([cmd isEqualToString:@"16"]) {
        //配置指示灯开关状态
        operationID = mk_mu_taskConfigIndicatorSettingsOperation;
    }else if ([cmd isEqualToString:@"17"]) {
        //配置设备心跳间隔
        operationID = mk_mu_taskConfigHeartbeatIntervalOperation;
    }else if ([cmd isEqualToString:@"19"]) {
        //配置关机信息上报状态
        operationID = mk_mu_taskConfigShutdownPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"1a"]) {
        //配置离线定位功能开关
        operationID = mk_mu_taskConfigOfflineFixOperation;
    }else if ([cmd isEqualToString:@"1b"]) {
        //配置低电触发心跳开关状态
        operationID = mk_mu_taskConfigLowPowerPayloadStatusOperation;
    }else if ([cmd isEqualToString:@"1c"]) {
        //配置低电百分比
        operationID = mk_mu_taskConfigLowPowerPromptOperation;
    }else if ([cmd isEqualToString:@"1e"]) {
        //配置霍尔关机功能
        operationID = mk_mu_taskConfigHallPowerOffStatusOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //配置充电自动开机功能
        operationID = mk_mu_taskConfigAutoPowerOnAfterChargingOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //清除电池电量数据
        operationID = mk_mu_taskBatteryResetOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //配置低电状态下低电信息包上报间隔
        operationID = mk_mu_taskConfigLowPowerPayloadIntervalOperation;
    }else if ([cmd isEqualToString:@"2a"]) {
        //配置GPS极限上传开关
        operationID = mk_mu_taskConfigGpsLimitUploadStatusOperation;
    }else if ([cmd isEqualToString:@"30"]) {
        //配置是否需要连接密码
        operationID = mk_mu_taskConfigNeedPasswordOperation;
    }else if ([cmd isEqualToString:@"31"]) {
        //配置连接密码
        operationID = mk_mu_taskConfigPasswordOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //配置蓝牙广播超时时间
        operationID = mk_mu_taskConfigBroadcastTimeoutOperation;
    }else if ([cmd isEqualToString:@"33"]) {
        //配置蓝牙TX Power
        operationID = mk_mu_taskConfigTxPowerOperation;
    }else if ([cmd isEqualToString:@"34"]) {
        //配置蓝牙广播名称
        operationID = mk_mu_taskConfigDeviceNameOperation;
    }else if ([cmd isEqualToString:@"35"]) {
        //配置广播间隔
        operationID = mk_mu_taskConfigAdvIntervalOperation;
    }else if ([cmd isEqualToString:@"36"]) {
        //配置开启蓝牙广播
        operationID = mk_mu_taskConfigStartBleAdvOperation;
    }else if ([cmd isEqualToString:@"37"]) {
        //配置Beacon模式开关
        operationID = mk_mu_taskConfigBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"39"]) {
        //配置待机模式定位策略
        operationID = mk_mu_taskConfigStandbyModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"40"]) {
        //设置定期模式定位策略
        operationID = mk_mu_taskConfigPeriodicModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"41"]) {
        //设置定期模式上报间隔
        operationID = mk_mu_taskConfigPeriodicModeReportIntervalOperation;
    }else if ([cmd isEqualToString:@"42"]) {
        //设置定时模式定位策略
        operationID = mk_mu_taskConfigTimingModePositioningStrategyOperation;
    }else if ([cmd isEqualToString:@"43"]) {
        //设置定时模式时间点
        operationID = mk_mu_taskConfigTimingModeReportingTimePointOperation;
    }else if ([cmd isEqualToString:@"44"]) {
        //设置运动模式事件
        operationID = mk_mu_taskConfigMotionModeEventsOperation;
    }else if ([cmd isEqualToString:@"45"]) {
        //设置运动开始定位上报次数
        operationID = mk_mu_taskConfigMotionModeNumberOfFixOnStartOperation;
    }else if ([cmd isEqualToString:@"46"]) {
        //设置运动开始定位策略
        operationID = mk_mu_taskConfigMotionModePosStrategyOnStartOperation;
    }else if ([cmd isEqualToString:@"47"]) {
        //设置运动中定位间隔
        operationID = mk_mu_taskConfigMotionModeReportIntervalInTripOperation;
    }else if ([cmd isEqualToString:@"48"]) {
        //设置运动中定位策略
        operationID = mk_mu_taskConfigMotionModePosStrategyInTripOperation;
    }else if ([cmd isEqualToString:@"49"]) {
        //设置运动结束判断时间
        operationID = mk_mu_taskConfigMotionModeTripEndTimeoutOperation;
    }else if ([cmd isEqualToString:@"4a"]) {
        //设置运动结束定位次数
        operationID = mk_mu_taskConfigMotionModeNumberOfFixOnEndOperation;
    }else if ([cmd isEqualToString:@"4b"]) {
        //设置运动结束定位间隔
        operationID = mk_mu_taskConfigMotionModeReportIntervalOnEndOperation;
    }else if ([cmd isEqualToString:@"4c"]) {
        //设置运动结束定位策略
        operationID = mk_mu_taskConfigMotionModePosStrategyOnEndOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //配置运动静止状态定位策略
        operationID = mk_mu_taskConfigPosStrategyOnStationaryOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //配置运动禁止状态上报间隔
        operationID = mk_mu_taskConfigReportIntervalOnStationaryOperation;
    }else if ([cmd isEqualToString:@"51"]) {
        //配置rssi过滤规则
        operationID = mk_mu_taskConfigRssiFilterValueOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //配置广播内容过滤逻辑
        operationID = mk_mu_taskConfigFilterRelationshipOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //配置精准过滤MAC开关
        operationID = mk_mu_taskConfigFilterByMacPreciseMatchOperation;
    }else if ([cmd isEqualToString:@"54"]) {
        //配置反向过滤MAC开关
        operationID = mk_mu_taskConfigFilterByMacReverseFilterOperation;
    }else if ([cmd isEqualToString:@"55"]) {
        //配置MAC过滤规则
        operationID = mk_mu_taskConfigFilterMACAddressListOperation;
    }else if ([cmd isEqualToString:@"56"]) {
        //配置精准过滤Adv Name开关
        operationID = mk_mu_taskConfigFilterByAdvNamePreciseMatchOperation;
    }else if ([cmd isEqualToString:@"57"]) {
        //配置反向过滤Adv Name开关
        operationID = mk_mu_taskConfigFilterByAdvNameReverseFilterOperation;
    }else if ([cmd isEqualToString:@"5a"]) {
        //配置iBeacon类型过滤开关
        operationID = mk_mu_taskConfigFilterByBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"5b"]) {
        //配置iBeacon类型过滤Major范围
        operationID = mk_mu_taskConfigFilterByBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"5c"]) {
        //配置iBeacon类型过滤Minor范围
        operationID = mk_mu_taskConfigFilterByBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"5d"]) {
        //配置iBeacon类型过滤UUID
        operationID = mk_mu_taskConfigFilterByBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //配置UID类型过滤开关
        operationID = mk_mu_taskConfigFilterByUIDStatusOperation;
    }else if ([cmd isEqualToString:@"5f"]) {
        //配置UID类型过滤Namespace ID.
        operationID = mk_mu_taskConfigFilterByUIDNamespaceIDOperation;
    }else if ([cmd isEqualToString:@"60"]) {
        //配置UID类型过滤Instace ID.
        operationID = mk_mu_taskConfigFilterByUIDInstanceIDOperation;
    }else if ([cmd isEqualToString:@"61"]) {
        //配置URL类型过滤开关
        operationID = mk_mu_taskConfigFilterByURLStatusOperation;
    }else if ([cmd isEqualToString:@"62"]) {
        //配置URL类型过滤的内容
        operationID = mk_mu_taskConfigFilterByURLContentOperation;
    }else if ([cmd isEqualToString:@"63"]) {
        //配置TLM类型开关
        operationID = mk_mu_taskConfigFilterByTLMStatusOperation;
    }else if ([cmd isEqualToString:@"64"]) {
        //配置TLM过滤数据类型
        operationID = mk_mu_taskConfigFilterByTLMVersionOperation;
    }else if ([cmd isEqualToString:@"65"]) {
        //配置BXP-iBeacon类型过滤开关
        operationID = mk_mu_taskConfigFilterByBXPBeaconStatusOperation;
    }else if ([cmd isEqualToString:@"66"]) {
        //配置BXP-iBeacon类型过滤Major范围
        operationID = mk_mu_taskConfigFilterByBXPBeaconMajorOperation;
    }else if ([cmd isEqualToString:@"67"]) {
        //配置BXP-iBeacon类型过滤Minor范围
        operationID = mk_mu_taskConfigFilterByBXPBeaconMinorOperation;
    }else if ([cmd isEqualToString:@"68"]) {
        //配置BXP-iBeacon类型过滤UUID
        operationID = mk_mu_taskConfigFilterByBXPBeaconUUIDOperation;
    }else if ([cmd isEqualToString:@"69"]) {
        //配置BXP-DeviceInfo过滤开关
        operationID = mk_mu_taskConfigFilterByBXPDeviceInfoStatusOperation;
    }else if ([cmd isEqualToString:@"6a"]) {
        //配置BeaconX Pro-ACC设备过滤开关
        operationID = mk_mu_taskConfigBXPAccFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6b"]) {
        //配置BeaconX Pro-TH设备过滤开关
        operationID = mk_mu_taskConfigBXPTHFilterStatusOperation;
    }else if ([cmd isEqualToString:@"6c"]) {
        //配置BXP-Button过滤开关
        operationID = mk_mu_taskConfigFilterByBXPButtonStatusOperation;
    }else if ([cmd isEqualToString:@"6d"]) {
        //配置BXP-Button类型过滤内容
        operationID = mk_mu_taskConfigFilterByBXPButtonAlarmStatusOperation;
    }else if ([cmd isEqualToString:@"6e"]) {
        //配置BXP-TagID类型过滤开关
        operationID = mk_mu_taskConfigFilterByBXPTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"6f"]) {
        //配置BXP-TagID类型精准过滤Tag-ID开关
        operationID = mk_mu_taskConfigPreciseMatchTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"70"]) {
        //配置BXP-TagID类型反向过滤Tag-ID开关
        operationID = mk_mu_taskConfigReverseFilterTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"71"]) {
        //配置BXP-TagID过滤规则
        operationID = mk_mu_taskConfigFilterBXPTagIDListOperation;
    }else if ([cmd isEqualToString:@"72"]) {
        //配置PIR设备过滤开关
        operationID = mk_mu_taskConfigFilterByPirStatusOperation;
    }else if ([cmd isEqualToString:@"73"]) {
        //配置PIR设备过滤sensor_detection_status
        operationID = mk_mu_taskConfigFilterByPirDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"74"]) {
        //配置PIR设备过滤sensor_sensitivity
        operationID = mk_mu_taskConfigFilterByPirSensorSensitivityOperation;
    }else if ([cmd isEqualToString:@"75"]) {
        //配置PIR设备过滤door_status
        operationID = mk_mu_taskConfigFilterByPirDoorStatusOperation;
    }else if ([cmd isEqualToString:@"76"]) {
        //配置PIR设备过滤delay_response_status
        operationID = mk_mu_taskConfigFilterByPirDelayResponseStatusOperation;
    }else if ([cmd isEqualToString:@"77"]) {
        //配置PIR设备Major过滤范围
        operationID = mk_mu_taskConfigFilterByPirMajorOperation;
    }else if ([cmd isEqualToString:@"78"]) {
        //配置PIR设备Minor过滤范围
        operationID = mk_mu_taskConfigFilterByPirMinorOperation;
    }else if ([cmd isEqualToString:@"79"]) {
        //配置BXP-TOF设备过滤开关
        operationID = mk_mu_taskConfigFilterByTofStatusOperation;
    }else if ([cmd isEqualToString:@"7a"]) {
        //配置BXP-TOF设备过滤开关
        operationID = mk_mu_taskConfigFilterBXPTofListOperation;
    }else if ([cmd isEqualToString:@"7b"]) {
        //配置BXP-SensorInfo设备过滤开关
        operationID = mk_mu_taskConfigBXPSensorInfoFilterByTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"7c"]) {
        //配置BXP-SensorInfo类型精准过滤Tag-ID开关
        operationID = mk_mu_taskConfigBXPSensorInfoPreciseMatchTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"7d"]) {
        //配置BXP-SensorInfo类型反向过滤Tag-ID开关
        operationID = mk_mu_taskConfigBXPSensorInfoReverseFilterTagIDStatusOperation;
    }else if ([cmd isEqualToString:@"7e"]) {
        //配置BXP-SensorInfo类型设备Tag-ID过滤规则
        operationID = mk_mu_taskConfigBXPSensorInfoFilterBXPTagIDListOperation;
    }else if ([cmd isEqualToString:@"8b"]) {
        //配置Other过滤关系开关
        operationID = mk_mu_taskConfigFilterByOtherStatusOperation;
    }else if ([cmd isEqualToString:@"8c"]) {
        //配置Other过滤条件逻辑关系
        operationID = mk_mu_taskConfigFilterByOtherRelationshipOperation;
    }else if ([cmd isEqualToString:@"8d"]) {
        //配置Other过滤条件列表
        operationID = mk_mu_taskConfigFilterByOtherConditionsOperation;
    }else if ([cmd isEqualToString:@"91"]) {
        //配置LoRaWAN频段
        operationID = mk_mu_taskConfigRegionOperation;
    }else if ([cmd isEqualToString:@"92"]) {
        //配置LoRaWAN入网类型
        operationID = mk_mu_taskConfigModemOperation;
    }else if ([cmd isEqualToString:@"93"]) {
        //配置LoRaWAN DEVEUI
        operationID = mk_mu_taskConfigDEVEUIOperation;
    }else if ([cmd isEqualToString:@"94"]) {
        //配置LoRaWAN APPEUI
        operationID = mk_mu_taskConfigAPPEUIOperation;
    }else if ([cmd isEqualToString:@"95"]) {
        //配置LoRaWAN APPKEY
        operationID = mk_mu_taskConfigAPPKEYOperation;
    }else if ([cmd isEqualToString:@"96"]) {
        //配置LoRaWAN DEVADDR
        operationID = mk_mu_taskConfigDEVADDROperation;
    }else if ([cmd isEqualToString:@"97"]) {
        //配置LoRaWAN APPSKEY
        operationID = mk_mu_taskConfigAPPSKEYOperation;
    }else if ([cmd isEqualToString:@"98"]) {
        //配置LoRaWAN nwkSkey
        operationID = mk_mu_taskConfigNWKSKEYOperation;
    }else if ([cmd isEqualToString:@"9a"]) {
        //配置LoRaWAN CH
        operationID = mk_mu_taskConfigCHValueOperation;
    }else if ([cmd isEqualToString:@"9b"]) {
        //配置LoRaWAN DR
        operationID = mk_mu_taskConfigDRValueOperation;
    }else if ([cmd isEqualToString:@"9c"]) {
        //配置LoRaWAN 数据发送策略
        operationID = mk_mu_taskConfigUplinkStrategyOperation;
    }else if ([cmd isEqualToString:@"9d"]) {
        //配置LoRaWAN duty cycle
        operationID = mk_mu_taskConfigDutyCycleStatusOperation;
    }else if ([cmd isEqualToString:@"9e"]) {
        //配置LoRaWAN devtime指令同步间隔
        operationID = mk_mu_taskConfigTimeSyncIntervalOperation;
    }else if ([cmd isEqualToString:@"9f"]) {
        //配置LoRaWAN LinkCheckReq指令间隔
        operationID = mk_mu_taskConfigNetworkCheckIntervalOperation;
    }else if ([cmd isEqualToString:@"a0"]) {
        //配置ADR_ACK_LIMIT
        operationID = mk_mu_taskConfigLorawanADRACKLimitOperation;
    }else if ([cmd isEqualToString:@"a1"]) {
        //配置ADR_ACK_DELAY
        operationID = mk_mu_taskConfigLorawanADRACKDelayOperation;
    }else if ([cmd isEqualToString:@"a2"]) {
        //配置心跳包上行配置
        operationID = mk_mu_taskConfigHeartbeatPayloadOperation;
    }else if ([cmd isEqualToString:@"a3"]) {
        //配置定位包上行配置
        operationID = mk_mu_taskConfigPositioningPayloadOperation;
    }else if ([cmd isEqualToString:@"a4"]) {
        //配置低电包上行配置
        operationID = mk_mu_taskConfigLowPowerPayloadOperation;
    }else if ([cmd isEqualToString:@"a5"]) {
        //配置震动检测包上行配置
        operationID = mk_mu_taskConfigShockPayloadOperation;
    }else if ([cmd isEqualToString:@"a6"]) {
        //配置闲置检测包上行配置
        operationID = mk_mu_taskConfigManDownDetectionPayloadOperation;
    }else if ([cmd isEqualToString:@"a7"]) {
        //配置事件信息包上行配置
        operationID = mk_mu_taskConfigEventPayloadWithMessageTypeOperation;
    }else if ([cmd isEqualToString:@"ab"]) {
        //配置GPS极限定位包上行配置
        operationID = mk_mu_taskConfigGPSLimitPayloadOperation;
    }else if ([cmd isEqualToString:@"b0"]) {
        //配置下行请求定位策略
        operationID = mk_mu_taskConfigDownlinkPositioningStrategyyOperation;
    }else if ([cmd isEqualToString:@"b1"]) {
        //配置三轴唤醒条件
        operationID = mk_mu_taskConfigThreeAxisWakeupConditionsOperation;
    }else if ([cmd isEqualToString:@"b2"]) {
        //配置运动检测判断
        operationID = mk_mu_taskConfigThreeAxisMotionParametersOperation;
    }else if ([cmd isEqualToString:@"b3"]) {
        //配置震动检测使能
        operationID = mk_mu_taskConfigShockDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"b4"]) {
        //配置震动检测阈值
        operationID = mk_mu_taskConfigShockThresholdsOperation;
    }else if ([cmd isEqualToString:@"b5"]) {
        //配置震动上发间隔
        operationID = mk_mu_taskConfigShockDetectionReportIntervalOperation;
    }else if ([cmd isEqualToString:@"b6"]) {
        //配置震动次数判断间隔
        operationID = mk_mu_taskConfigShockTimeoutOperation;
    }else if ([cmd isEqualToString:@"b7"]) {
        //配置闲置功能使能
        operationID = mk_mu_taskConfigManDownDetectionStatusOperation;
    }else if ([cmd isEqualToString:@"b8"]) {
        //配置闲置超时时间
        operationID = mk_mu_taskConfigIdleDetectionTimeoutOperation;
    }else if ([cmd isEqualToString:@"b9"]) {
        //闲置状态清除
        operationID = mk_mu_taskConfigIdleStutasResetOperation;
    }else if ([cmd isEqualToString:@"d8"]) {
        //配置蓝牙定位机制
        operationID = mk_mu_taskConfigBluetoothFixMechanismOperation;
    }else if ([cmd isEqualToString:@"d9"]) {
        //配置蓝牙定位超时时间
        operationID = mk_mu_taskConfigBlePositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"da"]) {
        //配置蓝牙定位mac数量
        operationID = mk_mu_taskConfigBlePositioningNumberOfMacOperation;
    }else if ([cmd isEqualToString:@"e0"]) {
        //配置GPS定位超时时间
        operationID = mk_mu_taskConfigGPSFixPositioningTimeoutOperation;
    }else if ([cmd isEqualToString:@"e1"]) {
        //配置GPS定位PDOP
        operationID = mk_mu_taskConfigGPSFixPDOPOperation;
    }else if ([cmd isEqualToString:@"ee"]) {
        //配置室外蓝牙定位上报间隔
        operationID = mk_mu_taskConfigOutdoorBLEReportIntervalOperation;
    }else if ([cmd isEqualToString:@"ef"]) {
        //配置室外GPS定位上报间隔
        operationID = mk_mu_taskConfigOutdoorGPSReportIntervalOperation;
    }else if ([cmd isEqualToString:@"f0"]) {
        //读取多少天本地存储的数据
        operationID = mk_mu_taskReadNumberOfDaysStoredDataOperation;
    }else if ([cmd isEqualToString:@"f1"]) {
        //清除存储的所有数据
        operationID = mk_mu_taskClearAllDatasOperation;
    }else if ([cmd isEqualToString:@"f2"]) {
        //暂停/恢复数据传输
        operationID = mk_mu_taskPauseSendLocalDataOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}



#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_mu_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
