//
//  MKMUFilterByBXPButtonModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterByBXPButtonModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL singlePress;

@property (nonatomic, assign)BOOL doublePress;

@property (nonatomic, assign)BOOL longPress;

@property (nonatomic, assign)BOOL abnormal;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
