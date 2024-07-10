//
//  MKMUFilterByBXPTagModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterByBXPTagModel : NSObject

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
