//
//  MKMUTimeSegmentedCell.m
//  MKLoRaWAN-MTE_Example
//
//  Created by aa on 2024/11/21.
//  Copyright © 2024 lovexiaoxia. All rights reserved.
//

#import "MKMUTimeSegmentedCell.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKCustomUIAdopter.h"
#import "MKPickerView.h"

static CGFloat const deleteButtonWidth = 75.0f;

static CGFloat const hourButtonWidth = 40.f;
static CGFloat const hourButtonHeight = 25.f;

@implementation MKMUTimeSegmentedCellModel
@end

@interface MKMUTimeSegmentedCell ()

/**
 所有标签都位于这个上面
 */
@property (nonatomic, strong)UIView *contentPanel;

@property (nonatomic, strong)UIView *deleteBackView;

@property (nonatomic, strong)UIButton *deleteButton;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *startHourButton;

@property (nonatomic, strong)UIButton *startMiniuteButton;

@property (nonatomic, strong)UILabel *toLabel;

@property (nonatomic, strong)UIButton *endHourButton;

@property (nonatomic, strong)UIButton *endMiniuteButton;

@property (nonatomic, strong)UILabel *intervalMsgLabel;

@property (nonatomic, strong)MKTextField *intervalTextField;

@property (nonatomic, strong)UILabel *intervalUnitLabel;

@property (nonatomic, strong)UIView *bottomLine;

/**
 是否需要重新设置cell子控件坐标，
 */
@property (nonatomic, assign)BOOL shouldSetFrame;

@property (nonatomic, strong)NSMutableArray *hourList;

@property (nonatomic, strong)NSMutableArray *minuteGearList;

@end

@implementation MKMUTimeSegmentedCell

