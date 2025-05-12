//
//  MKMUFilterByOtherModel.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/12/1.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKMUSDKNormalDefines.h"

#import "MKFilterByOtherProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterRawAdvDataModel : MKFilterRawAdvDataModel<mk_mu_BLEFilterRawDataProtocol>
- (void)updateWithModel:(MKFilterRawAdvDataModel *)model;
@end

@interface MKMUFilterByOtherModel : NSObject<MKFilterByOtherProtocol>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

/*
 0:A
 1:A & B
 2:A | B
 3:A & B & C
 4:(A & B) | C
 5:A | B | C
 */
@property (nonatomic, assign)NSInteger relationship;

@property (nonatomic, strong)NSArray *rawDataList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithRawDataList:(NSArray <MKFilterRawAdvDataModel *>*)list
                 relationship:(mk_filterByOther)relationship
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
