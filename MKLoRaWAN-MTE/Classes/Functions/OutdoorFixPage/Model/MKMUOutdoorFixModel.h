//
//  MKMUOutdoorFixModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/5.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUOutdoorFixModel : NSObject

@property (nonatomic, copy)NSString *bleInterval;

@property (nonatomic, copy)NSString *gpsInterval;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
