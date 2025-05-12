//
//  MKTimingModeAddCell.h
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2025/5/25.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTimingModeAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKTimingModeAddCellDelegate <NSObject>

- (void)mk_addButtonPressed;

@end

@interface MKTimingModeAddCell : MKBaseCell

@property (nonatomic, strong)MKTimingModeAddCellModel *dataModel;

@property (nonatomic, weak)id <MKTimingModeAddCellDelegate>delegate;

+ (MKTimingModeAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
