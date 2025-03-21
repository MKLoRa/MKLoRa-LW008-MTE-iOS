#pragma mark ****************************************Enumerate************************************************

#pragma mark - MKMUCentralManager

typedef NS_ENUM(NSInteger, mk_mu_centralConnectStatus) {
    mk_mu_centralConnectStatusUnknow,                                           //未知状态
    mk_mu_centralConnectStatusConnecting,                                       //正在连接
    mk_mu_centralConnectStatusConnected,                                        //连接成功
    mk_mu_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_mu_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_mu_centralManagerStatus) {
    mk_mu_centralManagerStatusUnable,                           //不可用
    mk_mu_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_mu_scanDeviceType) {
    mk_mu_scanDeviceType_mte,                           //008-MTE
    mk_mu_scanDeviceType_pte,                           //008-PTE
    mk_mu_scanDeviceType_bge,                           //001-BGE
    mk_mu_scanDeviceType_mt,                            //011-MT
};


typedef NS_ENUM(NSInteger, mk_mu_magnetTurnOnMethod) {
    mk_mu_magnetTurnOnMethod_multipleApproaches,                           //Multiple approaches
    mk_mu_magnetTurnOnMethod_continuousApproach,                           //Continuous approach
};

typedef NS_ENUM(NSInteger, mk_mu_deviceMode) {
    mk_mu_deviceMode_standbyMode,         //Standby mode
    mk_mu_deviceMode_periodicMode,        //Periodic mode
    mk_mu_deviceMode_timingMode,          //Timing mode
    mk_mu_deviceMode_motionMode,          //Motion Mode
    mk_mu_deviceMode_timeSegmentedMode,   //Time-Segmented Mode
};

typedef NS_ENUM(NSInteger, mk_mu_lowPowerPrompt) {
    mk_mu_lowPowerPrompt_tenPercent,
    mk_mu_lowPowerPrompt_twentyPercent,
    mk_mu_lowPowerPrompt_thirtyPercent,
    mk_mu_lowPowerPrompt_fortyPercent,
    mk_mu_lowPowerPrompt_fiftyPercent,
    mk_mu_lowPowerPrompt_sixtyPercent,
};

typedef NS_ENUM(NSInteger, mk_mu_positioningStrategy) {
    mk_mu_positioningStrategy_ble,      //BLE
    mk_mu_positioningStrategy_gps,      //GPS
    mk_mu_positioningStrategy_bleAndGps_1,  //BLE + GPS
    mk_mu_positioningStrategy_bleAndGps_2,  //BLE * GPS
    mk_mu_positioningStrategy_bleAndGps_3,  //BLE & GPS
};

typedef NS_ENUM(NSInteger, mk_mu_filterRelationship) {
    mk_mu_filterRelationship_null,
    mk_mu_filterRelationship_mac,
    mk_mu_filterRelationship_advName,
    mk_mu_filterRelationship_rawData,
    mk_mu_filterRelationship_advNameAndRawData,
    mk_mu_filterRelationship_macAndadvNameAndRawData,
    mk_mu_filterRelationship_advNameOrRawData,
};

typedef NS_ENUM(NSInteger, mk_mu_filterByTLMVersion) {
    mk_mu_filterByTLMVersion_null,             //Do not filter data.
    mk_mu_filterByTLMVersion_0,                //Unencrypted TLM data.
    mk_mu_filterByTLMVersion_1,                //Encrypted TLM data.
};

