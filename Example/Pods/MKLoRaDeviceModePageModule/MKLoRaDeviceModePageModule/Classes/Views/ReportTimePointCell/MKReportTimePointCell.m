//
//  MKReportTimePointCell.m
//  MKLoRaDeviceModePageModule_Example
//
//  Created by aa on 2025/5/11.
//  Copyright © 2025 aadyx2007@163.com. All rights reserved.
//

#import "MKReportTimePointCell.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

static CGFloat const deleteButtonWidth = 75.0f;

static CGFloat const hourButtonWidth = 40.f;
static CGFloat const hourButtonHeight = 25.f;

@implementation MKReportTimePointCellModel
@end

@interface MKReportTimePointCell ()

/**
 所有标签都位于这个上面
 */
@property (nonatomic, strong)UIView *contentPanel;

@property (nonatomic, strong)UIView *deleteBackView;

@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *hourButton;

@property (nonatomic, strong)UIButton *timeSpaceButton;

@property (nonatomic, strong)UIView *bottomLine;

/**
 是否需要重新设置cell子控件坐标，
 */
@property (nonatomic, assign)BOOL shouldSetFrame;

@property (nonatomic, strong)NSMutableArray *hourList;

@property (nonatomic, strong)NSMutableArray *timeSpaceList;

@end

@implementation MKReportTimePointCell

+ (MKReportTimePointCell *)initCellWithTableView:(UITableView *)tableView {
    MKReportTimePointCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKReportTimePointCellIdenty"];
    if (!cell) {
        cell = [[MKReportTimePointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKReportTimePointCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.deleteBackView];
        [self.contentView addSubview:self.contentPanel];
        
        [self.contentPanel addSubview:self.msgLabel];
        [self.contentPanel addSubview:self.hourButton];
        [self.contentPanel addSubview:self.timeSpaceButton];
        [self.contentPanel addSubview:self.bottomLine];
        
        [self.deleteBackView addSubview:self.deleteButton];
        
        [self updateTimeValues];
        
        [self addSwipeRecognizer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentPanel setFrame:self.contentView.bounds];
    [self.deleteBackView setFrame:self.contentView.bounds];
    
    [self.deleteButton setFrame:CGRectMake(self.contentView.frame.size.width - deleteButtonWidth,
                                              0,
                                              deleteButtonWidth,
                                           self.contentView.frame.size.height)];
    
    [self.msgLabel setFrame:CGRectMake(15.f,
                                       (self.contentView.frame.size.height - MKFont(13.f).lineHeight) / 2,
                                       130.f,
                                       MKFont(13.f).lineHeight)];
    
    [self.timeSpaceButton setFrame:CGRectMake(self.contentView.frame.size.width - 15.f - hourButtonWidth,
                                              (self.contentView.frame.size.height - hourButtonHeight) / 2,
                                              hourButtonWidth,
                                              hourButtonHeight)];
    [self.hourButton setFrame:CGRectMake(self.contentView.frame.size.width - 2 * 15.f - 2 * hourButtonWidth,
                                         (self.contentView.frame.size.height - hourButtonHeight) / 2,
                                         hourButtonWidth,
                                         hourButtonHeight)];
    [self.bottomLine setFrame:CGRectMake(15.f,
                                         self.contentView.frame.size.height - CUTTING_LINE_HEIGHT,
                                         self.contentView.frame.size.width - 30.f,
                                         CUTTING_LINE_HEIGHT)];
}

#pragma mark - event method
- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mk_cellDeleteButtonPressed:)]) {
        [self.delegate mk_cellDeleteButtonPressed:self.dataModel.index];
    }
}

- (void)hourButtonPressed {
    if (self.contentPanel.frame.origin.x < 0){
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentPanel.frame;
            frame.origin.x += deleteButtonWidth;
            self.contentPanel.frame = frame;
            self.shouldSetFrame = NO;
        }];
        return;
    }
    
    NSInteger selectedRow = 0;
    for (NSInteger i = 0; i < self.hourList.count; i ++) {
        if ([self.hourButton.titleLabel.text isEqualToString:self.hourList[i]]) {
            selectedRow = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.hourList selectedRow:selectedRow block:^(NSInteger currentRow) {
        [self.hourButton setTitle:self.hourList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mk_hourButtonPressed:hour:)]) {
            [self.delegate mk_hourButtonPressed:self.dataModel.index hour:currentRow];
        }
    }];
}

- (void)timeSpaceButtonPressed {
    if (self.contentPanel.frame.origin.x < 0){
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentPanel.frame;
            frame.origin.x += deleteButtonWidth;
            self.contentPanel.frame = frame;
            self.shouldSetFrame = NO;
        }];
        return;
    }
    
    NSInteger selectedRow = 0;
    for (NSInteger i = 0; i < self.timeSpaceList.count; i ++) {
        if ([self.timeSpaceButton.titleLabel.text isEqualToString:self.timeSpaceList[i]]) {
            selectedRow = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.timeSpaceList selectedRow:selectedRow block:^(NSInteger currentRow) {
        [self.timeSpaceButton setTitle:self.timeSpaceList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mk_timeSpaceButtonPressed:timeSpace:)]) {
            [self.delegate mk_timeSpaceButtonPressed:self.dataModel.index timeSpace:currentRow];
        }
    }];
}

