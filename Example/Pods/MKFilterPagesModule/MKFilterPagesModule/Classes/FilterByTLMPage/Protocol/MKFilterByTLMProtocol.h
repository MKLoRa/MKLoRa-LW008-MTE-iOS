
@protocol MKFilterByTLMProtocol <NSObject>

@property (nonatomic, copy)NSString *pageTitle;

@property (nonatomic, assign)BOOL isOn;

/// 0:过滤所有TLM  1:过滤非加密类型TLM 2:过滤加密类型TLM
@property (nonatomic, assign)NSInteger tlm;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configFilterStatus:(BOOL)isOn
                  sucBlock:(void (^)(void))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock;

/// 配置TLM版本
/// - Parameters:
///   - version: 0:Do not filter data.  1:Unencrypted TLM data. 2:Encrypted TLM data.
///   - sucBlock: 成功回调
///   - failedBlock: 失败回调
- (void)configTLMVersion:(NSInteger)version
                sucBlock:(void (^)(void))sucBlock
             failedBlock:(void (^)(NSError *error))failedBlock;

@end
