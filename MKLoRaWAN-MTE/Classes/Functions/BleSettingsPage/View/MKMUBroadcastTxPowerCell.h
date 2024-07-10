//
//  MKMUBroadcastTxPowerCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/6/15.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUBroadcastTxPowerCellModel : NSObject

/*
 0,   //RadioTxPower:-40dBm
 1,   //-20dBm
 2,   //-16dBm
 3,   //-12dBm
 4,    //-8dBm
 5,    //-4dBm
 6,       //0dBm
 7,       //3dBm
 8,       //4dBm
 */
@property (nonatomic, assign)NSInteger txPowerValue;

@end

@protocol MKMUBroadcastTxPowerCellDelegate <NSObject>

/*
 0,   //RadioTxPower:-40dBm
 1,   //-20dBm
 2,   //-16dBm
 3,   //-12dBm
 4,    //-8dBm
 5,    //-4dBm
 6,       //0dBm
 7,       //3dBm
 8,       //4dBm
 */
- (void)mu_txPowerValueChanged:(NSInteger)txPower;

@end

@interface MKMUBroadcastTxPowerCell : MKBaseCell

@property (nonatomic, weak)id <MKMUBroadcastTxPowerCellDelegate>delegate;

@property (nonatomic, strong)MKMUBroadcastTxPowerCellModel *dataModel;

+ (MKMUBroadcastTxPowerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
