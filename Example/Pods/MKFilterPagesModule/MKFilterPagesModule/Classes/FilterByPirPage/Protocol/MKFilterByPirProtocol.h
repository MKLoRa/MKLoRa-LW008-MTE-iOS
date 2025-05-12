
@protocol MKFilterByPirProtocol <NSObject>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

/// 0:Low delay     1:Medium delay      2:High delay   3:All
@property (nonatomic, assign)NSInteger delayStatus;

/// 0:Close  1:Open  2:All
@property (nonatomic, assign)NSInteger doorStatus;

/// 0:Low 1:Medium 2:High 3:All
@property (nonatomic, assign)NSInteger sensitivity;

/// 0: No motion detected  1:Motion detected   2:All
@property (nonatomic, assign)NSInteger detection;

@property (nonatomic, copy)NSString *minMajor;

@property (nonatomic, copy)NSString *maxMajor;

@property (nonatomic, copy)NSString *minMinor;

@property (nonatomic, copy)NSString *maxMinor;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end