typedef NS_ENUM(NSInteger, mk_mu_filterByOther) {
    mk_mu_filterByOther_A,                 //Filter by A condition.
    mk_mu_filterByOther_AB,                //Filter by A & B condition.
    mk_mu_filterByOther_AOrB,              //Filter by A | B condition.
    mk_mu_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_mu_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_mu_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

typedef NS_ENUM(NSInteger, mk_mu_dataFormat) {
    mk_mu_dataFormat_DAS,
    mk_mu_dataFormat_Customer,
};

typedef NS_ENUM(NSInteger, mk_mu_positioningSystem) {
    mk_mu_positioningSystem_GPS,
    mk_mu_positioningSystem_Beidou,
    mk_mu_positioningSystem_GPSAndBeidou
};

typedef NS_ENUM(NSInteger, mk_mu_loraWanRegion) {
    mk_mu_loraWanRegionAS923,
    mk_mu_loraWanRegionAU915,
    mk_mu_loraWanRegionEU868,
    mk_mu_loraWanRegionKR920,
    mk_mu_loraWanRegionIN865,
    mk_mu_loraWanRegionUS915,
    mk_mu_loraWanRegionRU864,
    mk_mu_loraWanRegionAS923_1,
    mk_mu_loraWanRegionAS923_2,
    mk_mu_loraWanRegionAS923_3,
    mk_mu_loraWanRegionAS923_4,
};

typedef NS_ENUM(NSInteger, mk_mu_loraWanModem) {
    mk_mu_loraWanModemABP,
    mk_mu_loraWanModemOTAA,
};

typedef NS_ENUM(NSInteger, mk_mu_loraWanMessageType) {
    mk_mu_loraWanUnconfirmMessage,          //Non-acknowledgement frame.
    mk_mu_loraWanConfirmMessage,            //Confirm the frame.
};

typedef NS_ENUM(NSInteger, mk_mu_txPower) {
    mk_mu_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_mu_txPowerNeg20dBm,   //-20dBm
    mk_mu_txPowerNeg16dBm,   //-16dBm
    mk_mu_txPowerNeg12dBm,   //-12dBm
    mk_mu_txPowerNeg8dBm,    //-8dBm
    mk_mu_txPowerNeg4dBm,    //-4dBm
    mk_mu_txPower0dBm,       //0dBm
    mk_mu_txPower3dBm,       //3dBm
    mk_mu_txPower4dBm,       //4dBm
};

typedef NS_ENUM(NSInteger, mk_mu_bluetoothFixMechanism) {
    mk_mu_bluetoothFixMechanism_timePriority,
    mk_mu_bluetoothFixMechanism_rssiPriority,
};

typedef NS_ENUM(NSInteger, mk_mu_detectionStatus) {
    mk_mu_detectionStatus_noMotionDetected,
    mk_mu_detectionStatus_motionDetected,
    mk_mu_detectionStatus_all
};

typedef NS_ENUM(NSInteger, mk_mu_sensorSensitivity) {
    mk_mu_sensorSensitivity_low,
    mk_mu_sensorSensitivity_medium,
    mk_mu_sensorSensitivity_high,
    mk_mu_sensorSensitivity_all
};

typedef NS_ENUM(NSInteger, mk_mu_doorStatus) {
    mk_mu_doorStatus_close,
    mk_mu_doorStatus_open,
    mk_mu_doorStatus_all
};

typedef NS_ENUM(NSInteger, mk_mu_delayResponseStatus) {
    mk_mu_delayResponseStatus_low,
    mk_mu_delayResponseStatus_medium,
    mk_mu_delayResponseStatus_high,
    mk_mu_delayResponseStatus_all
};

@protocol mk_mu_indicatorSettingsProtocol <NSObject>

@property (nonatomic, assign)BOOL LowPower;
@property (nonatomic, assign)BOOL NetworkCheck;
@property (nonatomic, assign)BOOL Broadcast;
@property (nonatomic, assign)BOOL InFix;
@property (nonatomic, assign)BOOL FixSuccessful;
@property (nonatomic, assign)BOOL FailToFix;

@end

@protocol mk_mu_timingModeReportingTimePointProtocol <NSObject>

/// 0~23
@property (nonatomic, assign)NSInteger hour;

/// 0-59
@property (nonatomic, assign)NSInteger minuteGear;

@end

@protocol mk_mu_timeSegmentedModeTimePeriodSettingProtocol <NSObject>

/// 0~24
@property (nonatomic, assign)NSInteger startHour;

/// 0-59
@property (nonatomic, assign)NSInteger startMinuteGear;

/// 0~24
@property (nonatomic, assign)NSInteger endHour;

/// 0-59
@property (nonatomic, assign)NSInteger endMinuteGear;

/// Report Interval   30s - 86400s
@property (nonatomic, assign)NSInteger interval;

@end

@protocol mk_mu_BLEFilterRawDataProtocol <NSObject>

/// The currently filtered data type, refer to the definition of different Bluetooth data types by the International Bluetooth Organization, 1 byte of hexadecimal data
@property (nonatomic, copy)NSString *dataType;

/// Data location to start filtering.
@property (nonatomic, assign)NSInteger minIndex;

/// Data location to end filtering.
@property (nonatomic, assign)NSInteger maxIndex;

/// The currently filtered content. If minIndex==0,maxIndex must be 0.The data length should be maxIndex-minIndex, if maxIndex=0&&minIndex==0, the item length is not checked whether it meets the requirements.MAX length:29 Bytes
@property (nonatomic, copy)NSString *rawData;

@end

#pragma mark ****************************************Delegate************************************************

@protocol mk_mu_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param deviceModel device
/*
 @{
 @"rssi":@(-55),
 @"peripheral":peripheral,
 @"deviceName":@"LW008-MT",
 
 @"deviceType":@"00",           //@"00":LR1110  @"10":L76
 @"txPower":@(-55),             //dBm
 @"deviceState":@"0",           //0 (Standby Mode), 1 (Timing Mode), 2 (Periodic Mode), 3 (Motion Mode)
 @"lowPower":@(lowPower),       //Whether the device is in a low battery state.
 @"needPassword":@(YES),
 @"idle":@(NO),               //Whether the device is idle.
 @"move":@(YES),               //Whether there is any movement from the last lora payload to the current broadcast moment (for example, 0 means no movement, 1 means movement).
 @"voltage":@"3.333",           //V
 @"macAddress":@"AA:BB:CC:DD:EE:FF",
 @"connectable":advDic[CBAdvertisementDataIsConnectable],
 }
 */
- (void)mk_mu_receiveDevice:(NSDictionary *)deviceModel;

@optional

/// Starts scanning equipment.
- (void)mk_mu_startScan;

/// Stops scanning equipment.
- (void)mk_mu_stopScan;

@end

@protocol mk_mu_storageDataDelegate <NSObject>

- (void)mk_mu_receiveStorageData:(NSString *)content;

@end


@protocol mk_mu_centralManagerLogDelegate <NSObject>

- (void)mk_mu_receiveLog:(NSString *)deviceLog;

@end