- (void)contentPanelTapAction {
    if (self.contentPanel.frame.origin.x == 0) {
        if ([self.delegate respondsToSelector:@selector(mk_cellTapAction)]) {
            [self.delegate mk_cellTapAction];
        }
        return;
    }
    if (self.contentPanel.frame.origin.x < 0){
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentPanel.frame;
            frame.origin.x += deleteButtonWidth;
            self.contentPanel.frame = frame;
            self.shouldSetFrame = NO;
        }];
        return;
    }
}

- (void)swipeEventBeTriggered:(UISwipeGestureRecognizer *)swipeGesture{
    if ([self.delegate respondsToSelector:@selector(mk_cellResetFrame)]) {
        [self.delegate mk_cellResetFrame];
    }
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft){
        if (self.contentPanel.frame.origin.x == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.contentPanel.frame;
                frame.origin.x -= deleteButtonWidth;
                self.contentPanel.frame = frame;
                self.shouldSetFrame = YES;
            }];
        }
        return;
    }
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionRight){
        if (self.contentPanel.frame.origin.x < 0) {
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.contentPanel.frame;
                frame.origin.x += deleteButtonWidth;
                self.contentPanel.frame = frame;
                self.shouldSetFrame = NO;
            }];
        }
        return;
    }
}

#pragma mark - public method
- (void)resetCellFrame{
    if (self.shouldSetFrame && self.contentPanel.frame.origin.x < 0) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentPanel.frame;
            frame.origin.x += deleteButtonWidth;
            self.contentPanel.frame = frame;
            self.shouldSetFrame = NO;
        }];
    }
}

- (BOOL)canReset{
    return self.shouldSetFrame;
}

- (void)resetFlagForFrame{
    self.shouldSetFrame = NO;
}

#pragma mark - setter
- (void)setDataModel:(MKReportTimePointCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    self.msgLabel.text = SafeStr(_dataModel.msg);
    if (_dataModel.hour < self.hourList.count) {
        [self.hourButton setTitle:self.hourList[_dataModel.hour] forState:UIControlStateNormal];
    }
    if (_dataModel.timeSpace < self.timeSpaceList.count) {
        [self.timeSpaceButton setTitle:self.timeSpaceList[_dataModel.timeSpace] forState:UIControlStateNormal];
    }
}

#pragma mark - private method
- (void)addSwipeRecognizer{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] init];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeft addTarget:self action:@selector(swipeEventBeTriggered:)];
    [self.contentPanel addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] init];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight addTarget:self action:@selector(swipeEventBeTriggered:)];
    [self.contentPanel addGestureRecognizer:swipeRight];
}

- (void)updateTimeValues {
    for (NSInteger i = 0; i < 60; i ++) {
        NSString *minute = [NSString stringWithFormat:@"%@",@(i)];
        if (minute.length == 1) {
            minute = [@"0" stringByAppendingString:minute];
        }
        [self.timeSpaceList addObject:minute];
    }
    
    for (NSInteger i = 0; i < 24; i ++) {
        NSString *hour = [NSString stringWithFormat:@"%@",@(i)];
        if (hour.length == 1) {
            hour = [@"0" stringByAppendingString:hour];
        }
        [self.hourList addObject:hour];
    }
}

#pragma mark - getter
- (UIView *)contentPanel {
    if (!_contentPanel) {
        _contentPanel = [[UIView alloc] init];
        _contentPanel.backgroundColor = COLOR_WHITE_MACROS;
        [_contentPanel addTapAction:self selector:@selector(contentPanelTapAction)];
    }
    return _contentPanel;
}

- (UIView *)deleteBackView {
    if (!_deleteBackView) {
        _deleteBackView = [[UIView alloc] init];
        _deleteBackView.backgroundColor = COLOR_WHITE_MACROS;
    }
    return _deleteBackView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [_deleteButton setBackgroundColor:[UIColor redColor]];
        [_deleteButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:MKFont(13.f)];
        
        [_deleteButton addTarget:self
                          action:@selector(deleteButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(13.f);
    }
    return _msgLabel;
}

- (UIButton *)hourButton {
    if (!_hourButton) {
        _hourButton = [MKCustomUIAdopter customButtonWithTitle:@"00"
                                                        target:self
                                                        action:@selector(hourButtonPressed)];
    }
    return _hourButton;
}

- (UIButton *)timeSpaceButton {
    if (!_timeSpaceButton) {
        _timeSpaceButton = [MKCustomUIAdopter customButtonWithTitle:@"00"
                                                             target:self
                                                             action:@selector(timeSpaceButtonPressed)];
    }
    return _timeSpaceButton;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = CUTTING_LINE_COLOR;
    }
    return _bottomLine;
}

- (NSMutableArray *)hourList {
    if (!_hourList) {
        _hourList = [NSMutableArray array];
    }
    return _hourList;
}

- (NSMutableArray *)timeSpaceList {
    if (!_timeSpaceList) {
        _timeSpaceList = [NSMutableArray array];
    }
    return _timeSpaceList;
}

@end
