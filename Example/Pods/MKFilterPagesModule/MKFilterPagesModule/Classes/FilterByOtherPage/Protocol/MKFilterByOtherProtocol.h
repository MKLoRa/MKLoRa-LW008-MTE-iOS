
#import "MKFilterRawAdvDataModel.h"

typedef NS_ENUM(NSInteger, mk_filterByOther) {
    mk_filterByOther_A,                 //Filter by A condition.
    mk_filterByOther_AB,                //Filter by A & B condition.
    mk_filterByOther_AOrB,              //Filter by A | B condition.
    mk_filterByOther_ABC,               //Filter by A & B & C condition.
    mk_filterByOther_ABOrC,             //Filter by (A & B) | C condition.
    mk_filterByOther_AOrBOrC,           //Filter by A | B | C condition.
};

@protocol MKFilterByOtherProtocol <NSObject>

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
