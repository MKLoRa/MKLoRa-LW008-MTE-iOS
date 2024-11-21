
typedef NS_ENUM(NSInteger, mk_mu_taskOperationID) {
    mk_mu_defaultTaskOperationID,
    
#pragma mark - Read
    mk_mu_taskReadDeviceModelOperation,        //读取产品型号
    mk_mu_taskReadFirmwareOperation,           //读取固件版本
    mk_mu_taskReadHardwareOperation,           //读取硬件类型
    mk_mu_taskReadSoftwareOperation,           //读取软件版本
    mk_mu_taskReadManufacturerOperation,       //读取厂商信息
    mk_mu_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 系统参数读取
    mk_mu_taskReadMacAddressOperation,              //读取mac地址
    mk_mu_taskReadTimeZoneOperation,            //读取时区
    mk_mu_taskReadHeartbeatIntervalOperation,   //读取设备心跳间隔
    mk_mu_taskReadIndicatorSettingsOperation,   //读取指示灯开关状态
    mk_mu_taskReadMagnetTurnOnMethodOperation,  //读取磁铁开机方式选择
    mk_mu_taskReadHallPowerOffStatusOperation,      //读取霍尔关机功能
    mk_mu_taskReadShutdownPayloadStatusOperation,   //读取关机信息上报状态
    mk_mu_taskReadThreeAxisWakeupConditionsOperation,       //读取三轴唤醒条件
    mk_mu_taskReadThreeAxisMotionParametersOperation,       //读取运动检测判断条件
    mk_mu_taskReadBatteryVoltageOperation,          //读取电池电量
    mk_mu_taskReadPCBAStatusOperation,              //读取产测状态
    mk_mu_taskReadSelftestStatusOperation,          //读取自检故障原因
    
    
#pragma mark - 电池管理参数
    mk_mu_taskReadBatteryInformationOperation,      //读取电池电量消耗
    mk_mu_taskReadLastCycleBatteryInformationOperation, //读取上一周期电池电量消耗
    mk_mu_taskReadAllCycleBatteryInformationOperation,  //读取所有周期电池电量消耗
    mk_mu_taskReadLowPowerPromptOperation,          //读取低电百分比
    mk_mu_taskReadLowPowerPayloadStatusOperation,   //读取低电触发心跳开关状态
    mk_mu_taskReadLowPowerPayloadIntervalOperation,     //读取低电状态下低电信息包上报间隔
    mk_mu_taskReadAutoPowerOnAfterChargingOperation,    //读取充电自动开机功能
    
#pragma mark - 蓝牙参数读取
    mk_mu_taskReadConnectationNeedPasswordOperation,    //读取连接是否需要密码
    mk_mu_taskReadPasswordOperation,                    //读取连接密码
    mk_mu_taskReadBroadcastTimeoutOperation,            //读取蓝牙广播超时时间
    mk_mu_taskReadBeaconStatusOperation,                //读取Beacon模式开关
    mk_mu_taskReadAdvIntervalOperation,                 //读取广播间隔
    mk_mu_taskReadTxPowerOperation,                     //读取蓝牙TX Power
    mk_mu_taskReadDeviceNameOperation,                  //读取广播名称
    
    
    
#pragma mark - 模式相关参数读取
    mk_mu_taskReadWorkModeOperation,            //读取工作模式
    mk_mu_taskReadStandbyModePositioningStrategyOperation,          //读取待机模式定位策略
    mk_mu_taskReadPeriodicModePositioningStrategyOperation,         //读取定期模式定位策略
    mk_mu_taskReadPeriodicModeReportIntervalOperation,              //读取定期模式上报间隔
    mk_mu_taskReadTimingModePositioningStrategyOperation,           //读取定时模式定位策略
    mk_mu_taskReadTimingModeReportingTimePointOperation,            //读取定时模式时间点
    mk_mu_taskReadMotionModeEventsNotifyEventOnStartOperation,      //读取运动模式-运动开始事件信息开关
    mk_mu_taskReadMotionModeEventsFixOnStartOperation,              //读取运动模式-运动开始定位开关
    mk_mu_taskReadMotionModePosStrategyOnStartOperation,            //读取运动开始定位策略
    mk_mu_taskReadMotionModeNumberOfFixOnStartOperation,            //读取运动开始定位上报次数
    mk_mu_taskReadMotionModeEventsNotifyEventInTripOperation,       //读取运动模式-运动中事件信息开关
    mk_mu_taskReadMotionModeEventsFixInTripOperation,               //读取运动模式-运动中定位开关
    mk_mu_taskReadMotionModePosStrategyInTripOperation,             //读取运动中定位策略
    mk_mu_taskReadMotionModeReportIntervalInTripOperation,          //读取运动中定位间隔
    mk_mu_taskReadMotionModeEventsNotifyEventOnEndOperation,      //读取运动模式-运动结束事件信息开关
    mk_mu_taskReadMotionModeEventsFixOnEndOperation,              //读取运动模式-运动结束定位开关
    mk_mu_taskReadMotionModePosStrategyOnEndOperation,              //读取运动结束定位策略
    mk_mu_taskReadMotionModeReportIntervalOnEndOperation,           //读取运动结束定位间隔
    mk_mu_taskReadMotionModeNumberOfFixOnEndOperation,              //读取运动结束定位次数
    mk_mu_taskReadMotionModeTripEndTimeoutOperation,                //读取运动结束判断时间
    mk_mu_taskReadMotionModeEventsFixOnStationaryStateOperation,    //读取运动模式-静止定位开关
    mk_mu_taskReadPosStrategyOnStationaryOperation,                 //读取运动静止状态定位策略
    mk_mu_taskReadReportIntervalOnStationaryOperation,              //读取运动禁止状态上报间隔
    mk_mu_taskReadTimeSegmentedModeStrategyOperation,               //读取定时+定期模式-定位策略
    mk_mu_taskReadTimeSegmentedModeTimePeriodSettingOperation,      //读取定时+定期模式-定时时间段
    
    
#pragma mark - 蓝牙扫描过滤参数读取
    mk_mu_taskReadRssiFilterValueOperation,             //读取RSSI过滤规则
    mk_mu_taskReadFilterRelationshipOperation,          //读取广播内容过滤逻辑
    mk_mu_taskReadFilterTypeStatusOperation,            //读取过滤设备类型开关
    mk_mu_taskReadFilterByMacPreciseMatchOperation, //读取精准过滤MAC开关
    mk_mu_taskReadFilterByMacReverseFilterOperation,    //读取反向过滤MAC开关
    mk_mu_taskReadFilterMACAddressListOperation,        //读取MAC过滤列表
    mk_mu_taskReadFilterByAdvNamePreciseMatchOperation, //读取精准过滤ADV Name开关
    mk_mu_taskReadFilterByAdvNameReverseFilterOperation,    //读取反向过滤ADV Name开关
    mk_mu_taskReadFilterAdvNameListOperation,           //读取ADV Name过滤列表
    mk_mu_taskReadFilterByBeaconStatusOperation,        //读取iBeacon类型过滤开关
    mk_mu_taskReadFilterByBeaconMajorRangeOperation,    //读取iBeacon类型Major范围
    mk_mu_taskReadFilterByBeaconMinorRangeOperation,    //读取iBeacon类型Minor范围
    mk_mu_taskReadFilterByBeaconUUIDOperation,          //读取iBeacon类型UUID
    mk_mu_taskReadFilterByUIDStatusOperation,                //读取UID类型过滤开关
    mk_mu_taskReadFilterByUIDNamespaceIDOperation,           //读取UID类型过滤的Namespace ID
    mk_mu_taskReadFilterByUIDInstanceIDOperation,            //读取UID类型过滤的Instance ID
    mk_mu_taskReadFilterByURLStatusOperation,               //读取URL类型过滤开关
    mk_mu_taskReadFilterByURLContentOperation,              //读取URL过滤的内容
    mk_mu_taskReadFilterByTLMStatusOperation,               //读取TLM过滤开关
    mk_mu_taskReadFilterByTLMVersionOperation,              //读取TLM过滤类型
    mk_mu_taskReadFilterByBXPBeaconStatusOperation,      //读取BXP-iBeacon类型过滤开关
    mk_mu_taskReadFilterByBXPBeaconMajorRangeOperation,    //读取BXP-iBeacon类型Major范围
    mk_mu_taskReadFilterByBXPBeaconMinorRangeOperation,    //读取BXP-iBeacon类型Minor范围
    mk_mu_taskReadFilterByBXPBeaconUUIDOperation,          //读取BXP-iBeacon类型UUID
    mk_mu_taskReadBXPAccFilterStatusOperation,          //读取BeaconX Pro-ACC设备过滤开关
    mk_mu_taskReadBXPTHFilterStatusOperation,           //读取BeaconX Pro-T&H设备过滤开关
    mk_mu_taskReadBXPDeviceInfoFilterStatusOperation,       //读取BXP-DeviceInfo过滤条件开关
    mk_mu_taskReadBXPButtonFilterStatusOperation,           //读取BXP-Button过滤条件开关
    mk_mu_taskReadBXPButtonAlarmFilterStatusOperation,      //读取BXP-Button报警过滤开关
    mk_mu_taskReadFilterByBXPTagIDStatusOperation,         //读取BXP-T&S TagID类型开关
    mk_mu_taskReadPreciseMatchTagIDStatusOperation,        //读取BXP-T&S TagID类型精准过滤tagID开关
    mk_mu_taskReadReverseFilterTagIDStatusOperation,    //读取读取BXP-T&S TagID类型反向过滤tagID开关
    mk_mu_taskReadFilterBXPTagIDListOperation,             //读取BXP-T&S TagID过滤规则
    mk_mu_taskReadFilterBXPTofStatusOperation,              //读取BXP-TOF设备过滤开关
    mk_mu_taskReadFilterBXPTofMfgCodeListOperation,         //读取BXP-TOF设备过滤MFG code
    mk_mu_taskReadFilterByPirStatusOperation,           //读取PIR过滤开关
    mk_mu_taskReadFilterByPirDetectionStatusOperation,  //读取PIR设备过滤sensor_detection_status
    mk_mu_taskReadFilterByPirSensorSensitivityOperation,    //读取PIR设备过滤sensor_sensitivity
    mk_mu_taskReadFilterByPirDoorStatusOperation,           //读取PIR设备过滤door_status
    mk_mu_taskReadFilterByPirDelayResponseStatusOperation,  //读取PIR设备过滤delay_response_status
    mk_mu_taskReadFilterByPirMajorRangeOperation,           //读取PIR设备Major过滤范围
    mk_mu_taskReadFilterByPirMinorRangeOperation,           //读取PIR设备Minor过滤范围
    mk_mu_taskReadFilterByOtherStatusOperation,         //读取Other过滤条件开关
    mk_mu_taskReadFilterByOtherRelationshipOperation,   //读取Other过滤条件的逻辑关系
    mk_mu_taskReadFilterByOtherConditionsOperation,     //读取Other的过滤条件列表
    
#pragma mark - 定位参数读取
    mk_mu_taskReadOfflineFixStatusOperation,    //读取离线定位功能开关状态
    mk_mu_taskReadGpsLimitUploadStatusOperation,        //读取GPS极限上传开关
    mk_mu_taskReadOutdoorBLEReportIntervalOperation,    //读取室外蓝牙定位上报间隔
    mk_mu_taskReadOutdoorGPSReportIntervalOperation,    //读取室外GPS定位上报间隔
    mk_mu_taskReadBluetoothFixMechanismOperation,   //读取蓝牙定位机制
    mk_mu_taskReadBlePositioningTimeoutOperation,   //读取蓝牙定位超时时间
    mk_mu_taskReadBlePositioningNumberOfMacOperation,   //读取蓝牙定位成功MAC数量
    mk_mu_taskReadBeaconVoltageReportInBleFixOperation, //读取蓝牙beacon电压上报开关
    mk_mu_taskReadGPSFixPositioningTimeoutOperation,    //读取GPS定位超时时间
    mk_mu_taskReadGPSFixPDOPOperation,                  //读取GPS定位PDOP
    
    
#pragma mark - 设备控制参数配置
    mk_mu_taskPowerOffOperation,                        //关机
    mk_mu_taskRestartDeviceOperation,                   //配置设备重新入网
    mk_mu_taskFactoryResetOperation,                    //设备恢复出厂设置
    mk_mu_taskConfigDeviceTimeOperation,                //配置时间戳
    mk_mu_taskConfigTimeZoneOperation,                  //配置时区
    mk_mu_taskConfigHeartbeatIntervalOperation,         //配置设备心跳间隔
    mk_mu_taskConfigIndicatorSettingsOperation,         //配置指示灯开关状态
    mk_mu_taskConfigMagnetTurnOnMethodOperation,        //配置磁铁开机方式选择
    mk_mu_taskConfigHallPowerOffStatusOperation,        //配置霍尔关机功能
    mk_mu_taskConfigShutdownPayloadStatusOperation,     //配置关机信息上报状态
    mk_mu_taskConfigThreeAxisWakeupConditionsOperation,         //配置三轴唤醒条件
    mk_mu_taskConfigThreeAxisMotionParametersOperation,         //配置运动检测判断
    
#pragma mark - 电池管理
    mk_mu_taskBatteryResetOperation,                    //清除电池电量数据
    mk_mu_taskConfigLowPowerPromptOperation,            //配置低电百分比
    mk_mu_taskConfigLowPowerPayloadStatusOperation,     //配置低电触发心跳开关状态
    mk_mu_taskConfigLowPowerPayloadIntervalOperation,   //配置低电状态下低电信息包上报间隔
    mk_mu_taskConfigAutoPowerOnAfterChargingOperation,  //配置充电自动开机功能
    
    
#pragma mark - 蓝牙参数配置
    mk_mu_taskConfigNeedPasswordOperation,              //配置是否需要连接密码
    mk_mu_taskConfigPasswordOperation,                  //配置连接密码
    mk_mu_taskConfigBroadcastTimeoutOperation,          //配置蓝牙广播超时时间
    mk_mu_taskConfigBeaconStatusOperation,              //配置Beacon模式开关
    mk_mu_taskConfigAdvIntervalOperation,               //配置广播间隔
    mk_mu_taskConfigTxPowerOperation,                   //配置蓝牙TX Power
    mk_mu_taskConfigDeviceNameOperation,                //配置蓝牙广播名称
    
    mk_mu_taskConfigStartBleAdvOperation,               //配置开启蓝牙广播
    
#pragma mark - 配置模式相关参数
    mk_mu_taskConfigWorkModeOperation,                  //配置工作模式
    mk_mu_taskConfigStandbyModePositioningStrategyOperation,        //配置待机模式定位策略
    mk_mu_taskConfigPeriodicModePositioningStrategyOperation,       //配置定期模式定位策略
    mk_mu_taskConfigPeriodicModeReportIntervalOperation,            //配置定期模式上报间隔
    mk_mu_taskConfigTimingModePositioningStrategyOperation,         //配置定时模式定位策略
    mk_mu_taskConfigTimingModeReportingTimePointOperation,          //配置定时模式时间点
    mk_mu_taskConfigMotionModeEventsNotifyEventOnStartOperation,    //配置运动模式-运动开始事件信息开关
    mk_mu_taskConfigMotionModeEventsFixOnStartOperation,            //配置运动模式-运动开始定位开关
    mk_mu_taskConfigMotionModePosStrategyOnStartOperation,          //配置运动开始定位策略
    mk_mu_taskConfigMotionModeNumberOfFixOnStartOperation,          //配置运动开始定位上报次数
    mk_mu_taskConfigMotionModeEventsNotifyEventInTripOperation,     //配置运动模式-运动中事件信息开关
    mk_mu_taskConfigMotionModeEventsFixInTripOperation,             //配置运动模式-运动中定位开关
    mk_mu_taskConfigMotionModePosStrategyInTripOperation,           //配置运动中定位策略
    mk_mu_taskConfigMotionModeReportIntervalInTripOperation,        //配置运动中定位间隔
    mk_mu_taskConfigMotionModeEventsNotifyEventOnEndOperation,      //配置运动模式-运动结束事件信息开关
    mk_mu_taskConfigMotionModeEventsFixOnEndOperation,              //配置运动模式-运动结束定位开关
    mk_mu_taskConfigMotionModePosStrategyOnEndOperation,            //配置运动结束定位策略
    mk_mu_taskConfigMotionModeReportIntervalOnEndOperation,         //配置运动结束定位间隔
    mk_mu_taskConfigMotionModeNumberOfFixOnEndOperation,            //配置运动结束定位次数
    mk_mu_taskConfigMotionModeTripEndTimeoutOperation,              //配置运动结束判断时间
    mk_mu_taskConfigMotionModeEventsFixOnStationaryStateOperation,  //配置运动模式-静止定位开关
    mk_mu_taskConfigPosStrategyOnStationaryOperation,               //配置运动静止状态定位策略
    mk_mu_taskConfigReportIntervalOnStationaryOperation,            //配置运动禁止状态上报间隔
    mk_mu_taskConfigTimeSegmentedModeStrategyOperation,             //配置定时+定期模式-定位策略
    mk_mu_taskConfigTimeSegmentedModeTimePeriodSettingOperation,    //配置定时+定期模式-定时时间段

#pragma mark - 蓝牙扫描过滤参数配置
    mk_mu_taskConfigRssiFilterValueOperation,           //配置rssi过滤规则
    mk_mu_taskConfigFilterRelationshipOperation,        //配置广播内容过滤逻辑
    mk_mu_taskConfigFilterByMacPreciseMatchOperation,   //配置精准过滤MAC开关
    mk_mu_taskConfigFilterByMacReverseFilterOperation,  //配置反向过滤MAC开关
    mk_mu_taskConfigFilterMACAddressListOperation,      //配置MAC过滤规则
    mk_mu_taskConfigFilterByAdvNamePreciseMatchOperation,   //配置精准过滤Adv Name开关
    mk_mu_taskConfigFilterByAdvNameReverseFilterOperation,  //配置反向过滤Adv Name开关
    mk_mu_taskConfigFilterAdvNameListOperation,             //配置Adv Name过滤规则
    mk_mu_taskConfigFilterByBeaconStatusOperation,          //配置iBeacon类型过滤开关
    mk_mu_taskConfigFilterByBeaconMajorOperation,           //配置iBeacon类型过滤的Major范围
    mk_mu_taskConfigFilterByBeaconMinorOperation,           //配置iBeacon类型过滤的Minor范围
    mk_mu_taskConfigFilterByBeaconUUIDOperation,            //配置iBeacon类型过滤的UUID
    mk_mu_taskConfigFilterByUIDStatusOperation,                 //配置UID类型过滤的开关状态
    mk_mu_taskConfigFilterByUIDNamespaceIDOperation,            //配置UID类型过滤的Namespace ID
    mk_mu_taskConfigFilterByUIDInstanceIDOperation,             //配置UID类型过滤的Instance ID
    mk_mu_taskConfigFilterByURLStatusOperation,                 //配置URL类型过滤的开关状态
    mk_mu_taskConfigFilterByURLContentOperation,                //配置URL类型过滤的内容
    mk_mu_taskConfigFilterByTLMStatusOperation,                 //配置TLM过滤开关
    mk_mu_taskConfigFilterByTLMVersionOperation,                //配置TLM过滤数据类型
    mk_mu_taskConfigFilterByBXPBeaconStatusOperation,          //配置BXP-iBeacon类型过滤开关
    mk_mu_taskConfigFilterByBXPBeaconMajorOperation,           //配置BXP-iBeacon类型过滤的Major范围
    mk_mu_taskConfigFilterByBXPBeaconMinorOperation,           //配置BXP-iBeacon类型过滤的Minor范围
    mk_mu_taskConfigFilterByBXPBeaconUUIDOperation,            //配置BXP-iBeacon类型过滤的UUID
    mk_mu_taskConfigBXPAccFilterStatusOperation,            //配置BeaconX Pro-ACC设备过滤开关
    mk_mu_taskConfigBXPTHFilterStatusOperation,             //配置BeaconX Pro-TH设备过滤开关
    mk_mu_taskConfigFilterByBXPDeviceInfoStatusOperation,       //配置BXP-DeviceInfo过滤开关
    mk_mu_taskConfigFilterByBXPButtonStatusOperation,           //配置BXP-Button过滤开关
    mk_mu_taskConfigFilterByBXPButtonAlarmStatusOperation,      //配置BXP-Button类型过滤内容
    mk_mu_taskConfigFilterByBXPTagIDStatusOperation,            //配置BXP-T&S TagID类型过滤开关
    mk_mu_taskConfigPreciseMatchTagIDStatusOperation,           //配置BXP-T&S TagID类型精准过滤Tag-ID开关
    mk_mu_taskConfigReverseFilterTagIDStatusOperation,          //配置BXP-T&S TagID类型反向过滤Tag-ID开关
    mk_mu_taskConfigFilterBXPTagIDListOperation,                //配置BXP-T&S TagID过滤规则
    mk_mu_taskConfigFilterByTofStatusOperation,                 //配置BXP-TOF设备过滤开关
    mk_mu_taskConfigFilterBXPTofListOperation,                  //配置BXP-TOF设备过滤开关
    mk_mu_taskConfigFilterByPirStatusOperation,             //配置PIR设备过滤开关
    mk_mu_taskConfigFilterByPirDetectionStatusOperation,    //配置PIR设备过滤sensor_detection_status
    mk_mu_taskConfigFilterByPirSensorSensitivityOperation,  //配置PIR设备过滤sensor_sensitivity
    mk_mu_taskConfigFilterByPirDoorStatusOperation,         //配置PIR设备过滤door_status
    mk_mu_taskConfigFilterByPirDelayResponseStatusOperation,    //配置PIR设备过滤delay_response_status
    mk_mu_taskConfigFilterByPirMajorOperation,                  //配置PIR设备Major过滤范围
    mk_mu_taskConfigFilterByPirMinorOperation,                  //配置PIR设备Minor过滤范围
    mk_mu_taskConfigFilterByOtherStatusOperation,           //配置Other过滤关系开关
    mk_mu_taskConfigFilterByOtherRelationshipOperation,     //配置Other过滤条件逻辑关系
    mk_mu_taskConfigFilterByOtherConditionsOperation,       //配置Other过滤条件列表
    
#pragma mark - 密码特征
    mk_mu_connectPasswordOperation,             //连接设备时候发送密码
    
#pragma mark - 设备LoRa参数读取
    mk_mu_taskReadLorawanNetworkStatusOperation,    //读取LoRaWAN网络状态
    mk_mu_taskReadLorawanRegionOperation,           //读取LoRaWAN频段
    mk_mu_taskReadLorawanModemOperation,            //读取LoRaWAN入网类型
    mk_mu_taskReadLorawanDEVEUIOperation,           //读取LoRaWAN DEVEUI
    mk_mu_taskReadLorawanAPPEUIOperation,           //读取LoRaWAN APPEUI
    mk_mu_taskReadLorawanAPPKEYOperation,           //读取LoRaWAN APPKEY
    mk_mu_taskReadLorawanDEVADDROperation,          //读取LoRaWAN DEVADDR
    mk_mu_taskReadLorawanAPPSKEYOperation,          //读取LoRaWAN APPSKEY
    mk_mu_taskReadLorawanNWKSKEYOperation,          //读取LoRaWAN NWKSKEY
    mk_mu_taskReadLorawanADRACKLimitOperation,              //读取ADR_ACK_LIMIT
    mk_mu_taskReadLorawanADRACKDelayOperation,              //读取ADR_ACK_DELAY
    mk_mu_taskReadLorawanCHOperation,               //读取LoRaWAN CH
    mk_mu_taskReadLorawanDROperation,               //读取LoRaWAN DR
    mk_mu_taskReadLorawanUplinkStrategyOperation,   //读取LoRaWAN数据发送策略
    mk_mu_taskReadLorawanDutyCycleStatusOperation,  //读取dutycyle
    mk_mu_taskReadLorawanDevTimeSyncIntervalOperation,  //读取同步时间同步间隔
    mk_mu_taskReadLorawanNetworkCheckIntervalOperation, //读取网络确认间隔
    mk_mu_taskReadHeartbeatPayloadDataOperation,            //读取心跳包上行配置
    mk_mu_taskReadLowPowerPayloadDataOperation,             //读取低电包上行配置
    mk_mu_taskReadEventPayloadDataOperation,                //读取事件信息包上行配置
    mk_mu_taskReadPositioningPayloadDataOperation,          //读取定位包上行配置
    mk_mu_taskReadShockPayloadDataOperation,                //读取震动检测包上行配置
    mk_mu_taskReadManDownDetectionPayloadDataOperation,     //读取闲置检测包上行配置
    mk_mu_taskReadGPSLimitPayloadDataOperation,             //读取GPS极限定位包上行配置
    
#pragma mark - 辅助功能读取
    mk_mu_taskReadDownlinkPositioningStrategyOperation,     //读取下行请求定位策略
    mk_mu_taskReadShockDetectionStatusOperation,            //读取震动检测状态
    mk_mu_taskReadShockThresholdsOperation,                 //读取震动检测阈值
    mk_mu_taskReadShockDetectionReportIntervalOperation,    //读取震动上法间隔
    mk_mu_taskReadShockTimeoutOperation,                    //读取震动次数判断间隔
    mk_mu_taskReadManDownDetectionOperation,                //读取闲置功能使能
    mk_mu_taskReadIdleDetectionTimeoutOperation,            //读取闲置超时时间
    
#pragma mark - 设备LoRa参数配置
    mk_mu_taskConfigRegionOperation,                    //配置LoRaWAN的region
    mk_mu_taskConfigModemOperation,                     //配置LoRaWAN的入网类型
    mk_mu_taskConfigDEVEUIOperation,                    //配置LoRaWAN的devEUI
    mk_mu_taskConfigAPPEUIOperation,                    //配置LoRaWAN的appEUI
    mk_mu_taskConfigAPPKEYOperation,                    //配置LoRaWAN的appKey
    mk_mu_taskConfigDEVADDROperation,                   //配置LoRaWAN的DevAddr
    mk_mu_taskConfigAPPSKEYOperation,                   //配置LoRaWAN的APPSKEY
    mk_mu_taskConfigNWKSKEYOperation,                   //配置LoRaWAN的NwkSKey
    mk_mu_taskConfigLorawanADRACKLimitOperation,        //配置ADR_ACK_LIMIT
    mk_mu_taskConfigLorawanADRACKDelayOperation,        //配置ADR_ACK_DELAY
    mk_mu_taskConfigCHValueOperation,                   //配置LoRaWAN的CH值
    mk_mu_taskConfigDRValueOperation,                   //配置LoRaWAN的DR值
    mk_mu_taskConfigUplinkStrategyOperation,            //配置LoRaWAN数据发送策略
    mk_mu_taskConfigDutyCycleStatusOperation,           //配置LoRaWAN的duty cycle
    mk_mu_taskConfigTimeSyncIntervalOperation,          //配置LoRaWAN的同步指令间隔
    mk_mu_taskConfigNetworkCheckIntervalOperation,      //配置LoRaWAN的LinkCheckReq间隔
    mk_mu_taskConfigHeartbeatPayloadOperation,          //配置心跳包上行配置
    mk_mu_taskConfigLowPowerPayloadOperation,           //配置低电包上行配置
    mk_mu_taskConfigEventPayloadWithMessageTypeOperation,   //配置事件信息包上行配置
    mk_mu_taskConfigPositioningPayloadOperation,        //配置定位包上行配置
    mk_mu_taskConfigShockPayloadOperation,              //配置震动检测包上行配置
    mk_mu_taskConfigManDownDetectionPayloadOperation,   //配置闲置检测包上行配置
    mk_mu_taskConfigGPSLimitPayloadOperation,           //配置GPS极限定位包上行配置
    
    
#pragma mark - 辅助功能配置
    mk_mu_taskConfigDownlinkPositioningStrategyyOperation,  //配置下行请求定位策略
    mk_mu_taskConfigShockDetectionStatusOperation,          //配置震动检测使能
    mk_mu_taskConfigShockThresholdsOperation,               //配置震动检测阈值
    mk_mu_taskConfigShockDetectionReportIntervalOperation,  //配置震动上发间隔
    mk_mu_taskConfigShockTimeoutOperation,                  //配置震动次数判断间隔
    mk_mu_taskConfigManDownDetectionStatusOperation,            //配置闲置功能使能
    mk_mu_taskConfigIdleDetectionTimeoutOperation,              //配置闲置超时时间
    mk_mu_taskConfigIdleStutasResetOperation,                   //闲置状态清除
    
#pragma mark - 定位参数配置
    mk_mu_taskConfigOfflineFixOperation,                //配置离线定位功能开关状态
    mk_mu_taskConfigGpsLimitUploadStatusOperation,      //配置GPS极限上传开关
    mk_mu_taskConfigOutdoorBLEReportIntervalOperation,      //配置室外蓝牙定位上报间隔
    mk_mu_taskConfigOutdoorGPSReportIntervalOperation,      //配置室外GPS定位上报间隔
    mk_mu_taskConfigBluetoothFixMechanismOperation,     //配置蓝牙定位机制
    mk_mu_taskConfigBlePositioningTimeoutOperation,     //配置蓝牙定位超时时间
    mk_mu_taskConfigBlePositioningNumberOfMacOperation,     //配置蓝牙定位mac数量
    mk_mu_taskConfigBeaconVoltageReportInBleFixStatusOperation, //配置蓝牙beacon电压上报开关
    mk_mu_taskConfigGPSFixPositioningTimeoutOperation,      //配置GPS定位超时时间
    mk_mu_taskConfigGPSFixPDOPOperation,                    //配置GPS定位PDOP
    
    
#pragma mark - 存储数据协议
    mk_mu_taskReadNumberOfDaysStoredDataOperation,      //读取多少天本地存储的数据
    mk_mu_taskClearAllDatasOperation,                   //清除存储的所有数据
    mk_mu_taskPauseSendLocalDataOperation,              //暂停/恢复数据传输
};
