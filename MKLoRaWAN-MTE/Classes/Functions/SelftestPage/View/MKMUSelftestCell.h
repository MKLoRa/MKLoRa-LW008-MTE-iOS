//
//  MKMUSelftestCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUSelftestCellModel : NSObject

@property (nonatomic, copy)NSString *value0;

@property (nonatomic, copy)NSString *value1;

@property (nonatomic, copy)NSString *value2;

@property (nonatomic, copy)NSString *value3;

@property (nonatomic, copy)NSString *value4;

@property (nonatomic, copy)NSString *value5;

@property (nonatomic, copy)NSString *value6;

@property (nonatomic, copy)NSString *value7;

@end

@interface MKMUSelftestCell : MKBaseCell

@property (nonatomic, strong)MKMUSelftestCellModel *dataModel;

+ (MKMUSelftestCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
