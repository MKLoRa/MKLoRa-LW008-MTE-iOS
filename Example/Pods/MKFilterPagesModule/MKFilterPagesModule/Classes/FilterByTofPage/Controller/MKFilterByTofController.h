//
//  MKFilterByTofController.h
//  MKFilterPagesModule_Example
//
//  Created by aa on 2025/7/5.
//  Copyright © 2025 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

#import "MKFilterByTofProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKFilterByTofController : MKBaseViewController

@property (nonatomic, strong)id <MKFilterByTofProtocol>protocol;

@end

NS_ASSUME_NONNULL_END
