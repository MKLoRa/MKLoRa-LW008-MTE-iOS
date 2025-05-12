
@protocol MKFilterByBXPSensorInfoProtocol <NSObject>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, assign)BOOL precise;

@property (nonatomic, assign)BOOL reverse;

@property (nonatomic, strong)NSArray *tagIDList;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithTagIDList:(NSArray <NSString *>*)tagIDList
                       sucBlock:(void (^)(void))sucBlock
                    failedBlock:(void (^)(NSError *error))failedBlock;

@end
