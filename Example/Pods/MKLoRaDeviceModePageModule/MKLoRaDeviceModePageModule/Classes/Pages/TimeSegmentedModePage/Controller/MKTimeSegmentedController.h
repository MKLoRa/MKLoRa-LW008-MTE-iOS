//
//  MKTimeSegmentedController.h
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKTimeSegmentedPageProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKTimeSegmentedController : MKBaseViewController

@property (nonatomic, strong)id <MKTimeSegmentedPageProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
