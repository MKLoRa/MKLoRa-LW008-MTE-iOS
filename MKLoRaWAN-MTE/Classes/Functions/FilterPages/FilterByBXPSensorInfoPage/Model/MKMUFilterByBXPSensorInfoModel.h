//
//  MKMUFilterByBXPSensorInfoModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/5.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterByBXPSensorInfoModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL precise;

@property (nonatomic, assign)BOOL reverse;

@property (nonatomic, strong)NSArray *tagIDList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithTagIDList:(NSArray <NSString *>*)tagIDList
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
