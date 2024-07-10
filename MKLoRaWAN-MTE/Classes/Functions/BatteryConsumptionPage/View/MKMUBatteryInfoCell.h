//
//  MKMUBatteryInfoCell.h
//  MKLoRaWAN-PIR_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUBatteryInfoCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, copy)NSString *workTimes;

@property (nonatomic, copy)NSString *advCount;

@property (nonatomic, copy)NSString *axisWakeupTimes;

@property (nonatomic, copy)NSString *blePostionTimes;

@property (nonatomic, copy)NSString *gpsPostionTimes;

@property (nonatomic, copy)NSString *loraSendCount;

@property (nonatomic, copy)NSString *loraPowerConsumption;

@property (nonatomic, copy)NSString *batteryPower;

@end

@interface MKMUBatteryInfoCell : MKBaseCell

@property (nonatomic, strong)MKMUBatteryInfoCellModel *dataModel;

+ (MKMUBatteryInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
