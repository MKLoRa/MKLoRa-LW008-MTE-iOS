//
//  MKFilterByOtherController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKFilterByOtherProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByOtherController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByOtherProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
