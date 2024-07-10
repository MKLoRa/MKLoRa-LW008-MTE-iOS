//
//  MKMUDebuggerCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/12/29.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUDebuggerCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *timeMsg;

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *logInfo;

@end

@protocol MKMUDebuggerCellDelegate <NSObject>

- (void)mu_debuggerCellSelectedChanged:(NSInteger)index selected:(BOOL)selected;

@end

@interface MKMUDebuggerCell : MKBaseCell

@property (nonatomic, strong)MKMUDebuggerCellModel *dataModel;

@property (nonatomic, weak)id <MKMUDebuggerCellDelegate>delegate;

+ (MKMUDebuggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
