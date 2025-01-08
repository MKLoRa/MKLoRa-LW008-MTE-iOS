//
//  Target_LoRaWANMU_Module.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "Target_LoRaWANMU_Module.h"

#import "MKMUScanController.h"

#import "MKMUAboutController.h"

@implementation Target_LoRaWANMU_Module

/// 扫描页面
- (UIViewController *)Action_LoRaWANMU_Module_ScanController:(NSDictionary *)params {
    MKMUScanController *vc = [[MKMUScanController alloc] init];
    vc.deviceType = [params[@"deviceType"] integerValue];
    return vc;
}

/// 关于页面
- (UIViewController *)Action_LoRaWANMU_Module_AboutController:(NSDictionary *)params {
    return [[MKMUAboutController alloc] init];
}

@end
