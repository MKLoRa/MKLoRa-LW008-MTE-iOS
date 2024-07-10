//
//  MKMUFilterRelationshipCell.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/7/2.
//  Copyright © 2024 aadyx2007@163.com. All rights reserved.
//

#import "MKMUFilterRelationshipCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

@implementation MKMUFilterRelationshipCellModel
@end

@interface MKMUFilterRelationshipCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *rightButton;

@end

@implementation MKMUFilterRelationshipCell

+ (MKMUFilterRelationshipCell *)initCellWithTableView:(UITableView *)tableView {
    MKMUFilterRelationshipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMUFilterRelationshipCellIdenty"];
    if (!cell) {
        cell = [[MKMUFilterRelationshipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.rightButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-3.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(1.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)rightButtonPressed {
    //如果想要键盘取消第一响应者，则需要发出MKTextFieldNeedHiddenKeyboard通知即可
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MKTextFieldNeedHiddenKeyboard" object:nil];
    if (!ValidArray(self.dataModel.dataList)) {
        return;
    }
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.dataModel.dataList.count; i ++) {
        if ([self.rightButton.titleLabel.text isEqualToString:self.dataModel.dataList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.dataModel.dataList selectedRow:index block:^(NSInteger currentRow) {
        [self.rightButton setTitle:_dataModel.dataList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mu_filterRelationshipChanged:dataListIndex:)]) {
            [self.delegate mu_filterRelationshipChanged:self.dataModel.index dataListIndex:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKMUFilterRelationshipCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKMUFilterRelationshipCellModel.class]) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    if (!ValidArray(_dataModel.dataList) || _dataModel.dataListIndex >= _dataModel.dataList.count) {
        return;
    }
    [self.rightButton setTitle:_dataModel.dataList[_dataModel.dataListIndex] forState:UIControlStateNormal];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(13.f);
    }
    return _msgLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [MKCustomUIAdopter customButtonWithTitle:@""
                                                         target:self
                                                         action:@selector(rightButtonPressed)];
        _rightButton.titleLabel.font = MKFont(12.f);
    }
    return _rightButton;
}

@end
