//
//  MKMUTimingModeAddCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/25.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUTimingModeAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKMUTimingModeAddCellDelegate <NSObject>

- (void)mu_addButtonPressed;

@end

@interface MKMUTimingModeAddCell : MKBaseCell

@property (nonatomic, strong)MKMUTimingModeAddCellModel *dataModel;

@property (nonatomic, weak)id <MKMUTimingModeAddCellDelegate>delegate;

+ (MKMUTimingModeAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
