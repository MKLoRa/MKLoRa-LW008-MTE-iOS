//
//  MKMUTextButtonCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/5/26.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUTextButtonCellModel : NSObject

/// cell唯一识别号
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *leftMsg;

@property (nonatomic, copy)NSString *rightMsg;

@property (nonatomic, copy)NSString *rightButtonTitle;

@end

@protocol MKMUTextButtonCellDelegate <NSObject>

/// 用户点击了右侧按钮
/// @param index cell所在序列号
- (void)mu_textButtonCell_buttonAction:(NSInteger)index;

@end

@interface MKMUTextButtonCell : MKBaseCell

@property (nonatomic, strong)MKMUTextButtonCellModel *dataModel;

@property (nonatomic, weak)id <MKMUTextButtonCellDelegate>delegate;

+ (MKMUTextButtonCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
