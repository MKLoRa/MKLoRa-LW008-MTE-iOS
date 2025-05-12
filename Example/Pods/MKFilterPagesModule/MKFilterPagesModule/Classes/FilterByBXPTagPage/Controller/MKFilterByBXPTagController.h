//
//  MKFilterByBXPTagController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKFilterByBXPTagProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByBXPTagController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByBXPTagProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