+ (MKMUTimeSegmentedCell *)initCellWithTableView:(UITableView *)tableView {
    MKMUTimeSegmentedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKMUTimeSegmentedCellIdenty"];
    if (!cell) {
        cell = [[MKMUTimeSegmentedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKMUTimeSegmentedCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.deleteBackView];
        [self.contentView addSubview:self.contentPanel];
        
        [self.contentPanel addSubview:self.msgLabel];
        [self.contentPanel addSubview:self.startHourButton];
        [self.contentPanel addSubview:self.startMiniuteButton];
        [self.contentPanel addSubview:self.toLabel];
        [self.contentPanel addSubview:self.endHourButton];
        [self.contentPanel addSubview:self.endMiniuteButton];
        [self.contentPanel addSubview:self.intervalMsgLabel];
        [self.contentPanel addSubview:self.intervalTextField];
        [self.contentPanel addSubview:self.intervalUnitLabel];
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
    
    CGFloat offsetY = 10.0;
    
    [self.msgLabel setFrame:CGRectMake(15.f,
                                       offsetY,
                                       self.contentView.frame.size.width - 2 * 15.f,
                                       MKFont(13.f).lineHeight)];
    
    offsetY += MKFont(13.f).lineHeight;
    offsetY += 10.f;
    
    
    CGFloat buttonOffsetX = 15.f;
    [self.startHourButton setFrame:CGRectMake(buttonOffsetX,
                                              offsetY,
                                              hourButtonWidth,
                                              hourButtonHeight)];
    buttonOffsetX += (hourButtonWidth + 15.f);
    [self.startMiniuteButton setFrame:CGRectMake(buttonOffsetX,
                                                 offsetY,
                                         hourButtonWidth,
                                         hourButtonHeight)];
    
    buttonOffsetX += (hourButtonWidth + 15.f);
    
    CGFloat toLabelWidth = 50.f;
    [self.toLabel setFrame:CGRectMake(buttonOffsetX, offsetY, toLabelWidth, MKFont(12.f).lineHeight)];
    
    buttonOffsetX += (toLabelWidth + 15.f);
    
    [self.endHourButton setFrame:CGRectMake(buttonOffsetX,
                                                    offsetY,
                                                    hourButtonWidth,
                                                    hourButtonHeight)];
    buttonOffsetX += (hourButtonWidth + 15.f);
    [self.endMiniuteButton setFrame:CGRectMake(buttonOffsetX,
                                                    offsetY,
                                               hourButtonWidth,
                                               hourButtonHeight)];
    
    offsetY += (10.f + hourButtonHeight);
    
    CGFloat intervalOffsetX = 15.f;
    CGFloat intervalMsgLabelWidth = 150.f;
    
    [self.intervalMsgLabel setFrame:CGRectMake(intervalOffsetX, offsetY, intervalMsgLabelWidth, hourButtonHeight)];
    intervalOffsetX += (intervalMsgLabelWidth + 30.f);
    
    [self.intervalTextField setFrame:CGRectMake(intervalOffsetX, offsetY, intervalMsgLabelWidth, hourButtonHeight)];
    
    intervalOffsetX += (intervalMsgLabelWidth + 5.f);
    
    [self.intervalUnitLabel setFrame:CGRectMake(intervalOffsetX, offsetY, 30.f, hourButtonHeight)];
        
    [self.bottomLine setFrame:CGRectMake(15.f,
                                         self.contentView.frame.size.height - CUTTING_LINE_HEIGHT,
                                         self.contentView.frame.size.width - 30.f,
                                         CUTTING_LINE_HEIGHT)];
}

#pragma mark - event method
- (void)deleteButtonPressed {
    if ([self.delegate respondsToSelector:@selector(mu_timeSegmentedCell_deleteButtonPressed:)]) {
        [self.delegate mu_timeSegmentedCell_deleteButtonPressed:self.dataModel.index];
    }
}

- (void)startHourButtonPressed {
    [self hourButtonPressed:YES];
}

- (void)startMiniuteButtonPressed {
    [self miniuteButtonPressed:YES];
}

- (void)endHourButtonPressed {
    [self hourButtonPressed:NO];
}

- (void)endMiniuteButtonPressed {
    [self miniuteButtonPressed:NO];
}

- (void)contentPanelTapAction {
    if (self.contentPanel.frame.origin.x == 0) {
        if ([self.delegate respondsToSelector:@selector(mu_cellTapAction)]) {
            [self.delegate mu_cellTapAction];
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
    if ([self.delegate respondsToSelector:@selector(mu_cellResetFrame)]) {
        [self.delegate mu_cellResetFrame];
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
- (void)setDataModel:(MKMUTimeSegmentedCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKMUTimeSegmentedCellModel.class]) {
        return;
    }
    self.msgLabel.text = [NSString stringWithFormat:@"Time period %@",@(_dataModel.index + 1)];
    if (_dataModel.startHour < self.hourList.count) {
        [self.startHourButton setTitle:self.hourList[_dataModel.startHour] forState:UIControlStateNormal];
    }
    if (_dataModel.startMinuteGear < self.minuteGearList.count) {
        [self.startMiniuteButton setTitle:self.minuteGearList[_dataModel.startMinuteGear] forState:UIControlStateNormal];
    }
    if (_dataModel.endHour < self.hourList.count) {
        [self.endHourButton setTitle:self.hourList[_dataModel.endHour] forState:UIControlStateNormal];
    }
    if (_dataModel.endMinuteGear < self.minuteGearList.count) {
        [self.endMiniuteButton setTitle:self.minuteGearList[_dataModel.endMinuteGear] forState:UIControlStateNormal];
    }
    self.intervalMsgLabel.text = [NSString stringWithFormat:@"Report Interval %@",@(_dataModel.index + 1)];
    self.intervalTextField.text = SafeStr(_dataModel.interval);
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
        [self.minuteGearList addObject:minute];
    }
    
    for (NSInteger i = 0; i < 24; i ++) {
        NSString *hour = [NSString stringWithFormat:@"%@",@(i)];
        if (hour.length == 1) {
            hour = [@"0" stringByAppendingString:hour];
        }
        [self.hourList addObject:hour];
    }
}

- (void)hourButtonPressed:(BOOL)start {
    if (self.contentPanel.frame.origin.x < 0){
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentPanel.frame;
            frame.origin.x += deleteButtonWidth;
            self.contentPanel.frame = frame;
            self.shouldSetFrame = NO;
        }];
        return;
    }
    UIButton *hourButton = (start ? self.startHourButton : self.endHourButton);
    NSInteger selectedRow = 0;
    for (NSInteger i = 0; i < self.hourList.count; i ++) {
        if ([hourButton.titleLabel.text isEqualToString:self.hourList]) {
            selectedRow = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.hourList selectedRow:selectedRow block:^(NSInteger currentRow) {
        [hourButton setTitle:self.hourList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mu_timeSegmentedCell_hourButtonPressed:start:hour:)]) {
            [self.delegate mu_timeSegmentedCell_hourButtonPressed:self.dataModel.index start:start hour:currentRow];
        }
    }];
}

