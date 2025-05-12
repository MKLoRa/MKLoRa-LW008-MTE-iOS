//
//  MKFilterByTLMController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/5/9.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKFilterByTLMProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByTLMController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByTLMProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
