//
//  MKMUSynDataCell.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2021/6/19.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKMUSynDataCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

static NSString *const MKMUSynDataCellIdenty = @"MKMUSynDataCellIdenty";

@interface MKMUSynDataCell ()

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UILabel *rawDataLabel;

@property (nonatomic, strong)UIView *lineView;

@end

@implementation MKMUSynDataCell

+ (MKMUSynDataCell *)initCellWithTableView:(UITableView *)tableView {
    MKMUSynDataCell *cell = [tableView dequeueReusableCellWithIdentifier:MKMUSynDataCellIdenty];
    if (!cell) {
        cell = [[MKMUSynDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MKMUSynDataCellIdenty];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = COLOR_WHITE_MACROS;
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.rawDataLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

#pragma mark - super method
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(MKFont(14.f).lineHeight);
    }];
    CGSize rawDataSize = [NSString sizeWithText:self.rawDataLabel.text
                                        andFont:MKFont(14.f)
                                     andMaxSize:CGSizeMake(kViewWidth - 30, MAXFLOAT)];
    [self.rawDataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(rawDataSize.height);
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(CUTTING_LINE_HEIGHT);
    }];
}

#pragma mark -

+ (CGFloat)fetchCellHeight:(NSDictionary *)dataDic {
    NSString *tempTime = @"Time: N/A";
    if (ValidDict(dataDic[@"date"])) {
        tempTime = [@"Time: " stringByAppendingString:dataDic[@"date"]];
    }
    NSString *tempRawData = @"Raw Data: N/A";
    if (ValidStr(dataDic[@"rawData"])) {
        tempRawData = [@"Raw Data: " stringByAppendingString:dataDic[@"rawData"]];
    }
    CGSize rawDataSize = [NSString sizeWithText:tempRawData
                                        andFont:MKFont(14.f)
                                     andMaxSize:CGSizeMake(kViewWidth - 30, MAXFLOAT)];
    CGFloat rawDataHeight = MAX(rawDataSize.height, MKFont(14.f).lineHeight);
    return (MKFont(14.f).lineHeight + rawDataHeight + 30.f);
}

- (void)setDataModel:(NSDictionary *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!ValidDict(_dataModel)) {
        return;
    }
    
    if (ValidStr(dataModel[@"date"])) {
        self.timeLabel.text = [@"Time: " stringByAppendingString:dataModel[@"date"]];
    }else {
        self.timeLabel.text = @"Time: N/A";
    }
    if (ValidStr(dataModel[@"rawData"])) {
        self.rawDataLabel.text = [@"Raw Data: " stringByAppendingString:dataModel[@"rawData"]];
    }else {
        self.rawDataLabel.text = @"Raw Data: N/A";
    }
    [self setNeedsLayout];
}

#pragma mark - setter & getter

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createMsgLabel];
        _timeLabel.text = @"Time:";
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UILabel *)rawDataLabel {
    if (!_rawDataLabel) {
        _rawDataLabel = [self createMsgLabel];
        _rawDataLabel.text = @"Raw Data:";
        _rawDataLabel.numberOfLines = 0;
    }
    return _rawDataLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _lineView;
}

- (UILabel *)createMsgLabel {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = UIColorFromRGB(0x333333);
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(14.f);
    return msgLabel;
}

@end
