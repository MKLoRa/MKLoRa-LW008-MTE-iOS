//
//  CBPeripheral+MKMUAdd.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKMUAdd.h"

#import <objc/runtime.h>

static const char *mu_manufacturerKey = "mu_manufacturerKey";
static const char *mu_seriesNumberKey = "mu_seriesNumberKey";
static const char *mu_deviceModelKey = "mu_deviceModelKey";
static const char *mu_hardwareKey = "mu_hardwareKey";
static const char *mu_softwareKey = "mu_softwareKey";
static const char *mu_firmwareKey = "mu_firmwareKey";

static const char *mu_passwordKey = "mu_passwordKey";
static const char *mu_disconnectTypeKey = "mu_disconnectTypeKey";
static const char *mu_customKey = "mu_customKey";
static const char *mu_storageDataKey = "mu_storageDataKey";
static const char *mu_logKey = "mu_logKey";

static const char *mu_passwordNotifySuccessKey = "mu_passwordNotifySuccessKey";
static const char *mu_disconnectTypeNotifySuccessKey = "mu_disconnectTypeNotifySuccessKey";
static const char *mu_customNotifySuccessKey = "mu_customNotifySuccessKey";

@implementation CBPeripheral (MKMUAdd)

- (void)mu_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &mu_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &mu_seriesNumberKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &mu_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &mu_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &mu_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &mu_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
                objc_setAssociatedObject(self, &mu_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &mu_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &mu_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA04"]]) {
                objc_setAssociatedObject(self, &mu_logKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA05"]]) {
                objc_setAssociatedObject(self, &mu_storageDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
}

- (void)mu_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        objc_setAssociatedObject(self, &mu_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &mu_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &mu_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)mu_connectSuccess {
    if (![objc_getAssociatedObject(self, &mu_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &mu_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &mu_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.mu_manufacturer || !self.mu_deviceModel || !self.mu_hardware || !self.mu_software || !self.mu_firmware) {
        return NO;
    }
    if (!self.mu_password || !self.mu_disconnectType || !self.mu_custom || !self.mu_log || !self.mu_storageData) {
        return NO;
    }
    return YES;
}

- (void)mu_setNil {
    objc_setAssociatedObject(self, &mu_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_seriesNumberKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &mu_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_storageDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_logKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &mu_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &mu_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)mu_manufacturer {
    return objc_getAssociatedObject(self, &mu_manufacturerKey);
}

- (CBCharacteristic *)mu_seriesNumber {
    return objc_getAssociatedObject(self, &mu_seriesNumberKey);
}

- (CBCharacteristic *)mu_deviceModel {
    return objc_getAssociatedObject(self, &mu_deviceModelKey);
}

- (CBCharacteristic *)mu_hardware {
    return objc_getAssociatedObject(self, &mu_hardwareKey);
}

- (CBCharacteristic *)mu_software {
    return objc_getAssociatedObject(self, &mu_softwareKey);
}

- (CBCharacteristic *)mu_firmware {
    return objc_getAssociatedObject(self, &mu_firmwareKey);
}

- (CBCharacteristic *)mu_password {
    return objc_getAssociatedObject(self, &mu_passwordKey);
}

- (CBCharacteristic *)mu_disconnectType {
    return objc_getAssociatedObject(self, &mu_disconnectTypeKey);
}

- (CBCharacteristic *)mu_custom {
    return objc_getAssociatedObject(self, &mu_customKey);
}

- (CBCharacteristic *)mu_storageData {
    return objc_getAssociatedObject(self, &mu_storageDataKey);
}

- (CBCharacteristic *)mu_log {
    return objc_getAssociatedObject(self, &mu_logKey);
}

@end
