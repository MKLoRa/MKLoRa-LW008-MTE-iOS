//
//  MKMUScanPageCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKMUScanPageCellDelegate <NSObject>

/// 连接按钮点击事件
/// @param index 当前cell的row
- (void)mu_scanCellConnectButtonPressed:(NSInteger)index;

@end

@class MKMUScanPageModel;
@interface MKMUScanPageCell : MKBaseCell

@property (nonatomic, strong)MKMUScanPageModel *dataModel;

@property (nonatomic, weak)id <MKMUScanPageCellDelegate>delegate;

+ (MKMUScanPageCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
