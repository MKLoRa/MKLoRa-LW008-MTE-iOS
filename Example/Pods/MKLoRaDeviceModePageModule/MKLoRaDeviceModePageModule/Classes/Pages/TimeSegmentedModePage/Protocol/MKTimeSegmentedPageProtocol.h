
#import "MKTimeSegmentedTimePeriodModel.h"

@protocol MKTimeSegmentedPageProtocol <NSObject>

/// 最大可以添加的时间点个数，默认3
@property (nonatomic, assign)NSInteger maxPointList;

/*
 0:BLE
 1:GPS
 2:BLE+GPS
 3:BLE*GPS
 4:BLE&GPS
 */
@property (nonatomic, assign)NSInteger strategy;

@property (nonatomic, strong)NSArray <MKTimeSegmentedTimePeriodModel *>*pointList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configData:(NSArray <MKTimeSegmentedTimePeriodModel *>*)pointList
          sucBlock:(void (^)(void))sucBlock
       failedBlock:(void (^)(NSError *error))failedBlock;

@end
