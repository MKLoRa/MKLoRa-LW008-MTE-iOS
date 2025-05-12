//
//  MKFilterByBeaconController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKFilterByBeaconProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByBeaconController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByBeaconProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
