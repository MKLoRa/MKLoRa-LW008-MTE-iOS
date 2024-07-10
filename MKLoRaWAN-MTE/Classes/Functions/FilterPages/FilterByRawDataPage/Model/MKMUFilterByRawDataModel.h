//
//  MKMUFilterByRawDataModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterByRawDataModel : NSObject

@property (nonatomic, assign)BOOL iBeacon;

@property (nonatomic, assign)BOOL uid;

@property (nonatomic, assign)BOOL url;

@property (nonatomic, assign)BOOL tlm;

@property (nonatomic, assign)BOOL bxpBeacon;

@property (nonatomic, assign)BOOL bxpDeviceInfo;

@property (nonatomic, assign)BOOL bxpAcc;

@property (nonatomic, assign)BOOL bxpTH;

@property (nonatomic, assign)BOOL bxpButton;

@property (nonatomic, assign)BOOL bxpTag;

@property (nonatomic, assign)BOOL pir;

@property (nonatomic, assign)BOOL tof;

@property (nonatomic, assign)BOOL sensorInfo;

@property (nonatomic, assign)BOOL other;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
