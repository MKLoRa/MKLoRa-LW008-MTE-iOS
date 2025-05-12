//
//  MKFilterByPirController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/7.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKFilterByPirProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByPirController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByPirProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
