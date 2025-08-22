
#import "MKTimingModeTimePointModel.h"

@protocol MKTimingModePageProtocol <NSObject>

/// 最大可以添加的时间点个数，默认10
@property (nonatomic, assign)NSInteger maxPointList;

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKTimingModeTimePointModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKTimingModeTimePointModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end