- (void)miniuteButtonPressed:(BOOL)start {
    if (self.contentPanel.frame.origin.x < 0){
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.contentPanel.frame;
            frame.origin.x += deleteButtonWidth;
            self.contentPanel.frame = frame;
            self.shouldSetFrame = NO;
        }];
        return;
    }
    UIButton *miniuteButton = (start ? self.startMiniuteButton : self.endMiniuteButton);
    
    NSInteger selectedRow = 0;
    for (NSInteger i = 0; i < self.minuteGearList.count; i ++) {
        if ([miniuteButton.titleLabel.text isEqualToString:self.minuteGearList]) {
            selectedRow = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.minuteGearList selectedRow:selectedRow block:^(NSInteger currentRow) {
        [miniuteButton setTitle:self.minuteGearList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(mu_timeSegmentedCell_minuteGearButtonPressed:start:minuteGear:)]) {
            [self.delegate mu_timeSegmentedCell_minuteGearButtonPressed:self.dataModel.index start:start minuteGear:currentRow];
        }
    }];
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

- (UIButton *)startHourButton {
    if (!_startHourButton) {
        _startHourButton = [MKCustomUIAdopter customButtonWithTitle:@"00"
                                                             target:self
                                                             action:@selector(startHourButtonPressed)];
    }
    return _startHourButton;
}

- (UIButton *)startMiniuteButton {
    if (!_startMiniuteButton) {
        _startMiniuteButton = [MKCustomUIAdopter customButtonWithTitle:@"00"
                                                                target:self
                                                                action:@selector(startMiniuteButtonPressed)];
    }
    return _startMiniuteButton;
}

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [[UILabel alloc] init];
        _toLabel.textColor = DEFAULT_TEXT_COLOR;
        _toLabel.textAlignment = NSTextAlignmentCenter;
        _toLabel.font = MKFont(12.f);
        _toLabel.text = @"to";
    }
    return _toLabel;
}

- (UIButton *)endHourButton {
    if (!_endHourButton) {
        _endHourButton = [MKCustomUIAdopter customButtonWithTitle:@"00"
                                                           target:self
                                                           action:@selector(endHourButtonPressed)];
    }
    return _endHourButton;
}

- (UIButton *)endMiniuteButton {
    if (!_endMiniuteButton) {
        _endMiniuteButton = [MKCustomUIAdopter customButtonWithTitle:@"00"
                                                              target:self
                                                              action:@selector(endMiniuteButtonPressed)];
    }
    return _endMiniuteButton;
}

- (UILabel *)intervalMsgLabel {
    if (!_intervalMsgLabel) {
        _intervalMsgLabel = [[UILabel alloc] init];
        _intervalMsgLabel.textColor = DEFAULT_TEXT_COLOR;
        _intervalMsgLabel.textAlignment = NSTextAlignmentLeft;
        _intervalMsgLabel.font = MKFont(13.f);
    }
    return _intervalMsgLabel;
}

- (MKTextField *)intervalTextField {
    if (!_intervalTextField) {
        _intervalTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                  placeHolder:@"30 - 86400"
                                                                     textType:mk_realNumberOnly];
        _intervalTextField.maxLength = 5;
        @weakify(self);
        _intervalTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(mu_timeSegmentedCell_reportIntervalChanged:interval:)]) {
                [self.delegate mu_timeSegmentedCell_reportIntervalChanged:self.dataModel.index interval:text];
            }
        };
    }
    return _intervalTextField;
}

- (UILabel *)intervalUnitLabel {
    if (!_intervalUnitLabel) {
        _intervalUnitLabel = [[UILabel alloc] init];
        _intervalUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _intervalUnitLabel.textAlignment = NSTextAlignmentLeft;
        _intervalUnitLabel.font = MKFont(12.f);
        _intervalUnitLabel.text = @"S";
    }
    return _intervalUnitLabel;
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

- (NSMutableArray *)minuteGearList {
    if (!_minuteGearList) {
        _minuteGearList = [NSMutableArray array];
    }
    return _minuteGearList;
}

@end
