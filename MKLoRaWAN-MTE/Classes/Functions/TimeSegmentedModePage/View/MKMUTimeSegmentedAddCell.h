//
//  MKMUTimeSegmentedAddCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUTimeSegmentedAddCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@end

@protocol MKMUTimeSegmentedAddCellDelegate <NSObject>

- (void)mu_timeSegmentedAddCell_addPressed;

@end

@interface MKMUTimeSegmentedAddCell : MKBaseCell

@property (nonatomic, strong)MKMUTimeSegmentedAddCellModel *dataModel;

@property (nonatomic, weak)id <MKMUTimeSegmentedAddCellDelegate>delegate;

+ (MKMUTimeSegmentedAddCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
