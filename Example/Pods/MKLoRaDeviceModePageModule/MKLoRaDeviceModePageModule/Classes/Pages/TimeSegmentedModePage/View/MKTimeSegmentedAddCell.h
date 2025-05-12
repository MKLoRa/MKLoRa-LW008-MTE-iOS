//
//  MKTimeSegmentedAddCell.h
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKTimeSegmentedAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKTimeSegmentedAddCellDelegate <NSObject>

- (void)mk_timeSegmentedAddCell_addPressed;

@end

@interface MKTimeSegmentedAddCell : MKBaseCell

@property (nonatomic, strong)MKTimeSegmentedAddCellModel *dataModel;

@property (nonatomic, weak)id <MKTimeSegmentedAddCellDelegate>delegate;

+ (MKTimeSegmentedAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
