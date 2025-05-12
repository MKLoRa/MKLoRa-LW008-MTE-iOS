//
//  MKMotionModeController.h
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKMotionModePageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMotionModeController : MKBaseViewController

@property (nonatomic, strong)id <MKMotionModePageProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
