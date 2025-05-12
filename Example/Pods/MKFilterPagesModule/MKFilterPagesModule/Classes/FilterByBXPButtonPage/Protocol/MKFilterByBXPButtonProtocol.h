
@protocol MKFilterByBXPButtonProtocol <NSObject>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL singlePress;

@property (nonatomic, assign)BOOL doublePress;

@property (nonatomic, assign)BOOL longPress;

@property (nonatomic, assign)BOOL abnormal;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end
