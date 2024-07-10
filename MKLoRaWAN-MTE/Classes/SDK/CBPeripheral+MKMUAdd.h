//
//  CBPeripheral+MKMUAdd.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKMUAdd)

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *mu_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *mu_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *mu_seriesNumber;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *mu_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *mu_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *mu_firmware;

#pragma mark - custom

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *mu_password;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *mu_disconnectType;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *mu_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *mu_log;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *mu_storageData;

- (void)mu_updateCharacterWithService:(CBService *)service;

- (void)mu_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)mu_connectSuccess;

- (void)mu_setNil;

@end

NS_ASSUME_NONNULL_END
