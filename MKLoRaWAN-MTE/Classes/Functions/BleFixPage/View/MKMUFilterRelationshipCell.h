//
//  MKMUFilterRelationshipCell.h
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKMUFilterRelationshipCellModel : NSObject

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger dataListIndex;

@property (nonatomic, strong)NSArray *dataList;

@end

@protocol MKMUFilterRelationshipCellDelegate <NSObject>

- (void)mu_filterRelationshipChanged:(NSInteger)index dataListIndex:(NSInteger)dataListIndex;

@end

@interface MKMUFilterRelationshipCell : MKBaseCell

@property (nonatomic, strong)MKMUFilterRelationshipCellModel *dataModel;

@property (nonatomic, weak)id <MKMUFilterRelationshipCellDelegate>delegate;

+ (MKMUFilterRelationshipCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
