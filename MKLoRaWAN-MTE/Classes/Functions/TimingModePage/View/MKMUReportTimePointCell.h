//
//  MKMUReportTimePointCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/24.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUReportTimePointCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger hourIndex;

@property (nonatomic, assign)NSInteger timeSpaceIndex;

@end

@protocol MKMUReportTimePointCellDelegate <NSObject>

/**
 删除
 
 @param index 所在index
 */
- (void)mu_cellDeleteButtonPressed:(NSInteger)index;

/// 用户选择了hour事件
- (void)mu_hourButtonPressed:(NSInteger)index;

/// 用户选择了时间间隔事件
- (void)mu_timeSpaceButtonPressed:(NSInteger)index;

/**
 重新设置cell的子控件位置，主要是删除按钮方面的处理
 */
- (void)mu_cellResetFrame;

/// cell的点击事件，用来重置cell的布局
- (void)mu_cellTapAction;

@end

@interface MKMUReportTimePointCell : MKBaseCell

@property (nonatomic, weak)id <MKMUReportTimePointCellDelegate>delegate;

@property (nonatomic, strong)MKMUReportTimePointCellModel *dataModel;

+ (MKMUReportTimePointCell *)initCellWithTableView:(UITableView *)tableView;

- (BOOL)canReset;
- (void)resetCellFrame;
- (void)resetFlagForFrame;

@end

NS_ASSUME_NONNULL_END
