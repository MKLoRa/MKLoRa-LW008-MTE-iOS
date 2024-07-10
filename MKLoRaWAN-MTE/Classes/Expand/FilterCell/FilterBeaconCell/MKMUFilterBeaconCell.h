//
//  MKMUFilterBeaconCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/11/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterBeaconCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *minValue;

@property (nonatomic, copy)NSString *maxValue;

@end

@protocol MKMUFilterBeaconCellDelegate <NSObject>

- (void)mk_mu_beaconMinValueChanged:(NSString *)value index:(NSInteger)index;

- (void)mk_mu_beaconMaxValueChanged:(NSString *)value index:(NSInteger)index;

@end

@interface MKMUFilterBeaconCell : MKBaseCell

@property (nonatomic, strong)MKMUFilterBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKMUFilterBeaconCellDelegate>delegate;

+ (MKMUFilterBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
